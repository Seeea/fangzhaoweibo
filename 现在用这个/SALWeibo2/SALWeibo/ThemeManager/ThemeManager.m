//
//  ThemeManager.m
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

static ThemeManager *instance;
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    }) ;
    return instance;
}
-(instancetype)init{
    
    if (self=[super init]) {
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        
        //    读取plist文件
        _themeConfig=[NSDictionary dictionaryWithContentsOfFile:path];
        //
        id myThemeName=[[NSUserDefaults standardUserDefaults]objectForKey:kThemeNameUserDefaults];
        
        if (myThemeName==nil) {
            //    设置默认主题
            _themeName=@"猫爷";
        }else{
            _themeName=myThemeName;
            
        }
        
    }
    
    return self;
}

- (void)setThemeName:(NSString *)themeName{
    _themeName = themeName;
   
        //  本地持久化-->plist
    [[NSUserDefaults standardUserDefaults]setObject:themeName forKey:kThemeNameUserDefaults];
    //  使用同步操作使本地化操作立即执行
    [[NSUserDefaults standardUserDefaults]synchronize];
     //发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeChanged object:nil];

}

- (UIImage *)getImageWithImageName:(NSString *)imageName{
    //bundel Path
    //  容错处理
    if (imageName.length==0) {
        
        return nil;
        
    }

    NSString *bundlePath = [[NSBundle mainBundle]resourcePath];
    
    NSString *themePath = [_themeConfig objectForKey:self.themeName];
    
    NSString *fullPath = [themePath stringByAppendingFormat:@"/%@",imageName];
    
    NSString *lastPath =[bundlePath stringByAppendingPathComponent:fullPath];
    
    UIImage *image=  [UIImage imageWithContentsOfFile:lastPath];
    
    return image;


}
#pragma mark - 设置颜色
- (UIColor *)getColorWithColorName:(NSString *)colorName{
    if (colorName==nil) {
        return nil;
    }
    NSString *bundlePath = [[NSBundle mainBundle]resourcePath];
    NSString *themePath = [_themeConfig objectForKey:self.themeName];
    
    NSString *fullPath = [bundlePath stringByAppendingFormat:@"/%@/config.plist",themePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fullPath];
    //取小字典
    NSDictionary *colorDic = [dic objectForKey:colorName];
    
    
    CGFloat red=[colorDic[@"R"] doubleValue];
    CGFloat green=[colorDic[@"G"] doubleValue];
    CGFloat blue=[colorDic[@"B"] doubleValue];
    
    CGFloat alpha=1;
    
    if (colorDic[@"alpha"]) {
        alpha=[colorDic[@"alpha"] doubleValue];
    }
    
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    
    return color;


}
@end
