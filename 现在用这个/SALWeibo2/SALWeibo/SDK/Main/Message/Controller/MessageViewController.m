//
//  MessageViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "MessageViewController.h"
#import "WeiboFacePanelView.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    WeiboFaceView *faceView = [[WeiboFaceView alloc]initWithFrame:CGRectZero];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
//    
//    scrollView.contentSize = CGSizeMake(4*kScreenWidth, 300);
//    
//    scrollView.pagingEnabled = YES;
//    
//    [scrollView addSubview:faceView];
//    
//    [self.view addSubview: scrollView];
//    
    WeiboFacePanelView *panelView=[[WeiboFacePanelView alloc]initWithFrame:CGRectMake(0, 100, 0, 0)];
    
    [self.view addSubview:panelView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
