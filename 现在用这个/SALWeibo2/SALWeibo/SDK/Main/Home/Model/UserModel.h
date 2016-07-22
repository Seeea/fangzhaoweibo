//
//  UserModel.h
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WXBaseModel.h"

@interface UserModel : WXBaseModel
@property(nonatomic, copy) NSString *idstr;        //字符串型的用户UID
@property(nonatomic, copy) NSString *screen_name;  //用户昵称
@property(nonatomic, copy) NSString *name;         //友好显示名称
@property(nonatomic, copy) NSString *location;     //用户所在地
@property(nonatomic, copy) NSString *url;          //用户博客地址
@property(nonatomic, copy) NSString *avatar_large; //用户大头像地址
@property(nonatomic, strong) NSNumber *followers_count;         //粉丝数
@property(nonatomic, strong) NSNumber *friends_count;           //关注数
@property(nonatomic, strong) NSNumber *statuses_count;          //微博数
@property(nonatomic, strong) NSNumber *favourites_count;        //收藏数
@property(nonatomic, copy, readonly) NSString *userdescription; //用户个人描述
@property(nonatomic, copy) NSString *gender; //性别，m：男、f：女、n：未知
@property(nonatomic, strong)
NSNumber *verified; //是否是微博认证用户，即加V用户，true：是，false：否
@property(nonatomic, copy)
NSString *profile_image_url; //用户头像地址，50×50像素
@end
