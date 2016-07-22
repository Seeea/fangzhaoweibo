//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by Zheng on 15/4/8.
//  Copyright (c) 2015年 Qingwu Zheng. All rights reserved.
//

#import "WeiboAnnotationView.h"

#import "WXAnnotation.h"
#import "HomeModel.h"
#import "UserModel.h"

@implementation WeiboAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  if (self) {
    [self createViews];
  }

  return self;
}

- (void)createViews {
  userImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
  userImgView.layer.borderColor = [UIColor whiteColor].CGColor;
  userImgView.layer.borderWidth = 1;

  weiboImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
  weiboImgView.backgroundColor = [UIColor blackColor];

  textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  textLabel.font = [UIFont systemFontOfSize:12];
  textLabel.textColor = [UIColor whiteColor];
  textLabel.backgroundColor = [UIColor clearColor];
  textLabel.numberOfLines = 3;

  [self addSubview:weiboImgView];
  [self addSubview:textLabel];
  [self addSubview:userImgView];

  //添加点击的手势
  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapAction:)];
  [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
  //显示微博的详情
}

- (void)layoutSubviews {
  [super layoutSubviews];

  WXAnnotation *annotation = (WXAnnotation *)self.annotation;

  //赋值
  NSString *userImgURL = annotation.model.user.profile_image_url;
  [userImgView sd_setImageWithURL:[NSURL URLWithString:userImgURL]];

  NSString *pic = annotation.model.thumbnail_pic;
  [weiboImgView sd_setImageWithURL:[NSURL URLWithString:pic]];

  textLabel.text = annotation.model.text;

  //布局
  if (annotation.model.thumbnail_pic /*model中有图片*/) {
    //背景图片
    self.image = [UIImage imageNamed:@"nearby_map_photo_bg"];

    textLabel.hidden = YES;
    weiboImgView.hidden = NO;

    //用户头像
    userImgView.frame = CGRectMake(73, 68, 30, 30);
    //微博图片
    weiboImgView.frame = CGRectMake(15, 15, 90, 85);
  } else {
    self.image = [UIImage imageNamed:@"nearby_map_content"];
    textLabel.hidden = NO;
    weiboImgView.hidden = YES;

    //用户头像
    userImgView.frame = CGRectMake(20, 20, 45, 45);
    //微博内容
    textLabel.frame =
        CGRectMake(userImgView.right + 5, userImgView.top, 110, 45);
  }
}

@end
