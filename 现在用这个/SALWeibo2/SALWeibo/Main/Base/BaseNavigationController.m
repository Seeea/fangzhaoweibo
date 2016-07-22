//
//  BaseNavigationController.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self =[super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChanged object:nil];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *image=[UIImage imageNamed:@"mask_titlebar.png"];
//    
//    CGImageRef cgImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, kScreenWidth, 64));
//    
//    //  设置导航拉背景图
//    [self.navigationBar setBackgroundImage:[UIImage imageWithCGImage:cgImage] forBarMetrics:UIBarMetricsDefault];
//    
//    CGImageRelease(cgImage);
    [self themeDidChanged];
}

- (void)themeDidChanged{
    
    UIImage *image=[[ThemeManager sharedInstance]getImageWithImageName:@"mask_titlebar.png"];
    
    CGImageRef cgImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, kScreenWidth, 64));

    
    //  设置导航拉背景图
    [self.navigationBar setBackgroundImage:[UIImage imageWithCGImage:cgImage] forBarMetrics:UIBarMetricsDefault];
    
    CGImageRelease(cgImage);
    
    UIColor *color = [[ThemeManager sharedInstance]getColorWithColorName:@"Mask_Title_color"];
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
                          NSForegroundColorAttributeName:color
                          };
    [self.navigationBar setTitleTextAttributes:dic];
    
}

@end
