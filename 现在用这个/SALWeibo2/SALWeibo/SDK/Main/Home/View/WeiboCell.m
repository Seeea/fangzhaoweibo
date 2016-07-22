//
//  WeiboCell.m
//  SALWeibo
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "WXPhotoBrowser.h"
@interface WeiboCell ()<WXLabelDelegate,PhotoBrowerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;

@property (nonatomic,strong) NSMutableArray *weiboImaViewArr;//存放imageView的数组
@end

@implementation WeiboCell

- (NSMutableArray *)weiboImaViewArr{
    if (!_weiboImaViewArr) {
        
        _weiboImaViewArr=[NSMutableArray array];

        for (int i=0; i<9; i++) {
            UIImageView *imaView=[[UIImageView alloc]initWithFrame:CGRectZero];
            
           
        
            imaView.contentMode = UIViewContentModeScaleAspectFill;
            //裁剪
            imaView.clipsToBounds = YES;
            //      打开用户交互
            imaView.userInteractionEnabled=YES;
            //      添加点击手势

            UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [imaView addGestureRecognizer:tap];
            
            imaView.tag=9000 + i;
            
            [self.contentView addSubview:imaView];
            
            [_weiboImaViewArr addObject:imaView];
        

        }
        
    }
        return _weiboImaViewArr;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    /*
     InVIew : 弹出的视图将要添加的父视图
     Index : 当前图片页码
     */
    
    NSInteger index=tap.view.tag - 9000;
    
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:index delegate:self];
    
    
}
#pragma mark - PhotoBrowser Delegate

//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    //  正文图片
    if (_layout.model.pic_urls.count) {
        return _layout.model.pic_urls.count;
        
    }else if(_layout.model.retweeted_status.pic_urls.count){
        //    转发正文图片
        return _layout.model.retweeted_status.pic_urls.count;
    }
    return 0;
    
}
//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser
             photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    //  原始图片的ImageView
    
    UIImageView *imageV = [self.weiboImaViewArr objectAtIndex:index];
    
    photo.srcImageView=imageV;
    //  小图的URLString
    NSArray *urlsArr=nil;
    
    if (_layout.model.pic_urls.count) {
        
        urlsArr=_layout.model.pic_urls;
    }else if(_layout.model.retweeted_status.pic_urls.count){
        urlsArr=_layout.model.retweeted_status.pic_urls;
    }
    NSDictionary *dic =  [urlsArr objectAtIndex:index];
    
    NSString *urlStr=[dic objectForKey:@"thumbnail_pic"];
    
    urlStr=[urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    
    photo.url=[NSURL URLWithString:urlStr];
    return photo;


}
- (void)awakeFromNib {
    //  微博正文
    self.weiboTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    self.weiboTextLabel.wxLabelDelegate = self;
    self.weiboTextLabel.font = [UIFont systemFontOfSize:kWeiboTextFont];
    self.weiboTextLabel.numberOfLines = 0;
    [self.contentView addSubview:self.weiboTextLabel];
    
    self.nickNameLabel.colorName = @"Timeline_Notice_color";
    self.timeLabel.colorName = @"Timeline_Time_color";
    self.timeLabel.colorName = @"Timeline_Time_color";
}

//设置数据
-(void)setModel:(HomeModel *)model{
    
    _model=model;
    
    //  昵称
    self.nickNameLabel.text=_model.user.screen_name;
    
    //  头像
    NSURL *headerUrl=[NSURL URLWithString:_model.user.profile_image_url];
    
    [self.headerImageView sd_setImageWithURL:headerUrl];
    
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
    
    //  时间
    self.timeLabel.text=[UIUtils dataTimeAgoWithDataString:_model.created_at];
//    self.timeLabel.text = _model.created_at;
    
    //  来源
    self.sourceLabel.text=[UIUtils sourceTextWithString:_model.source];
//    self.sourceLabel.text = _model.source;
    
    //  微博正文
    self.weiboTextLabel.text= [UIUtils faceStringWithWeiboText:_model.text];
    
    //  微博正文图片
    if (_model.thumbnail_pic) {
//        NSURL *picUrl=[NSURL URLWithString:_model.thumbnail_pic];
//        
//        [self.picImageView sd_setImageWithURL:picUrl];
//        

        [self showImageViewWithUrls:_model.pic_urls];
    
    }
//转发微博
    if (_model.retweeted_status) {
        //转发正文
        self.retweedTextLabel.text = [UIUtils faceStringWithWeiboText:_model.retweeted_status.text];
        //转发图片
        if (_model.retweeted_status.thumbnail_pic) {
//            NSURL *retweetedPicURL = [NSURL URLWithString:_model.retweeted_status.thumbnail_pic];
//            [self.retweedPicView sd_setImageWithURL:retweetedPicURL];
            
            [self showImageViewWithUrls:_model.retweeted_status.pic_urls];
        }
    }
}

