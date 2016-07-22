//
//  ThemeManager.h
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ThemeManager : NSObject
+(instancetype)sharedInstance;

@property(nonatomic,copy)NSString *themeName;//当前主题的名称
@property(nonatomic,strong)NSDictionary *themeConfig;

//传入不同的图片名称 根据当前主题返回对应的图片
-(UIImage *)getImageWithImageName:(NSString *)imageName;

- (UIColor *)getColorWithColorName:(NSString *)colorName;

@end
