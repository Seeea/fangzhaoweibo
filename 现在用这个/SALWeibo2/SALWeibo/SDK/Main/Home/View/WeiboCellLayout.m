//
//  WeiboCellLayout.m
//  SALWeibo
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"

#define kTopCellHeight 60
#define kLineSpace 10
#define kItemGap 5

@implementation WeiboCellLayout

- (NSMutableArray *)weiboImaViewFrames{
    if (!_weiboImaViewFrames) {
        _weiboImaViewFrames = [NSMutableArray array];
    }
    return _weiboImaViewFrames;
}


-(void)setModel:(HomeModel *)model{
    
    _model=model;
    
    [self layoutSubViewFrame];
}

-(void)layoutSubViewFrame{
//微博正文
    CGFloat textWidth = kScreenWidth - 10;
    
    /**
     NSStringDrawingUsesLineFragmentOrigin 会自动换行
     
     NSStringDrawingUsesFontLeading 会加上行间距
     
     NSStringDrawingUsesDeviceMetrics 使用设备字体（默认使用印刷字体）
     
     NSStringDrawingTruncatesLastVisibleLine（不能单独使用，需要配合换行使用）
     如果最后一行显示不开，会自动变为省略号
     */
//    NSDictionary *att = @{
//                          NSFontAttributeName :[UIFont systemFontOfSize:kWeiboTextFont],NSForegroundColorAttributeName:[UIColor blackColor]
//                          };
//    CGRect textRect =[_model.text boundingRectWithSize:CGSizeMake(textWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    
    CGFloat textHeight = [WXLabel getTextHeight:kWeiboTextFont width:textWidth text:_model.text linespace:10];
    
    self.textFrame = CGRectMake(5, kTopCellHeight, textWidth, textHeight );
    
    
//    CGFloat picX = CGRectGetMinX(self.textFrame);
//    CGFloat picY = CGRectGetMaxY(self.textFrame)+5;
//    
//    CGFloat picWidth = 0;
//    CGFloat picHeight = 0;
    
//正文图片
//    if (_model.thumbnail_pic) {
//        picWidth=100;
//        picHeight=100;
//        
//        self.picFrame=CGRectMake(picX, picY, picWidth, picHeight);
//        
//    }

    CGFloat x = CGRectGetMinX(self.textFrame);
    CGFloat y = CGRectGetMaxY(self.textFrame)+kLineSpace;
    //每个图的尺寸
    CGFloat itemSize =( CGRectGetWidth(self.textFrame)- 2* kItemGap)/3;
    NSInteger row=0;//行
    NSInteger column=0;//列
    
    for (int i = 0 ; i < _model.pic_urls.count; i++) {
        row=i/3;
        column=i%3;
        
        CGRect frame = CGRectMake(x+column * (itemSize+kItemGap), y+row*(itemSize+kItemGap), itemSize, itemSize);
        //      添加完所有有数据的ImageView的frame
  
        [self.weiboImaViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    //    补全没有数据的ImageView的frame
//    for (NSInteger i=_model.pic_urls.count; i<9; i++) {
//        [self.weiboImaViewFrames addObject:[NSValue valueWithCGRect:CGRectZero]];
//    }
    /*
     行数  0~3
     图片之间的间隙 0~2
     正文和图片之间的间隙 0~1
     */
    NSInteger line=(_model.pic_urls.count+2)/3;
    
    _imagesHeight=line*itemSize+MAX(0, (line-1))*kItemGap+MIN(1, MAX(0, line))*kLineSpace;
    
    
    
    
    //转发微博
    if (_model.retweeted_status) {
        //转发背景视图
        CGFloat retweetedBGX = CGRectGetMinX(self.textFrame);
        CGFloat retweetedBGY = CGRectGetMaxY(self.textFrame)+ 5;
        
        CGFloat retweetedWidth = kScreenWidth - 10;
        
        self.retweedBgImageFrame = CGRectMake(retweetedBGX, retweetedBGY, retweetedWidth, 0);
    
//正文
        CGFloat retweetedTextWidth = CGRectGetWidth(self.retweedBgImageFrame )- 10 ;
//        NSDictionary *retweetedAtt=@{
//                                     NSFontAttributeName:[UIFont systemFontOfSize:kRetweetedFontSize],
//                                     NSForegroundColorAttributeName:[UIColor blackColor]
//                                     };
//        CGRect retweetedTextRect = [_model.retweeted_status.text boundingRectWithSize:CGSizeMake(retweetedTextWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:retweetedAtt context:nil];
        CGFloat retweetedTextHeight = [WXLabel getTextHeight:kRetweetedFontSize width:retweetedTextWidth text:_model.retweeted_status.text linespace:10];
        
        CGFloat retweetedTextX=CGRectGetMinX(self.retweedBgImageFrame)+5;
        
        CGFloat retweetedTextY=CGRectGetMinY(self.retweedBgImageFrame)+5;
        
        self.retweedTextFrame=CGRectMake(retweetedTextX, retweetedTextY, retweetedTextWidth, retweetedTextHeight);
//    转发微博正文图片
        
//        CGFloat retweetedPicWidth=0;
//        CGFloat retweetedPicHeight=0;
//        if (_model.retweeted_status.thumbnail_pic) {
//            retweetedPicWidth = 100;
//            retweetedPicHeight = 100;
//            CGFloat retweetedPicX = CGRectGetMinX(self.retweedBgImageFrame)+5;
//            CGFloat retweetedPicY = CGRectGetMaxY(self.retweedTextFrame)+10;
//            self.retweedPicFrame = CGRectMake(retweetedPicX, retweetedPicY, retweetedPicWidth, retweetedPicHeight);
//        }
        CGFloat x = CGRectGetMinX(self.retweedTextFrame);
        CGFloat y = CGRectGetMaxY(self.retweedTextFrame)+kLineSpace;
        
        
        //    每个图片的尺寸
        CGFloat itemSize=(CGRectGetWidth(self.retweedTextFrame)-2*kItemGap)/3;
        
        NSInteger row=0;//行
        NSInteger column=0;//列
        
        for (int i=0; i<_model.retweeted_status.pic_urls.count; i++) {
            
            row=i/3;
            column=i%3;
            
            CGRect frame=CGRectMake(x+column * (itemSize+kItemGap), y+row*(itemSize+kItemGap), itemSize, itemSize);
            
            //      添加完所有有数据的ImageView的frame
            [self.weiboImaViewFrames addObject:[NSValue valueWithCGRect:frame]];
            
        }
        
        /*
         行数  0~3
         图片之间的间隙 0~2
         正文和图片之间的间隙 0~1
         */
        NSInteger line=(_model.retweeted_status.pic_urls.count+2)/3;
        
        _imagesHeight=line*itemSize+MAX(0, (line-1))*kItemGap+MIN(1, MAX(0, line))*kLineSpace;
        

        
        
        
        
// 转发背景视图设置高度
//        CGFloat retweetedBGHeight = 5 + CGRectGetHeight(self.retweedTextFrame)+10 + CGRectGetHeight(self.retweedPicFrame) + 5;
         CGFloat retweetedBgHeight=5+CGRectGetHeight(self.retweedTextFrame)+10+_imagesHeight+15;
        CGRect retweetedNewFrame=self.retweedBgImageFrame;
        
        retweetedNewFrame.size.height=retweetedBgHeight;
        
        self.retweedBgImageFrame=retweetedNewFrame;
        
    }
    CGFloat cellHeight=0;
    
    if (_model.thumbnail_pic) {
        
       cellHeight=5+CGRectGetHeight(self.textFrame)+_imagesHeight+5+kTopCellHeight+10;
    }else if(_model.retweeted_status){
        
        cellHeight=5+CGRectGetHeight(self.retweedBgImageFrame)+20+CGRectGetHeight(self.textFrame)+5+kTopCellHeight+10;

    }else{
    cellHeight =CGRectGetHeight(self.textFrame)+kTopCellHeight+10;
    }
    
    self.frame=CGRectMake(0, 0, kScreenWidth, cellHeight);
    
    //    补全没有数据的ImageView的frame
    for (NSInteger i=_model.retweeted_status.pic_urls.count; i<9; i++) {
        
        [self.weiboImaViewFrames addObject:[NSValue valueWithCGRect:CGRectZero]];
    }
    

}

@end
