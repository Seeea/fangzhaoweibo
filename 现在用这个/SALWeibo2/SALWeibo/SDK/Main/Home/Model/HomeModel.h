//
//  HomeModel.h
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WXBaseModel.h"
#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface HomeModel : WXBaseModel
@property(nonatomic, copy) NSString *created_at;    //微博的创建时间
@property(nonatomic, strong) NSNumber *weiboID;     //微博ID
@property(nonatomic, copy) NSString *text;          //微博内容
@property(nonatomic, copy) NSString *source;        //微博来源
@property(nonatomic, strong) NSNumber *favorited;   //是否已经收藏
@property(nonatomic, copy) NSString *thumbnail_pic; //缩略图地址
@property(nonatomic, copy) NSString *bmiddle_pic;   //中等尺寸图片地址
@property(nonatomic, copy) NSString *original_pic;  //原始图片地址
@property(nonatomic, strong) NSDictionary *geo;     //地理信息字段
@property(nonatomic, strong) UserModel *user;       //微博用户
@property(nonatomic, strong) HomeModel *retweeted_status; //转发的微博
@property(nonatomic, strong) NSNumber *reposts_count;      //转发数
@property(nonatomic, strong) NSNumber *comments_count;     //评论数
@property(nonatomic, strong) NSNumber *attitudes_count;    //表态数
@property(nonatomic,strong)NSArray *pic_urls;
@end
