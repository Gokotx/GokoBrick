//
//  ColorUtils.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "ColorUtils.h"

@implementation ColorUtils

+(void)load{
    [Factory storeWorkerIdentifier:[self requestIdentifierWithSEL:@selector(randomColor)] job:^id(NSArray *paramArr) {
        return [self randomColor];
    }];
}
+(UIColor *)randomColor{
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
}

@end
