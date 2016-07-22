//
//  AppDelegate.h
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

typedef void(^SuccessBlock)(NSString *access);
@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy)SuccessBlock block;

- (void)setBlock:(SuccessBlock)block;

@end

