//
//  GuideView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/5.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "GuideView.h"
@interface GuideView()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSString *imageName;
@end

@implementation GuideView

+ (GuideView*)sharedView {
    static dispatch_once_t once;
    
    static GuideView *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    
    return sharedView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_imageView addGestureRecognizer:tap];
    }
    return self;
}


+ (void)showGuideWithImageName:(NSString *)imageName
{
    GuideView *guideView = [GuideView sharedView];
    
    if([GuideView shouldShow:imageName]){
        [[[[UIApplication sharedApplication] delegate] window] addSubview:guideView];
        NSString *adaptiveName = [GuideView adaptiveImageName:imageName];
        guideView.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:adaptiveName ofType:@"png"]];
        guideView.imageName = imageName;
    }
}
- (void)hide
{
    GuideView *guideView = [GuideView sharedView];
    
    [guideView removeFromSuperview];
    NSString *xiaomiId = [[NSUserDefaults standardUserDefaults] valueForKey:kUserXiaomiID];
    NSString *key = [NSString stringWithFormat:@"%@%@",guideView.imageName,xiaomiId];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    guideView.imageView.image = nil;
    guideView.imageName = nil;
}


#pragma mark - tool
+ (BOOL)shouldShow:(NSString *)imageName
{
    if(imageName){
        NSString *xiaomiId = [[NSUserDefaults standardUserDefaults] valueForKey:kUserXiaomiID];
        NSString *key = [NSString stringWithFormat:@"%@%@",imageName,xiaomiId];
        BOOL hasValue = [[NSUserDefaults standardUserDefaults]boolForKey:key];
        return !hasValue;
    }
    return NO;
}

+ (NSString *)adaptiveImageName:(NSString *)imageName
{
    NSString *newName;
    
    if(IS_IPHONE_4_SCREEN){
        newName = [imageName stringByAppendingString:@"_4"];
    }else if(IS_IPHONE_5_SCREEN){
        newName = [imageName stringByAppendingString:@"_5"];
    }else if(IS_IPHONE_6_SCREEN){
        newName = [imageName stringByAppendingString:@"_6"];
    }else if(IS_IPHONE_6P_SCREEN){
        newName = [imageName stringByAppendingString:@"_6p"];
    }
    return newName;
}

@end
