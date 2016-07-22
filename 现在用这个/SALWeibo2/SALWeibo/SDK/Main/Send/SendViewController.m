//
//  SendViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "SendViewController.h"
#import "MenuViewController.h"
#import "MTDataService.h"
#import "UIViewExt.h"
#import <CoreLocation/CoreLocation.h>


@interface SendViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,SendFaceNameProtocol>{

    UIView *_toolBar;
    
    NSData *_imageData;

    UIImageView *_chooseMyImage;
    
    UILabel *_locationLabel;
    
    CLLocationManager *_manager;
    
    CLLocationCoordinate2D _coordinate;
    
    CLGeocoder *_coder;//编码对象
}

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建工具栏
    [self creatToolBar];
    
    //  键盘将要弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHideChangeAction:) name:UIKeyboardWillShowNotification object:nil];
    //  键盘将要消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHideChangeAction:) name:UIKeyboardWillHideNotification object:nil];
    
    //  键盘高度改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHideChangeAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

    //发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    sendButton.imageName = @"button_icon_ok.png";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:sendButton];

    self.navigationItem.rightBarButtonItem= rightItem;
    
    //返回按钮
    //发送按钮
    ThemeButton *closeButton =
    [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [closeButton addTarget:self
                    action:@selector(closeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    closeButton.imageName = @"button_icon_close.png";
    
    UIBarButtonItem *leftItem =
    [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}
-(WeiboFacePanelView *)facePanelView{
    
    
    if (!_facePanelView) {
        
        _facePanelView=[[WeiboFacePanelView alloc]initWithFrame:CGRectMake(0, kScreenHeight, 0, 0)];
        
        [self.view addSubview:_facePanelView];
        
        _facePanelView.faceView.delegate=self;
    }
    
    return _facePanelView;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.myTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

     [self.myTextView resignFirstResponder];

}

- (void)sendAction:(ThemeButton *)button{
    NSString *string  = _myTextView.text;
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"access_token":@"2.00OhnK6DyY87OC208f314782v2ldOB",@"status":string}];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status":string}];
   
    if (_coordinate.latitude != 0) {
        [params setObject:[NSString stringWithFormat:@"%lf",_coordinate.latitude] forKey:@"lat"];
        [params setObject:[NSString stringWithFormat:@"%lf",_coordinate.longitude] forKey:@"long"];
    }
    
        if (_imageData==nil) {
            [MTDataService POSTWithURLString:@"https://api.weibo.com/2/statuses/update.json" params:params headrFields:nil bodyData:nil complectionBlock:^(id data) {
                
                //      NSLog(@"%@",data);
            }];
            
        }else{
            
            [MTDataService POSTWithURLString:@"https://upload.api.weibo.com/2/statuses/upload.json" params:params headrFields:nil bodyData:_imageData complectionBlock:^(id data) {
                ;
            }];
            
        }
        

    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
//返回
-(void)closeAction:(ThemeButton *)button{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 创建工具栏
- (void)creatToolBar{
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    [self.view addSubview:_toolBar];
    _toolBar.backgroundColor = [UIColor clearColor];
    NSArray *buttonArr = @[
                           @"compose_toolbar_1.png",
                           @"compose_toolbar_3.png",
                           @"compose_toolbar_4.png",
                           @"compose_toolbar_5.png",
                           @"compose_toolbar_6.png"
                           ];
    for (int i = 0 ; i < buttonArr.count; i++) {
        ThemeButton *toolBut = [[ThemeButton alloc]initWithFrame:CGRectMake(i*60, 10, 50, 50)];
       
        toolBut.tag = 7000 + i;
        
        [toolBut addTarget:self action:@selector(toolButAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *buttonName = buttonArr[i];
        
        toolBut.imageName = buttonName;
        [_toolBar addSubview:toolBut];
//选中视图的显示
        _chooseMyImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, -65, 60, 60)];
        [_toolBar addSubview:_chooseMyImage];
//定位信息
        _locationLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _locationLabel.font = [UIFont systemFontOfSize:13];
        [_toolBar addSubview:_locationLabel];
        
    }

}


-(void)toolButAciton:(ThemeButton*)but{
    
    if (but.tag==7000) {
        
        [self selectedImage];
        
    }else if (but.tag == 7003){
    
        [self locationAction];
    }else if(but.tag==7004){
        
        if ([_myTextView isFirstResponder]) {
            [self showFacePanelView];
        }else{
            [self hideFacePanelView];
        }
    }

    
}

-(void)showFacePanelView{
    
    //  收齐键盘
    [self.myTextView resignFirstResponder];
    
    [UIView animateWithDuration:.35 animations:^{
        
        if (self.navigationController.navigationBar.translucent) {
            self.facePanelView.transform=CGAffineTransformMakeTranslation(0, -self.facePanelView.height);
        }else{
            
            self.facePanelView.transform=CGAffineTransformMakeTranslation(0, -self.facePanelView.height-64);
        }
        
        _toolBar.bottom=self.facePanelView.top;
        
        _myTextView.height=kScreenHeight-self.facePanelView.height-_toolBar.height;
    }];
    
}

-(void)hideFacePanelView{
    
    [_myTextView becomeFirstResponder];
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.facePanelView.transform=CGAffineTransformIdentity;
        
    }];
}

- (void)locationAction{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _manager.delegate = self;
        
    }
    if ([CLLocationManager locationServicesEnabled]) {
        
    }else{
        NSLog(@"定位未开启");
    }

    if ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusAuthorizedWhenInUse) {
       //请求用户授权
        [_manager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedAlways) {
        [_manager requestAlwaysAuthorization];
    }
    
    [_manager startUpdatingLocation];
}

