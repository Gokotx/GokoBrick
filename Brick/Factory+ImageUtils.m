//
//  Factory+ImageUtils.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "Factory+ImageUtils.h"

@implementation Factory (ImageUtils)

+(UIImage*)ImageUtils_showImage:(NSString *)name type:(NSString *)type{
    UIImage * image = [Factory invokeWorkerWithIdentifier:[self workerIdentifier:_cmd] params:name,type,nil];
    return image;
}

+(UIImage *)ImageUtils_blurryImage:(UIImage *)image blur:(CGFloat)blur{
    UIImage * resultImage = [Factory invokeWorkerWithIdentifier:[self workerIdentifier:_cmd] params:image,@(blur),nil];
    return resultImage;
}

@end
