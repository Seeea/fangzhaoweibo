//
//  WeiboCell.h
//  SALWeibo
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 Seeea. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
@interface WeiboCell : UITableViewCell

@property(nonatomic,strong)HomeModel *model;//数据源

@property(nonatomic,strong)WeiboCellLayout *layout;//布局对象

//微博正文
@property(nonatomic,strong)WXLabel *weiboTextLabel;

//正文图片
@property(nonatomic,strong,readonly)UIImageView *picImageView;

//转发微博

//转发正文
@property(nonatomic,strong,readonly)WXLabel *retweedTextLabel;

//转发图片
@property(nonatomic,strong,readonly)UIImageView *retweedPicView;

//转发微博背景图
@property(nonatomic,strong,readonly)ThemeImageView *retweedBgImageView;
@end