#pragma mark - locationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    _coordinate = location.coordinate;
    //信息反编码
    if (!_coder ) {
        _coder = [[CLGeocoder alloc]init];
    }

    [_coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *street = [placemark.addressDictionary objectForKey:@"Street"];
        dispatch_async(dispatch_get_main_queue(), ^{
            _locationLabel.text = street;
        });
    }];
    [_manager stopUpdatingLocation];

}

- (void)selectedImage {
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    
    pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    pick.delegate = self;
    
    [self presentViewController:pick animated:YES completion:nil];

}

#pragma mark - UIImagePickControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    _imageData=UIImageJPEGRepresentation(image, 0.2);
    
    _chooseMyImage.image = image;
}


//底部约束高度吧？
#pragma mark - NSNotifactionMethod
-(void)keyboardShowHideChangeAction:(NSNotification *)notification{
    
    /**
     {
     UIKeyboardAnimationCurveUserInfoKey 曲线动画类型
     UIKeyboardAnimationDurationUserInfoKey = "0.4"; 动画持续时间
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 253}}";键盘的尺寸
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 1009.5}";键盘的初始中心点坐标
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 441.5}";键盘显示时中心点坐标
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 883}, {320, 253}}";键盘初始时frame
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 315}, {320, 253}}";键盘显示时frame
     UIKeyboardIsLocalUserInfoKey = 1;
     }
     
     */
    
    //  UIView animateWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:<#(UIViewAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
    CGRect frame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyHeight = CGRectGetHeight(frame);
    self.buttonConstraint.constant = keyHeight +70;
    
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    NSInteger option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    if ([notification.name isEqualToString:UIKeyboardFrameEndUserInfoKey]) {
        self.buttonConstraint.constant= 0;
    }
    
    //  导航栏透明与否会影响textVIew高度
    if (!self.navigationController.navigationBar.translucent) {
        
        self.myTextView.height=kScreenHeight-keyHeight-_toolBar.height-64;
    }else{
        
        self.myTextView.height=kScreenHeight-keyHeight-_toolBar.height;
    }

    _toolBar.top=self.myTextView.bottom;

}
#pragma mark - SendFaceNameProtocol Delegate
-(void)sendFaceName:(NSString *)faceName{

    _myTextView.text = [_myTextView.text stringByAppendingString:faceName];
}

@end
