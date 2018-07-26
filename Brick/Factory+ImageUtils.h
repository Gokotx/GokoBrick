//
//  Factory+ImageUtils.h
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "Factory.h"

@interface Factory (ImageUtils)

+(UIImage*)ImageUtils_showImage:(NSString *)name type:(NSString *)type;

+(UIImage *)ImageUtils_blurryImage:(UIImage *)image blur:(CGFloat)blur;



@end
