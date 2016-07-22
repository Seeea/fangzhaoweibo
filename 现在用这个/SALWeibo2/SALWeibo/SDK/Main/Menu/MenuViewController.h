//
//  MenuViewController.h
//  SALWeibo
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabbarController.h"
#import "LeftViewController.h"
@interface MenuViewController : UIViewController

- (instancetype)initWithMainVC :(UIViewController *)mainVC withLeftVC :(UIViewController *)leftVC;

@property (nonatomic,strong)UIViewController *mainVC;//子视图控制器公开属性，在其他视图控制器可以方便获得
@property (nonatomic,strong)UIViewController *leftVC;

@property (nonatomic) BOOL isOpen;

@property (nonatomic,strong)UIPanGestureRecognizer *pan;

@property (nonatomic,strong)UITapGestureRecognizer *tap;

- (void)openVVC;
- (void)closeVVC;





@end
