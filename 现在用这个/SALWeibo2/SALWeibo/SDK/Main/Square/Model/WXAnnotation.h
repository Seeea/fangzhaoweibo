//
//  WXAnnotation.h
//  SALWeibo
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HomeModel.h"

@interface WXAnnotation : NSObject<MKAnnotation>

@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;

@property(nonatomic,copy,nonnull) NSString *tittle;
@property(nonatomic,copy,nonnull) NSString *sublite;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@property (nonnull,nonatomic,strong) HomeModel *model;
@end
