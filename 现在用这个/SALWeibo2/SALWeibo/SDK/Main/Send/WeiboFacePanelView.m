//
//  WeiboFacePanelView.m
//  SALWeibo
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WeiboFacePanelView.h"


@interface WeiboFacePanelView ()<UIScrollViewDelegate>
{

    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation WeiboFacePanelView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
    
    [self creatSubViews];
    
    }
    
    return self;
}

- (void)creatSubViews{
    _faceView = [[WeiboFaceView alloc]initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    _faceView.clipsToBounds = NO;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    _scrollView.pagingEnabled=YES;
    
    _scrollView.backgroundColor=[UIColor clearColor];
    
    [_scrollView addSubview:_faceView];
    
    _scrollView.clipsToBounds=NO;
    
    _scrollView.delegate=self;
    
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    [self addSubview:_scrollView];
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrollView.bottom, kScreenWidth, 30)];
    
    _pageControl.numberOfPages=_faceView.allItems.count;
    
    [self addSubview:_pageControl];
    
    //  取消布局
    self.autoresizesSubviews=NO;
    
    
    CGRect frame=self.frame;
    
    frame.size.width=_faceView.width;
    
    frame.size.height=_scrollView.height+_pageControl.height;
    
    self.frame=frame;

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _pageControl.currentPage=scrollView.contentOffset.x/kScreenWidth;
    
}

-(void)drawRect:(CGRect)rect{
    
    [[UIImage imageNamed:@"emoticon_keyboard_background"]drawInRect:self.bounds];
}

@end
