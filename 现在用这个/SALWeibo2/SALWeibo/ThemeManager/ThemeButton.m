//
//  ThemeButton.m
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton
- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChanged object:nil];
    }
    return self;
}
- (void)themeDidChanged{
    UIImage *image = [[ThemeManager sharedInstance]getImageWithImageName:_imageName];
    [self setImage:image forState:UIControlStateNormal];
    
}

-(void)setImageName:(NSString *)imageName{
    
    _imageName=imageName;
    
    
    [self themeDidChanged];
    
}

@end
