//
//  BaseViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChanged object:nil];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self themeDidChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)themeDidChanged{
    
    UIImage *image = [[ThemeManager sharedInstance]getImageWithImageName:@"bg_home.jpg"];
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, kScreenWidth, kScreenHeight));
    //设置每个视图控制器的背景图
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageWithCGImage:cgImage]];
    CGImageRelease(cgImage);
    
}

@end
