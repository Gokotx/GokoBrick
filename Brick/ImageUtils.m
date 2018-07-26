//
//  ImageUtils.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+(void)load{
    [Factory storeWorkerIdentifier:[self requestIdentifierWithSEL:@selector(showImage:type:)] job:^id(NSArray *paramArr) {
        return [self showImage:paramArr[0] type:paramArr[1]];
    }];
    [Factory storeWorkerIdentifier:[self requestIdentifierWithSEL:@selector(blurryImage:withBlurLevel:)] job:^id(NSArray *paramArr) {
        ImageUtils * utils = [[ImageUtils alloc] init];
        return [utils blurryImage:paramArr[0] withBlurLevel:paramArr[1]];
    }];
}
+(UIImage *)showImage:(NSString *)name type:(NSString *)type{
    return [UIImage imageNamed:[name stringByAppendingString:type]];
}

-(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(NSNumber *)blur{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", blur,nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

@end
