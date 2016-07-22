//
//  SendViewController.h
//  SALWeibo
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboFacePanelView.h"
@interface SendViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;
@property(nonatomic,strong)WeiboFacePanelView *facePanelView;

@end
