//
//  ThemeLabel.m
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChanged object:nil];
    }
    
    return self;
}

-(void)awakeFromNib{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChanged object:nil];
}


-(void)themeDidChanged{
    UIColor *color = [[ThemeManager sharedInstance]getColorWithColorName:_colorName];
    self.textColor = color;
}

- (void)setColorName:(NSString *)colorName{

    _colorName = colorName;
    [self themeDidChanged];

}
@end
