//
//  Factory+SecondViewController.m
//  RouterTest
//
//  Created by Goko on 27/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "Factory+SecondViewController.h"

@implementation Factory (SecondViewController)

+(UIViewController *)SecondViewController_initWithTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color{
    return [Factory invokeWorkerWithIdentifier:[self workerIdentifier:_cmd] params:title,image,color,nil];
}

@end
