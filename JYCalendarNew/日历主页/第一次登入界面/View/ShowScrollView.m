//
//  ShowScrollView.m
//  JYCalendarNew
//
//  Created by mac on 16/4/5.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//
//  该类展示登陆页面上方的轮播图

#import "ShowScrollView.h"
#import "StyledPageControl.h"

@interface ShowScrollView ()
{
    CGRect _rectFirBeginFrame;
    CGRect _rectFirEndFrame;
    CGRect _rectFirEndFrame2;
    
    CGRect _rectSecBeginFrame;
    CGRect _rectSecEndFrame;
    
    CGRect _rectThdBeginFrame;
    CGRect _rectThdEndFrame;
    
}


@property (nonatomic,strong)UIScrollView * testScrollView;

@property (nonatomic,strong)UIImageView * middleImg1;
@property (nonatomic,strong)UIImageView * middleImg2;
@property (nonatomic,strong)UIImageView * middleImg3;
@property (nonatomic,strong)UIImageView * leftImg;
@property (nonatomic,strong)UIImageView * rightImg;

@property (nonatomic,strong)StyledPageControl * pageControl;
@property (nonatomic,assign)int currentPage;

@end

@implementation ShowScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        // 创建滚动视图
        _testScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _testScrollView.contentSize = CGSizeMake(width*3, height);
        _testScrollView.showsHorizontalScrollIndicator = NO;
        _testScrollView.delegate = self;
        _testScrollView.pagingEnabled = YES;
        _testScrollView.bounces = YES;
        _testScrollView.backgroundColor = [UIColor clearColor];


        // 创建三个图片
        // 中间的图片
        CGFloat firWidth = 600/750.0*kScreenWidth;
        CGFloat firHeight = 1065/1334.0*kScreenHeight;
        _middleImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-firWidth/2, 40, firWidth, firHeight)];
        _middleImg1.image = [UIImage imageNamed:@"yinDao_center"];
        _middleImg1.backgroundColor = [UIColor clearColor];
        [self addSubview:_middleImg1];
        
        // 滚动到第二页透明显示的View
        _middleImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-firWidth/2, 40, firWidth, firHeight)];
        _middleImg2.image = [UIImage imageNamed:@"yinDao_center2"];
        _middleImg2.alpha = 0;
        [self addSubview:_middleImg2];
        
        
        // 滚动到第三页透明显示的View
        _middleImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-firWidth/2, 40, firWidth, firHeight)];
        _middleImg3.image = [UIImage imageNamed:@"yinDao_center3"];
        _middleImg3.contentMode = UIViewContentModeScaleAspectFit;
        _middleImg3.alpha = 0;
        [self addSubview:_middleImg3];
        
        
        // 左边图
        CGFloat secWidth = 235/750.0*kScreenWidth;
        CGFloat secHeight = 280/1334.0*kScreenHeight;
        _leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(-secWidth, 145/1334.0*kScreenHeight, secWidth, secHeight)];
        _leftImg.image = [UIImage imageNamed:@"yinDao_left"];
        _leftImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftImg];
        
        // 右边图
        CGFloat thirWidth = 246/750.0*kScreenWidth;
        CGFloat thirHeight = 275/1334.0*kScreenHeight;
        _rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(width, 270/1334.0*kScreenHeight, thirWidth, thirHeight)];
        _rightImg.image = [UIImage imageNamed:@"yinDao_right"];
        _rightImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_rightImg];
        

        // 蒙层
        CGFloat mengHeight = 430/1334.0*kScreenHeight;
        CGRect mengFrame = CGRectMake(0, height-mengHeight, width, mengHeight);
        
        UIImageView * mengView = [[UIImageView alloc]initWithFrame:mengFrame];
        mengView.image = [UIImage imageNamed:@"mengCeng"];
        [self addSubview:mengView];
        
        
        // 创建pageControl
        CGFloat pageWidth = 100/750.0*kScreenWidth;
        CGFloat pageHeight = 40/1334.0*kScreenHeight;
        _pageControl = [[StyledPageControl alloc]initWithFrame:CGRectMake(width/2.0 - pageWidth/2.0, height-pageHeight, pageWidth, pageHeight)];
        _pageControl.numberOfPages = 3;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setPageControlStyle:(PageControlStyleThumb)];
        _pageControl.thumbImage = [UIImage imageNamed:@"yinDao_deSel"];
        _pageControl.selectedThumbImage = [UIImage imageNamed:@"yinDao_sel"];
        [_pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:_pageControl];
        
        
        // 创建展示内容介绍
        for (int i = 0; i < 3; i ++) {


            // 第二排内容
            CGFloat labelHeight2 = 35/1334.0*kScreenHeight;
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(i*width, _pageControl.top - labelHeight2 - 30/1334.0*kScreenHeight, width, labelHeight2)];
            label2.font = [UIFont systemFontOfSize:18];
            label2.textColor = [UIColor colorWithRed:255 / 255.0 green:135 / 255.0 blue:129 / 255.0 alpha:1];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.backgroundColor = [UIColor clearColor];
            [_testScrollView addSubview:label2];
            
            // 第一排内容
            CGFloat labelHeight = 50/1334.0*kScreenHeight;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*width, label2.top - labelHeight- 30/1334.0*kScreenHeight, width, labelHeight)];
            label.font = [UIFont boldSystemFontOfSize:25];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:255 / 255.0 green:135 / 255.0 blue:129 / 255.0 alpha:1];
            [_testScrollView addSubview:label];
            
            
            if (i == 0) {
                
                
                label.text = @"一言为“定”";
                label2.text = @"贴身管家 定时提醒";
                
            }else if (i == 1){
                
                
                label.text = @"记“易”由心";
                label2.text = @"随手记事 便捷记忆";
                
            }else{
                
                label.text = @"“息息”相关";
                label2.text = @"交互提醒 共享信息";
                
            }
            
        }
        
        
        // 最后添加 防止介绍内容被遮挡
        [self addSubview:_testScrollView];


        // 记录三个图片位移 变化的 位置
        _rectFirBeginFrame = _middleImg1.frame;
        _rectFirEndFrame = CGRectMake(_middleImg1.frame.origin.x, -100, _middleImg1.frame.size.width, _middleImg1.frame.size.height);
        
        _rectFirEndFrame2 = CGRectMake(220/750.0*kScreenWidth, 20/1334.0*kScreenHeight, 300/750.0*kScreenWidth, 565/1334.0*kScreenHeight);
        
        
        _rectSecBeginFrame = _leftImg.frame;
        _rectSecEndFrame = CGRectMake(0, _leftImg.frame.origin.y, _leftImg.frame.size.width, _leftImg.frame.size.height);
        
        _rectThdBeginFrame = _rightImg.frame;
        _rectThdEndFrame = CGRectMake(width-_rightImg.frame.size.width , _rightImg.frame.origin.y, _rightImg.frame.size.width, _rightImg.frame.size.height);
        
        
    }
    
    return self;
    
}

