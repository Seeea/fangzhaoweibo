//
//  HomeModel.m
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
//关键字需要特殊处理
-(void)setAttributes:(NSDictionary *)dataDic{
    
    [super setAttributes:dataDic];
    
    id weiboId=[dataDic objectForKey:@"id"];
    
    self.weiboID=weiboId;
    
    //设置用户Model
    NSDictionary *userModel = [dataDic objectForKey:@"user"];
    
    //容错
    if (userModel) {
        self.user = [[UserModel alloc ]initWithDataDic:userModel];
    }
    //转发微博
    NSDictionary *retwteedModel = [dataDic objectForKey:@"retweeted_status"];
    if (retwteedModel) {
        self.retweeted_status = [[HomeModel alloc]initWithDataDic:retwteedModel];
        //拼接 @转发者：转发的text
        self.retweeted_status.text = [NSString stringWithFormat:@"@%@:%@",self.retweeted_status.user.screen_name,self.retweeted_status.text];
    }
    
}

@end
