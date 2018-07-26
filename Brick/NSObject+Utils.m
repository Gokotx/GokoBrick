//
//  NSObject+MethodIdentify.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@implementation NSObject (Utils)

+(NSString *)requestIdentifierWithSEL:(SEL)selector{
    NSString * workshopStr  = NSStringFromClass([Factory class]);
    NSString * classStr = NSStringFromClass(self);
    NSString * selectorStr = NSStringFromSelector(selector);
    NSString * identifier = [NSString stringWithFormat:@"%@+%@_%@",workshopStr,classStr,selectorStr];
    NSLog(@"%@",identifier);
    return identifier;
}



-(void)currentMalloc{
    NSLog(@"Size of %@: %zd", NSStringFromClass(self.class),malloc_size((__bridge const void *)self));
}

-(id)performSelector:(SEL)selector withParams:(id)firstParam, ...{
    NSArray * params = TotalParams(firstParam);
    NSMethodSignature * signature = [self methodSignatureForSelector:selector];
    if (nil == signature) {
        //传入的方法不存在 就抛异常
        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",self,NSStringFromSelector(selector)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    NSInteger arguments = signature.numberOfArguments-2;
    NSUInteger paramsCount = params.count;
    
    //防止传入的参数个数不正确
    NSInteger count = MIN(arguments, paramsCount);
    for (int i = 0; i<count; i++) {
        NSObject*obj = params[i];
        //处理参数是NULL类型的情况
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i+2];
    }
    [invocation invoke];
    //返回值
    __autoreleasing id returnValue = nil;
    if (signature.methodReturnLength!=0) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}





-(void)addProperty:(NSString *)propertyName withValue:(id)value{
    //先判断有没有这个属性，没有就添加，有就直接赋值
    Ivar ivar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return;
    }
    
    /*
     objc_property_attribute_t type = { "T", "@\"NSString\"" };
     objc_property_attribute_t ownership = { "C", "" }; // C = copy
     objc_property_attribute_t backingivar  = { "V", "_privateName" };
     objc_property_attribute_t attrs[] = { type, ownership, backingivar };
     class_addProperty([SomeClass class], "name", attrs, 3);
     */
    
    //objc_property_attribute_t所代表的意思可以调用getPropertyNameList打印，大概就能猜出
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])] UTF8String] };
    objc_property_attribute_t ownership = { "&", "N" };
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    if (class_addProperty([self class], [propertyName UTF8String], attrs, 3)) {
        
        //添加get和set方法
        class_addMethod([self class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([self class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        //赋值
        [self setValue:value forKey:propertyName];
        NSLog(@"%@", [self valueForKey:propertyName]);
        
        NSLog(@"创建属性Property成功");
    } else {
        class_replaceProperty([self class], [propertyName UTF8String], attrs, 3);
        //添加get和set方法
        class_addMethod([self class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([self class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        //赋值
        [self setValue:value forKey:propertyName];
    }
}

-(id)propertyValue:(NSString *)propertyName{
    //先判断有没有这个属性，没有就添加，有就直接赋值
    Ivar ivar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return object_getIvar(self, ivar);
    }
    
    ivar = class_getInstanceVariable([self class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dict = object_getIvar(self, ivar);
    if (dict && [dict objectForKey:propertyName]) {
        return [dict objectForKey:propertyName];
    } else {
        return nil;
    }
}
id getter(id self1, SEL _cmd1) {
    NSString *key = NSStringFromSelector(_cmd1);
    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
    return [dictCustomerProperty objectForKey:key];
}

void setter(id self1, SEL _cmd1, id newValue) {
    //移除set
    NSString *key = [NSStringFromSelector(_cmd1) stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    //首字母小写
    NSString *head = [key substringWithRange:NSMakeRange(0, 1)];
    head = [head lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:head];
    //移除后缀 ":"
    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
    
    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
    if (!dictCustomerProperty) {
        dictCustomerProperty = [NSMutableDictionary dictionary];
        object_setIvar(self1, ivar, dictCustomerProperty);
    }
    [dictCustomerProperty setObject:newValue forKey:key];
}

+(NSArray *)allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    ///存储属性的个数
    unsigned int propertyCount = 0;
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(self, &propertyCount);
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    ///释放
    free(propertys);
    return allNames;
}



@end
