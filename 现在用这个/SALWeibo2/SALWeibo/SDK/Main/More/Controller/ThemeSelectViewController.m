//
//  ThemeSelectViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "ThemeSelectViewController.h"

@interface ThemeSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;

@end



@implementation ThemeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  1.通过plist文件获得数据源
    _dataList=[[ThemeManager sharedInstance].themeConfig allKeys];
    
    _mytableview.backgroundColor=[UIColor clearColor];
}

#pragma UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.backgroundColor=[UIColor clearColor];
    }
    
    cell.textLabel.text=_dataList[indexPath.row];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    NSString *selectThemeName=[ThemeManager sharedInstance].themeName;
    
    if ([_dataList[indexPath.row] isEqualToString:selectThemeName]) {
        
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *themeName=_dataList[indexPath.row];
    
    [ThemeManager sharedInstance].themeName=themeName;
    
    [tableView reloadData];
}

@end
