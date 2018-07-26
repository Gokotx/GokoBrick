//
//  Factory.m
//  RouterTest
//
//  Created by Goko on 26/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "Factory.h"
#import <objc/runtime.h>


//2. action.open.home.category.param(value) (需要控制是否存在和父子页面关系)
//3. action.invoke.imageutil.blur.param(value)
@interface Factory ()

@property(nonatomic,strong)NSMutableDictionary * agencyMap;

@end

@implementation Factory

singleM(Factory)

-(NSMutableDictionary *)agencyMap{
    if (_agencyMap == nil) {
        _agencyMap = [NSMutableDictionary dictionary];
    }
    return _agencyMap;
}

+(void)storeWorkerIdentifier:(NSString *)identifier job:(invokeBlock)invokeBlock{
    Factory * client = [Factory shareFactory];
    NSLog(@"%@",identifier);
    [client.agencyMap setValue:invokeBlock forKey:identifier];
    //1w+ block 存储，花费大概1.5M+ 内存。
//    for (int i = 0; i<2000; i++) {
//        [client.agencyMap setValue:invokeBlock forKey:[identifier stringByAppendingString:@(i).stringValue]];
//    }
//    NSLog(@"%ld",client.agencyMap.count);
    [client.agencyMap currentMalloc];
}
+(id)invokeWorkerWithIdentifier:(NSString *)identifier params:(id)param, ...{
    id result = nil;
    NSArray * paramArray = TotalParams(param);
    Factory * workshop = [Factory shareFactory];
    invokeBlock block = (invokeBlock)[workshop.agencyMap valueForKey:identifier];
    if (block) {
        //paramArray 参数个数是否达标的判断，是否缺少参数
        result = block(paramArray);
        NSLog(@"%@",identifier);
    }
    return result;
}


//xxx://[class]/[action]?foo=bar  兼容Android (scheme://xxxx)
+(id)openRemoteUrl:(NSString *)urlString{
    
    return nil;
}

+(NSString *)workerIdentifier:(SEL)selector{
    NSString * workshopStr  = NSStringFromClass([Factory class]);
    NSString * selectorStr = NSStringFromSelector(selector);
    NSString * identifier = [NSString stringWithFormat:@"%@+%@",workshopStr,selectorStr];
    return identifier;
}




@end
