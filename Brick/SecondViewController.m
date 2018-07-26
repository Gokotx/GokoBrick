//
//  SecondViewController.m
//  RouterTest
//
//  Created by Goko on 26/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

+(void)load{
    [Factory storeWorkerIdentifier:[self requestIdentifierWithSEL:@selector(initWithTitle:image:color:)] job:^id(NSArray *paramArr) {
        return [[self alloc] initWithTitle:paramArr[0] image:paramArr[1] color:paramArr[2]];
    }];
    [Factory storeWorkerIdentifier:[self requestIdentifierWithSEL:@selector(initWithTitle:)] job:^id(NSArray *paramArr) {
        return [self initWithTitle:paramArr[0]];
    }];
}

+(instancetype)initWithTitle:(NSString *)title{
    SecondViewController * vc = [self new];
    vc.title = title;
    return vc;
}
-(SecondViewController*)initWithTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color{
    self = [super init];
    if (self){
        self.secondColor = color;
        self.secondTitle = title;
        self.secondImage = image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.secondTitle;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:self.secondImage];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.view.backgroundColor = self.secondColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
