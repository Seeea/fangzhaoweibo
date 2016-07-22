//
//  MenuViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewExt.h"
@interface MenuViewController ()<UIGestureRecognizerDelegate>{
    BOOL isCanleft;

    UITableView *_tableView;
    
    
}

@end

@implementation MenuViewController

- (instancetype)initWithMainVC:(UIViewController *)mainVC withLeftVC:(UIViewController *)leftVC{

    if (self = [super init]) {
        _mainVC = mainVC;
        
        _leftVC = leftVC;
        
        [self.view addSubview:_leftVC.view];
        [self.view addSubview:_mainVC.view];
        
        
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        _pan.delegate = self;
        
        _pan.enabled = NO;
        [self.mainVC.view addGestureRecognizer:_pan];

        
        for (UIView *viw in leftVC.view.subviews) {
            if ([viw isKindOfClass:[UITableView class]]) {
                _tableView = (UITableView *)viw;
            }
        }
        _tableView.frame = CGRectMake(0, 0, kMainVCTranslationWidth, kScreenHeight);
        
        _tableView.transform = CGAffineTransformMakeScale(0.8, .8);
    }
    return self;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    isCanleft = YES;
    //  移动距离产生的点（x，y）
    CGPoint point = [pan translationInView:self.view];
    CGFloat instance = kScreenWidth - 100;
    
    //  判断，如果point.x<0 && pan.view.left<0
    //  不是向左划
    if (point.x<=0&&pan.view.left<0) {
        isCanleft=NO;
    }
    
    if (isCanleft &&pan.view.left >= 0 &&pan.view.left < instance) {
        pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y);
//        左边-》右边 scale （1~0.8）  instance
       
        
        CGFloat scale=0.8+0.2 * (instance-point.x)/instance;
        
        pan.view.transform=CGAffineTransformScale(pan.view.transform, scale, scale);
        
        [pan setTranslation:CGPointZero inView:self.view];
        
        //------------------------放   大----------------------------
        
        CGFloat tabScale=1+(1-scale);//1~1.2
        
        _tableView.transform=CGAffineTransformScale(_tableView.transform, tabScale, tabScale);

    }
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        
        if (_mainVC.view.left>=instance/2+30&&_mainVC.view.left <instance) {
            [self openVVC];
        }else{
            [self closeVVC];
        }
        
    }

}

- (void)openVVC{
[UIView animateWithDuration:.25 animations:^{
    _mainVC.view.transform = CGAffineTransformMakeScale( kMainVCScale,kMainVCScale);
    
    
//    _mainVC.view.transform = CGAffineTransformTranslate(_mainVC.view.transform, kMainVCTranslationWidth, 0);
    
    _mainVC.view.center = CGPointMake(kMainVCTranslationWidth+(kScreenWidth*0.8)/2, kScreenHeight/2);
    
    _tableView.transform = CGAffineTransformIdentity;
}];
    _isOpen = YES;

}

//隐藏侧栏控制器
-(void)closeVVC{
    
    [UIView animateWithDuration:.25 animations:^{
        
        _mainVC.view.transform=CGAffineTransformIdentity;
        _mainVC.view.center = self.view.center;
        
        _tableView.transform = CGAffineTransformMakeScale(.8, .8);
    }];
    
    _isOpen=NO;
}








- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
