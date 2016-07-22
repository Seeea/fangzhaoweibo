//
//  MoreViewController.m
//  SALWeibo
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeSelectViewController.h"
@interface MoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mytableview;



@end

@implementation MoreViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mytableview.backgroundColor=[UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelName) name:kThemeChanged object:nil];
}

-(void)changeLabelName{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [_mytableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer=@"ThemeCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    ThemeImageView *imageView=(ThemeImageView *)[cell.contentView viewWithTag:501];
    
    ThemeLabel *textLabel=(ThemeLabel *)[cell.contentView viewWithTag:502];
    
    ThemeLabel *themeLabel=(ThemeLabel *)[cell.contentView viewWithTag:503];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            themeLabel.hidden=NO;
            imageView.imageName = @"more_icon_theme.png";
            textLabel.text = @"主题选择";
            themeLabel.text = [ThemeManager sharedInstance].themeName;
        } else if (indexPath.row == 1) {
            imageView.imageName = @"more_icon_account.png";
            textLabel.text = @"帐号管理";
            themeLabel.hidden=YES;
        }
    } else if (indexPath.section == 1) {
        imageView.imageName = @"more_icon_feedback.png";
        textLabel.text = @"意见反馈";
        themeLabel.hidden=YES;
    } else if (indexPath.section == 2) {
        textLabel.text =  @"注销帐号";
        themeLabel.hidden=YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UIStoryboard *sb=self.storyboard;
            
            ThemeSelectViewController *select=[sb instantiateViewControllerWithIdentifier:@"ThemeSelect"];
            
            [self.navigationController pushViewController:select animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

@end
