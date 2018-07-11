//
//  JYBottomFrame.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYBottomFrame.h"

@implementation JYBottomFrame

+ (void)changeLabelAndImageFrame:(NSArray *)btnArr
                           width:(CGFloat )width
{
    for (UIButton *sender in btnArr) {
        
        UILabel *label = [sender viewWithTag:sender.tag + 10];
        label.size = CGSizeMake(width, 20);
        
        UIImageView *imageView = [sender viewWithTag:sender.tag + 20];
        imageView.origin = CGPointMake((width - 20) / 2.0, 10);

    }
}


+ (void)appearBottomBtn:(NSArray *)orderArr lineView:(UIView *)lineView;
{
    CGFloat width = kScreenWidth / orderArr.count;
    CGFloat y = kScreenHeight - 60 - 64;
    
    UIButton *variableSender = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (UIButton *sender in orderArr) {
        sender.frame = CGRectMake(variableSender.right, kScreenHeight, width, 60);
        variableSender = sender;
        [mutableArr addObject:sender];
    }
    
    
    [JYBottomFrame changeLabelAndImageFrame:orderArr width:width];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        for (UIButton *sender in mutableArr) {
            sender.origin = CGPointMake(sender.origin.x, y);
        }
        
        lineView.origin = CGPointMake(0, y);
    }];
    
    

}

+ (void)disAppearBottomBtn:(NSArray *)orderArr lineView:(UIView *)lineView;
{
    [UIView animateWithDuration:0.5 animations:^{
        
        for (UIButton *sender in orderArr) {
            sender.origin = CGPointMake(sender.origin.x, kScreenHeight);
        }
        
        lineView.origin = CGPointMake(0, kScreenHeight);
    }];
}

@end