// 处理pageControl事件
- (void)handlePageControlAction:(UIPageControl *)pageControl
{
    
    CGPoint point = CGPointMake(pageControl.currentPage * _testScrollView.frame.size.width, 0);
    _testScrollView.contentOffset =  point;
    
}


#pragma mark ----- UIScrollViewDelegate-------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    _currentPage = (scrollView.contentOffset.x + scrollViewW*0.5) / scrollViewW;
    _pageControl.currentPage = _currentPage;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scrollViewW = scrollView.bounds.size.width;

    // 偏移距离
    CGFloat offSetX = scrollView.contentOffset.x;

    
    //第一页继续右滑
    if(offSetX<0){
        CGFloat ratio = offSetX/scrollViewW;
        CGFloat yOffset = -50.f;//继续滑还有有个位移效果,位移距离
        CGFloat newY = _rectFirBeginFrame.origin.y+yOffset*ratio;
        
        CGRect newFrame = CGRectMake(_rectFirBeginFrame.origin.x,newY,_rectFirBeginFrame.size.width,_rectFirBeginFrame.size.height);
        
        _middleImg1.frame = newFrame;
    }

    // 第一页
    if(offSetX>0 && offSetX<scrollViewW){
        
            
        CGFloat ratio = offSetX/scrollViewW;

        _middleImg1.alpha = MAX(0,1-ratio);
        _middleImg2.alpha = ratio;
        _middleImg3.alpha = 0;
        
        CGFloat newY = _rectFirBeginFrame.origin.y + (_rectFirEndFrame.origin.y - _rectFirBeginFrame.origin.y)*ratio;
                
        CGRect newFrame = CGRectMake(_rectFirBeginFrame.origin.x, newY, _rectFirBeginFrame.size.width, _rectFirBeginFrame.size.height);
        
        _middleImg1.frame = newFrame;
        _middleImg2.frame = newFrame;
        _middleImg3.frame = newFrame;

        
        // bug fix
        _leftImg.frame = _rectSecBeginFrame;
        _rightImg.frame = _rectThdBeginFrame;
        
    
    }
    // 第二页
    if (offSetX>scrollViewW && offSetX <= scrollViewW*2){

        
        // bug fix
        _middleImg1.alpha = 0;
        _middleImg2.alpha = 0;
        
        CGFloat ratio = (offSetX-scrollViewW)/scrollViewW;
        _middleImg2.alpha = MAX(0,1-ratio);
        _middleImg3.alpha =ratio;
        
        // 中间
        CGFloat newX = _rectFirEndFrame.origin.x + (_rectFirEndFrame2.origin.x-_rectFirEndFrame.origin.x)*ratio;
        CGFloat newY = _rectFirEndFrame.origin.y + (_rectFirEndFrame2.origin.y-_rectFirEndFrame.origin.y)*ratio;
        CGFloat newWidth = _rectFirEndFrame.size.width + (_rectFirEndFrame2.size.width-_rectFirEndFrame.size.width)*ratio;
        CGFloat newHeight = _rectFirEndFrame.size.height + (_rectFirEndFrame2.size.height-_rectFirEndFrame.size.height)*ratio;
        
        CGRect newFrame1 = CGRectMake(newX,newY,newWidth,newHeight);
        _middleImg1.frame = newFrame1;
        _middleImg2.frame = newFrame1;
        _middleImg3.frame = newFrame1;

        
        // 左边
        _leftImg.frame = CGRectMake(_rectSecBeginFrame.origin.x + (_rectSecEndFrame.origin.x - _rectSecBeginFrame.origin.x)*ratio, _rectSecBeginFrame.origin.y, _rectSecBeginFrame.size.width, _rectSecBeginFrame.size.height);
        
        // 右边
        _rightImg.frame = CGRectMake(_rectThdBeginFrame.origin.x + (_rectThdEndFrame.origin.x - _rectThdBeginFrame.origin.x)*ratio, _rectThdBeginFrame.origin.y, _rectThdBeginFrame.size.width, _rectThdBeginFrame.size.height);
        
        
        
    }

    //第三页继续左滑
    if(offSetX>scrollViewW*2){
        
        CGFloat ratio = (offSetX-2*scrollViewW)/scrollViewW;
        CGFloat xOffset = -50.f;//继续滑还有有个位移效果,位移距离
        CGFloat leftNewX = _rectSecEndFrame.origin.x+xOffset*ratio;
        CGFloat centerNewX = _rectFirEndFrame2.origin.x+xOffset*ratio;
        CGFloat rightNewX = _rectThdEndFrame.origin.x+xOffset*ratio;
        
        _middleImg3.frame = CGRectMake(centerNewX,_rectFirEndFrame2.origin.y,_rectFirEndFrame2.size.width,_rectFirEndFrame2.size.height);
        _leftImg.frame = CGRectMake(leftNewX,_rectSecEndFrame.origin.y,_rectSecEndFrame.size.width,_rectSecEndFrame.size.height);
        _rightImg.frame = CGRectMake(rightNewX,_rectThdEndFrame.origin.y,_rectThdEndFrame.size.width,_rectThdEndFrame.size.height);
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
