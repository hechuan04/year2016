//
//  UploadSuccessView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/9/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "UploadSuccessView.h"

@implementation UploadSuccessView

+ (instancetype)sharedInstance
{
    static UploadSuccessView *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    });
    return instance;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upload_success"]];
        _imgView.center = self.center;
        [self addSubview:_imgView];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

+ (void)showSuccessView
{
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedInstance]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self sharedInstance]removeFromSuperview];
    });
}

+ (void)dismiss
{
    [[self sharedInstance]removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
