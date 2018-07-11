//
//  FirstLaunchVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FirstLaunchVC.h"

@interface FirstLaunchVC ()
{
 
    UIScrollView *_scrollView;
    int   _xishu;
}
@end

@implementation FirstLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    _scrollView.delegate = self;
    _scrollView.decelerationRate = 2;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4; i ++) {
        
        UIImageView *imageForNew = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    
        NSString *imageName = [self returnImageStr:i];
        
//        imageForNew.image = [UIImage imageNamed:imageName];
        imageForNew.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]]];
        
        [_scrollView addSubview:imageForNew];
       
        if (i == 3) {
            
            
            UIButton *goXiaomi = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            
            [goXiaomi addTarget:self action:@selector(actionForGoXiaomi) forControlEvents:UIControlEventTouchUpInside];
            
            [imageForNew addSubview:goXiaomi];
            
            imageForNew.userInteractionEnabled = YES;
        }
      
        
    }

    _xishu = 0;
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scrollView addGestureRecognizer:left];
    
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [_scrollView addGestureRecognizer:right];
    
    CGFloat btnWidth = 45.f;
    CGFloat btnHeight = 45.f;
    UIButton *passBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-btnWidth-20, 20, btnWidth, btnHeight)];
    [passBtn setBackgroundImage:[UIImage imageNamed:@"pass_guide"] forState:UIControlStateNormal];
    [passBtn addTarget:self action:@selector(passBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passBtn];
}
- (void)dealloc
{
    NSLog(@"FirstLaunchVC dealloc");
}
- (void)actionForGoXiaomi{

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(_pushForLogin){
        _pushForLogin();
    }
    
}
- (void)passBtnClicked:(UIButton *)button
{
    [self actionForGoXiaomi];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe
{

    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        //NSLog(@"左话了");
        _xishu++;
        
        if (_xishu >= 3) {
            
            _xishu = 3;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _scrollView.contentOffset = CGPointMake(kScreenWidth * _xishu, 0);
            
        }];
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
     
        _xishu--;
        
        if (_xishu <= 0) {
            
            _xishu = 0;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _scrollView.contentOffset = CGPointMake(kScreenWidth * _xishu, 0);
            
        }];
        
    }
    
}



- (NSString *)returnImageStr:(int )i
{
    
        if (IS_IPHONE_4_SCREEN) {
    
    
            if (i == 0) {
                
                return @"ydy1_4.png";
                
            }else if(i == 1){
             
                return @"ydy2_4.png";
                
            }else if(i == 2){
             
                return @"ydy3_4.png";
                
            }else{
             
                return @"ydy4_4.png";
            }
            
        }else if (IS_IPHONE_5_SCREEN){
    
            if (i == 0) {
                
                return @"ydy1_5.png";
                
            }else if(i == 1){
                
                return @"ydy2_5.png";
                
            }else if(i == 2){
                
                return @"ydy3_5.png";
                
            }else{
                
                return @"ydy4_5.png";
            }
    
        }else if (IS_IPHONE_6_SCREEN){
    
    
            if (i == 0) {
                
                return @"ydy1_6.png";
                
            }else if(i == 1){
                
                return @"ydy2_6.png";
                
            }else if(i == 2){
                
                return @"ydy3_6.png";
                
            }else{
                
                return @"ydy4_6.png";
            }
    
    
        }else if (IS_IPHONE_6P_SCREEN){
    
            if (i == 0) {
                
                return @"ydy1_6p.png";
                
            }else if(i == 1){
                
                return @"ydy2_6p.png";
                
            }else if(i == 2){
                
                return @"ydy3_6p.png";
                
            }else{
                
                return @"ydy4_6p.png";
            }
        }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
