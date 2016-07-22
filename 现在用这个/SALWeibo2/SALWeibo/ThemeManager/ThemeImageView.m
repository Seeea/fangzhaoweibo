//
//  ThemeImageView.m
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


-(void)awakeFromNib{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChange) name:kThemeChanged object:nil];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChange) name:kThemeChanged object:nil];
        
    }
    return self;
}
- (void)setImageName:(NSString *)imageName{

    _imageName = imageName;
    [self themeDidChange];

}

- (void)themeDidChange{

    UIImage *image = [[ThemeManager sharedInstance] getImageWithImageName:_imageName];
    //    拉伸图片的方法
    //    [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    if (self.edgeInsets.top||self.edgeInsets.left||self.edgeInsets.bottom||self.edgeInsets.right) {
        image = [image resizableImageWithCapInsets:self.edgeInsets resizingMode:UIImageResizingModeTile];
    }
    self.image = image;
}
@end
