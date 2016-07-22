//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by Zheng on 15/4/8.
//  Copyright (c) 2015年 Qingwu Zheng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

//WeiboAnnotationView可以理解成cell, 这个cell里面的model必须是MKAnnotation
@interface WeiboAnnotationView : MKAnnotationView {
    UIImageView* userImgView; //头像
    UIImageView* weiboImgView; //微博图片
    UILabel* textLabel; //微博内容
}

@end
