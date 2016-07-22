
//  HomeViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboSDK.h"
#import "HomeModel.h"
#import "WeiboView.h"
#import "WeiboCellLayout.h"
#import "AppDelegate.h"
#import "WXRefresh.h"
#import "MenuViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController (){
    NSNumber *since_id;

    SystemSoundID soundID;
}
@property (weak, nonatomic) IBOutlet WeiboView *myTableView;

@property(nonatomic,strong) NSMutableArray *dataList;

@property(nonatomic,strong)ThemeImageView *notifyImageView;

@end

@implementation HomeViewController

-(ThemeImageView *)notifyImageView{
    
    if (!_notifyImageView) {
        
        //    每次刷新提示栏
        _notifyImageView=[[ThemeImageView alloc]initWithFrame:CGRectMake(20, -40, kScreenWidth-40, 40)];
        
        _notifyImageView.imageName=@"timeline_notify";
        
        //    显示本次新数据条数
        ThemeLabel *countLabel=[[ThemeLabel alloc]initWithFrame:_notifyImageView.bounds];
        
        countLabel.tag=10001;
        
        countLabel.textAlignment=NSTextAlignmentCenter;
        
        countLabel.colorName=@"Link_color";
        
        [_notifyImageView addSubview:countLabel];
        
        [self.view addSubview:_notifyImageView];
    }
    return _notifyImageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate setBlock:^(NSString *access) {
        
        [self firstLoadNewData:access];
    }];

    
    self.dataList = [NSMutableArray array];
    
    self.title=@"首页";
    //取消自动适应navigationbar的高度
    self.automaticallyAdjustsScrollViewInsets = NO;

    __weak HomeViewController *weakSelf = self;
    //下拉刷新
    [self.myTableView addPullDownRefreshBlock:^{
        //保证self不会被释放
        __strong HomeViewController *strongSelf = weakSelf;
        //加载数据
        [strongSelf loadNewData];
    }];
    //上拉加载
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        //    保证self不会被释放
        __strong HomeViewController *strongSelf=weakSelf;
        
        //   加载数据
        //旧数据
        [strongSelf loadOldData];
    }];
}

-(void)firstLoadNewData:(NSString *)accessToken{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:@{ @"count" : @5}];
    
    [MTDataService
     GETWithURLString:@"https://api.weibo.com/2/statuses/home_timeline.json"
     params:params
     headrFields:nil
     accessToken:accessToken complectionBlock:^(id data) {
         [self loadFinishData:data];
     }];
    
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    MenuViewController *menuC=(MenuViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    menuC.pan.enabled=YES;
    
    NSString  *accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:kAccess_token_ID];
    ////  如果没有数据，先登录
    if (accessToken.length==0) {
        
        [self loginAction:nil];
            
        
    }else{
        [self loadNewData];
        
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    MenuViewController *menuC=(MenuViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    menuC.pan.enabled=NO;
    
    
}


//刷新
- (IBAction)refreshAction:(id)sender {

    MenuViewController *menu = (MenuViewController *)self.view.window.rootViewController;
    if (menu.isOpen) {
        [menu closeVVC];
    }
        else{
        [menu openVVC];
    }
    
}
//登录
- (IBAction)loginAction:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    [WeiboSDK sendRequest:request];
}

- (void)loadNewData{
      since_id=@0;

    if (self.dataList.count != 0 ) {
        WeiboCellLayout *layout = self.dataList[0];
        since_id = layout.model.weiboID;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"count" : @5 ,@"since_id":[NSString stringWithFormat:@"%@",since_id]}];
    [MTDataService
     GETWithURLString:@"https://api.weibo.com/2/statuses/home_timeline.json"
     params:params
     headrFields:nil
     complectionBlock:^(id data){
         [self loadFinishData:data];
     
     }];

}

- (void)loadFinishData:(id)data{
    NSArray *array=[data objectForKey:@"statuses"];
    //储存新数据数组
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSMutableArray *visibleArr=[NSMutableArray array];

    for (NSDictionary *status in array) {
        
        HomeModel *model=[[HomeModel alloc]initWithDataDic:status];
        
        
        WeiboCellLayout *layout=[[WeiboCellLayout alloc]init];
        
        layout.model=model;
        
        [mutableArr addObject:layout];
//        //    如果不是第一次进入程序
//        if (![since_id intValue]==0) {
//            
//            //      如果有新数据则添加
//            [visibleArr addObject:@"0"];
//            
//        }

    }
    //拼接数组
    [mutableArr addObjectsFromArray:self.dataList];
    //datalist获取数组
    self.dataList = mutableArr;
    
        _myTableView.dataList = self.dataList;
        [_myTableView reloadData];

    [self.myTableView.pullToRefreshView stopAnimating];
//通过since_id获得更新数量
    NSString *sinceStr=[NSString stringWithFormat:@"%@",since_id];
    
    ThemeLabel *countLabel=(ThemeLabel *)[self.notifyImageView viewWithTag:10001];
    
    if (![sinceStr isEqualToString:@"0"] ) {
        
        self.notifyImageView.hidden=NO;
        countLabel.text=[NSString stringWithFormat:@"更新了%ld条新微博",visibleArr.count];
        
    }else{
        
        self.notifyImageView.hidden=YES;
    }
    //  每次刷新完成释放掉
//    visibleArr=nil;
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.notifyImageView.transform=CGAffineTransformMakeTranslation(0, 50+64);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.35 delay:2 options:0 animations:^{
            
            self.notifyImageView.transform=CGAffineTransformIdentity;
        } completion:nil];
        
    }];
   
  
    //  播放声音
    if (!self.notifyImageView.hidden) {
        NSString *sysPath=[[NSBundle mainBundle]pathForResource:@"msgcome" ofType:@"wav"];
        
        NSURL *sysUrl=[NSURL fileURLWithPath:sysPath];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sysUrl, &soundID);
        
        //    播放系统声音
        AudioServicesPlaySystemSound(soundID);
        
        //  播放震动只能真机演示
        //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }



}

//上拉加载
- (void)loadOldData{
    NSNumber *max_id = @0;
    
    if (self.dataList.count!=0) {
        WeiboCellLayout *layout=[self.dataList lastObject];
        
        max_id = layout.model.weiboID;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"count" : @5 ,@"max_id":[NSString stringWithFormat:@"%@",max_id]}];
    
    [MTDataService
     GETWithURLString:@"https://api.weibo.com/2/statuses/home_timeline.json"
     params:params
     headrFields:nil
     complectionBlock:^(id data){
         [self loadOldFinishData:data];
         
     }];

}
- (void)loadOldFinishData:(id)data{

    NSArray *array=[data objectForKey:@"statuses"];
    //储存新数据数组
    NSMutableArray *mutableArr = [NSMutableArray array];

    for (NSDictionary *status in array) {
        
        HomeModel *model=[[HomeModel alloc]initWithDataDic:status];
        
        
        WeiboCellLayout *layout=[[WeiboCellLayout alloc]init];
        
        layout.model=model;
        
        [mutableArr addObject:layout];
    }
    
//    //试试
//    for (int count = mutableArr.count; count > 0 ; count--) {
//        [self.dataList addObject:mutableArr.lastObject];
//        [mutableArr removeObject:mutableArr.lastObject];

//}

    if (mutableArr.count != 0) {
        [mutableArr removeObjectAtIndex:0];
    }
    //拼接数组
        [self.dataList addObjectsFromArray:mutableArr];

    _myTableView.dataList = self.dataList;

    [_myTableView reloadData];
    
    [self.myTableView.infiniteScrollingView stopAnimating];
}
@end
