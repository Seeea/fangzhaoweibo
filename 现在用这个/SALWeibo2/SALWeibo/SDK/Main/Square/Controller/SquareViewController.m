//
//  SquareViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "SquareViewController.h"
#import "MTDataService.h"
#import "HomeModel.h"
#import <MapKit/MapKit.h>
#import "WXAnnotation.h"
#import "WeiboAnnotationView.h"

@interface SquareViewController ()<MKMapViewDelegate>{
    MKMapView *_mapView;
    
    CLLocationCoordinate2D _coordinate;
}


@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
   
    _mapView.showsUserLocation = YES;
    
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
}

//获取用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _coordinate = userLocation.coordinate;
    
    [self loadData];
}

//=======
//发送请求--》获取周边用户的经纬度坐标
- (void)loadData {
    
    NSMutableDictionary *params = nil;
    if (_coordinate.longitude != 0) {
        
        params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                 @"lat" : [NSString stringWithFormat:@"%lf", _coordinate.latitude],
                                                                 @"long" : [NSString stringWithFormat:@"%lf", _coordinate.longitude]
                                                                 }];
    }
    
    [MTDataService
     GETWithURLString:@"https://api.weibo.com/2/place/nearby_timeline.json"
     params:params
     headrFields:nil
     complectionBlock:^(id data){
         
         NSArray *array=[data objectForKey:@"statuses"];
         
         for (NSDictionary *status in array) {
             
             HomeModel *model=[[HomeModel alloc]initWithDataDic:status];
             
             NSDictionary *geoDic=model.geo;
             
             NSArray *coorArr=geoDic[@"coordinates"];
             
             CLLocationDegrees lati=[coorArr[0] doubleValue];
             CLLocationDegrees longi=[coorArr[1] doubleValue];
             
             //          创建2D
             CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(lati, longi);
             
             WXAnnotation *annotation=[[WXAnnotation alloc]init];
             
             [annotation setCoordinate:coordinate];
             
             annotation.model=model;
             
             [_mapView addAnnotation:annotation];
             
             
         }
         
         
     }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    //  判断是否是当前用户
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    
    static NSString *identifer=@"Annotation_ID_Weibo";
    
    WeiboAnnotationView *annoView=(WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    
    if (!annoView) {
        annoView=[[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifer];
        
    }
    
    annoView.annotation=annotation;
    
    return annoView;
}
//=======


@end
