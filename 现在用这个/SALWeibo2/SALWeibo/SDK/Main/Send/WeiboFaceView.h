//
//  WeiboFaceView.h
//  SALWeibo
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SendFaceNameProtocol <NSObject>

@optional

-(void)sendFaceName:(NSString *)faceName;


@end

@interface WeiboFaceView : UIView

@property(nonatomic,strong)NSMutableArray *allItems;

@property(nonatomic,weak)id<SendFaceNameProtocol>delegate;

@end