//多图
-(void)showImageViewWithUrls:(NSArray *)urls{
    for (int i = 0; i < urls.count; i ++) {
        UIImageView *imaView = [self.weiboImaViewArr objectAtIndex:i];
        
        NSDictionary *pidDic = urls[i];
        
        NSString *urlStr = pidDic[@"thumbnail_pic"];
        
        [imaView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
}


-(void)setLayout:(WeiboCellLayout *)layout{
    _layout=layout;
    
    //  1.正文
    self.weiboTextLabel.frame=_layout.textFrame;
    
    //  2.图片
//    self.picImageView.frame=_layout.picFrame;
    
    for (int i=0; i<9; i++) {
        
        UIImageView *imageV=[self.weiboImaViewArr objectAtIndex:i];
        
        CGRect frame=[[layout.weiboImaViewFrames objectAtIndex:i] CGRectValue];
        
        imageV.frame=frame;
        
    }

    //  3.转发背景
    
    self.retweedBgImageView.frame=_layout.retweedBgImageFrame;
    
    //  4.转发正文
    self.retweedTextLabel.frame=_layout.retweedTextFrame;
    
//    NSLog(@"rect = %@",NSStringFromCGRect(_layout.retweedTextFrame));
    
    //  5.转发图片
    self.retweedPicView.frame=_layout.retweedPicFrame;
    
    
}

@synthesize picImageView=_picImageView;
@synthesize retweedTextLabel=_retweedTextLabel;
@synthesize retweedPicView=_retweedPicView;
@synthesize retweedBgImageView=_retweedBgImageView;

- (UIImageView *)picImageView {
    if (_picImageView == nil) {
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

- (WXLabel *)retweedTextLabel {
    if (_retweedTextLabel == nil) {
        _retweedTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _retweedTextLabel.wxLabelDelegate = self;
        _retweedTextLabel.numberOfLines = 0;
        _retweedTextLabel.font = [UIFont systemFontOfSize:kRetweetedFontSize];
        
        [self.contentView addSubview:_retweedTextLabel];
        
//        [self.contentView bringSubviewToFront:_retweedTextLabel];
    }
    return _retweedTextLabel;
}

- (UIImageView *)retweedPicView {
    if (_retweedPicView == nil) {
        _retweedPicView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_retweedPicView];
    }
    return _retweedPicView;
}

- (ThemeImageView *)retweedBgImageView {
    if (_retweedBgImageView == nil) {
        _retweedBgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
        
        //    PS：先给edgeInsets设置值
        
        _retweedBgImageView.edgeInsets=UIEdgeInsetsMake(10, 30, 10, 10);
        
        _retweedBgImageView.imageName = @"timeline_rt_border_9.png";
        [self.contentView insertSubview:_retweedBgImageView atIndex:0];
    }
    return _retweedBgImageView;
}

#pragma mark -WXWeiboDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    NSString *regex1=@"http://([a-z0-9A-Z._-]+(/)?)+";
    NSString *rege2=@"@[\\w._-]{2,30}";
    NSString *rege3=@"#[^#]+#";
    NSString *regeFullStr = [NSString stringWithFormat:@"%@|%@|%@",regex1,rege2,rege3];
    return regeFullStr;

}

//设置超链接的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    UIColor *color = [[ThemeManager sharedInstance]getColorWithColorName:@"Link_color"];
    return color;

}

//跳转到指定页面
-(void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSLog(@"%@",context);
    
}

@end
