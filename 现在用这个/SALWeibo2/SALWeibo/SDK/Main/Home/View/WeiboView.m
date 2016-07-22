//
//  WeiboView.m
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"

static NSString *identifer=@"weibo_cell";

@interface WeiboView () <UITableViewDelegate,UITableViewDataSource>

@end
@implementation WeiboView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super initWithCoder:aDecoder]) {
        
        //    配置表示图
        [self configTableView];
    }
    
    return self;

}

-(void)configTableView{
    
    self.delegate=self;
    
    self.dataSource=self;
    
    //  注册单元格
    [self registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:identifer];
    
}

#pragma UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath ];
//    
////    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
//    cell.model = _dataList[indexPath.row];
    WeiboCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    WeiboCellLayout *layout =_dataList[indexPath.row];
    
    cell.layout=layout;
    
    cell.model=layout.model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCellLayout *layout = _dataList[indexPath.row];
    return layout.frame.size.height+10;
}

@end
