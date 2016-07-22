//
//  WeiboFaceView.m
//  SALWeibo
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "WeiboFaceView.h"

#define kItem_size (kScreenWidth/7)
#define kFace_size (kItem_size - 20)


@interface WeiboFaceView (){

    UIImageView *_faceImageView;//选中图片放大版

    UIImageView *_magniferView;
    
    NSString *_faceName;//表情名

}
@end
@implementation WeiboFaceView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        _magniferView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 50, 64, 92)];
        
        _magniferView.image=[UIImage imageNamed:@"emoticon_keyboard_magnifier"];
        
        _magniferView.hidden=YES;
        
        [self addSubview:_magniferView];
        
        
        _faceImageView=[[UIImageView alloc]initWithFrame:CGRectMake((_magniferView.width-45)/2, 10, 45, 45)];
        
        [_magniferView addSubview:_faceImageView];
        

        //    加载数据
        [self loadPlistData];
    }
    
    return self;
}

- (void)loadPlistData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    
    NSArray *emticons = [NSArray arrayWithContentsOfFile:path];
    //  重构数据
    //  104  375/50   一行7个 15行   一页4行
    
    //  4 * 7 = 28
    //  创建二维数组
    /*
     [
     [e1,e2...e28]
     [e29,e30..e56]
     [e57,e58..e84]
     [e85..e104]
     ]
     */
//大数组
    _allItems = [NSMutableArray array];
//第一个小数组
    NSMutableArray *items = [NSMutableArray array];
    
    [_allItems addObject:items];
    
    for (int i=0; i<emticons.count; i++) {
        
        if (items.count==28) {
            
            //      只要每个小数组满了28个元素，就会重新传建一个新的小数组
            items=[NSMutableArray arrayWithCapacity:28];
            
            //   优点：刚创建完小数组就添加到大数组中了
            [_allItems addObject:items];
        }
        
        [items addObject:emticons[i]];
        
    }
    

CGRect frame=self.frame;

frame.size.width=kScreenWidth * 4;

frame.size.height=kItem_size * 4;

self.frame=frame;
}

//加载图
- (void)drawRect:(CGRect)rect {
    
//    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //1.UIImage获取到图片
    
    
    // 2.坐标
    
    int colum=0;//列  7
    int row=0;//行   4     28
    for (int i=0; i<_allItems.count; i++) {
        
        NSArray *items=[_allItems objectAtIndex:i];
        
        for (int j=0; j<items.count; j++) {
            
            NSDictionary *emojiDic=items[j];
            
            NSString *imageName=emojiDic[@"png"];
            
            UIImage *image=[UIImage imageNamed:imageName];
            
            //      坐标
            CGFloat x;
            CGFloat y;
            
            x= colum * kItem_size + (kItem_size-kFace_size)/2 + i*kScreenWidth;
            y= row * kItem_size + (kItem_size-kFace_size)/2;
            
            colum++;
            
            //      如果加到最后一个（7列）换到下一行列数为0
            if (colum%7==0) {
                
                colum=0;
                
                row++;
            }
            
            if (row%4==0) {
                row=0;
            }
            
            //      画
            [image drawInRect:CGRectMake(x, y, kFace_size, kFace_size)];
        }
        
        
    }
    
    
    
    
    //  [UIImage imageNamed:@"res"]drawInRect:<#(CGRect)#>
}
//==========
//放大镜
-(void)setMagnifierView:(CGPoint)point{
    
    //  当前页码  行列
    
    //  页码
    NSInteger page=point.x/kScreenWidth;
    
    int column=(point.x-page*kScreenWidth)/kItem_size;
    int row=point.y/kItem_size;
    
    CGFloat x=kItem_size * column+kItem_size/2+page*kScreenWidth;
    CGFloat y=kItem_size * row+kItem_size/2;
    
    _magniferView.center=CGPointMake(x, 0);
    _magniferView.bottom=y;

    NSArray *items=_allItems[page];
    
    //  表情下标位置
    NSInteger index=row * 7 + column;
    
    //  容错
    if (index>=items.count) {
        
        //    如果点击的点超出数组，则不显示放大镜视图
        _magniferView.hidden=YES;
        return;
    }
    //  小字典
    NSDictionary *dic=[items objectAtIndex:index];
    
    NSString *imaName=[dic objectForKey:@"png"];
    
    UIImage *image=[UIImage imageNamed:imaName];
    
    _faceName = dic[@"chs"];
    _faceImageView.image=image;

}


#pragma mark - TouchMethod
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  NSLog(@"开始触摸");
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView =(UIScrollView *) self.superview;
        
        //    禁止滑动
        scrollView.scrollEnabled=NO;
    }

    UITouch *touch=[touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    //  NSLog(@"%@",NSStringFromCGPoint(point));
    
    _magniferView.hidden=NO;
    
    [self setMagnifierView:point];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  NSLog(@"触摸移动");
    //  NSLog(@"触摸移动");
    //  NSLog(@"开始触摸");
    UITouch *touch=[touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    //  NSLog(@"%@",NSStringFromCGPoint(point));
    
    _magniferView.hidden=NO;
    
    [self setMagnifierView:point];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  NSLog(@"触摸结束");
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView =(UIScrollView *) self.superview;
        
        //    开启滑动
        scrollView.scrollEnabled=YES;
    }
    
    
    _magniferView.hidden=YES;
    if ([self.delegate respondsToSelector:@selector(sendFaceName:)]) {
        
        [self.delegate sendFaceName:_faceName];
    }

}

//================
@end
