//
//  MainTabbarController.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "MainTabbarController.h"
#import "ThemeManager.h"
@interface MainTabbarController (){

    ThemeImageView *_tabbarbackImage;//标签栏背景图
    ThemeImageView *_selectedImage;//选中图片
}



@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];
    
    [self creatSubviewControllers];
}
#pragma mark - View Life Circle

- (void)creatSubviewControllers{

    NSArray *storyBArr=@[@"Home",@"Message",@"Square",@"Profile",@"More"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:storyBArr.count];
    
    for (int i=0; i<storyBArr.count; i++) {
        
        //    通过下标获得storyboard名称
        NSString *storyBoardName=storyBArr[i];
        
        //    根据storyboard的名字获得storyboard
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        
        //    使用instantiateInitialViewController获得当前storyboard的入口
        UINavigationController *naviC=[storyBoard instantiateInitialViewController];
        
        
        [viewControllers addObject:naviC];
    }
    
    self.viewControllers=viewControllers;
    

}
//视图将要布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self removeItem];
    
    [self createItem];

}

- (void)removeItem{

    for (UIView *view in self.tabBar.subviews) {
        [view removeFromSuperview];
    }
}

- (void)createItem{
    //  1.创建标签栏背景图
    _tabbarbackImage = [[ThemeImageView alloc]
                        initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabbarHeight)];
    
//    _tabbarbackImage.image = [UIImage imageNamed:@"mask_navbar"];
//    
//    _tabbarbackImage.userInteractionEnabled=YES;
//    
//    [self.tabBar addSubview:_tabbarbackImage];
//
    _tabbarbackImage.imageName = @"mask_navbar";
        _tabbarbackImage.userInteractionEnabled=YES;
    [self.tabBar addSubview:_tabbarbackImage];

    
    
    //  2.创建点击按钮
    NSArray *buttonNames = @[
                             @"home_tab_icon_1",
                             @"home_tab_icon_2",
                             @"home_tab_icon_3",
                             @"home_tab_icon_4",
                             @"home_tab_icon_5"
                             ];
    
    CGFloat buttonWidth=kScreenWidth/(buttonNames.count);
    
    for (int i=0; i<buttonNames.count; i++) {
        
        
        ThemeButton *button=[[ThemeButton alloc]initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, kTabbarHeight)];
        
        NSString *imageName=buttonNames[i];
        
        button.imageName = imageName;
        
        
        button.tag=1000+i;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabbarbackImage addSubview:button];

    }
    //选中按钮切换视图
    _selectedImage = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, 45)];
    _selectedImage.imageName = @"home_bottom_tab_arrow.png";
    
    [self.tabBar addSubview:_selectedImage];
    
    
}

- (void)buttonAction:(UIButton *)but{

    NSInteger index=but.tag-1000;
    
    //  跳转到对应的子控制器
    [self setSelectedIndex:index];
    
    [UIView animateWithDuration:.25 animations:^{
        
        _selectedImage.center=but.center;
    }];


}


@end
