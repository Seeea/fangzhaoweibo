//
//  LeftViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "LeftViewController.h"
#import "BaseNavigationController.h"
#import "SendViewController.h"
#import "MenuViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    
    imageView.image=[UIImage imageNamed:@"leftbackiamge"];
    
    [self.view addSubview:imageView];
    UITableView *tableview = [[UITableView alloc] init];
    self.tableView = tableview;
    tableview.frame = self.view.bounds;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = 60;
    
    //  tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Left_Cell_ID";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"开通会员";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"我的收藏";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"我的相册";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"我的文件";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"个性装扮";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setTitle:@"发送微博" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    sendButton.frame = CGRectMake(0, 100, 150, 30);
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sendButton];
    return view;
}

-(void)sendAction{
    
    NSLog(@"弹到发送微博界面");
    
    SendViewController *send = [[SendViewController alloc]init];
    
    BaseNavigationController *base = [[BaseNavigationController alloc]initWithRootViewController:send];
    
    MenuViewController *menu = (MenuViewController *)self.view.window.rootViewController;
    [menu presentViewController:base animated:YES completion:^{
        [menu closeVVC];
    }];
    
}


@end
