//
//  ThemeImageView.h
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView
//设置图片

@property(nonatomic,copy)NSString *imageName;

@property(nonatomic,assign)UIEdgeInsets edgeInsets;
@end
