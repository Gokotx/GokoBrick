//
//  Singleton.h
//  ObjectToPointerTest
//
//  Created by Goko on 26/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#define singleH(name) +(instancetype)share##name;

#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}

#endif /* Singleton_h */
