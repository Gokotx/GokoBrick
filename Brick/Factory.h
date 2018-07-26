//
//  Factory.h
//  RouterTest
//
//  Created by Goko on 26/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef id(^invokeBlock)(NSArray* paramArr);


@interface Factory : NSObject

singleH(Factory)

+(NSString *)workerIdentifier:(SEL)selector;

//native
+(void)storeWorkerIdentifier:(NSString *)identifier job:(invokeBlock)invokeBlock;
+(id)invokeWorkerWithIdentifier:(NSString *)identifier params:(id)param,...NS_REQUIRES_NIL_TERMINATION;

//remote
+(id)openRemoteUrl:(NSString *)urlString;

@end
