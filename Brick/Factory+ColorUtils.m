//
//  Factory+ColorUtils.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "Factory+ColorUtils.h"

@implementation Factory (ColorUtils)

+(UIColor *)ColorUtils_randomColor{
    return [Factory invokeWorkerWithIdentifier:[self workerIdentifier:_cmd] params:nil];
}

@end
