//
//  WeiboCellLayout.h
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
@interface WeiboCellLayout : NSObject

@property(nonatomic,strong)HomeModel *model;

//1.计算整个单元格高度

//2.计算子视图的布局


//整个单元格frame
@property(nonatomic,assign)CGRect frame;

//微博正文
@property(nonatomic,assign)CGRect textFrame;

//正文图片
@property(nonatomic,assign)CGRect picFrame;

//转发正文
@property(nonatomic,assign)CGRect retweedTextFrame;

//转发图片
@property(nonatomic,assign)CGRect retweedPicFrame;

//转发背景图
@property(nonatomic,assign)CGRect retweedBgImageFrame;

//存放所有图片的数组
@property(nonatomic,strong)NSMutableArray *weiboImaViewFrames;

//多图部分的高度
@property(nonatomic,assign)CGFloat imagesHeight;

@end
