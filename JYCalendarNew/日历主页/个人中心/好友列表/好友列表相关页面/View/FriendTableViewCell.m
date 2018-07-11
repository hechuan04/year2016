//
//  FriendTableViewCell.m
//  ffff
//
//  Created by 吴冬 on 16/1/11.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "UIViewExt.h"

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
@implementation FriendTableViewCell
{
    UIButton *bg;
    CGFloat _keyStatus;
}


- (void)awakeFromNib {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.userHead.layer.masksToBounds = YES;
        self.userHead.layer.cornerRadius = self.userHead.width / 2.0;
        
    });
    
    //self.bgScroll.backgroundColor = [UIColor orangeColor];
    self.bgScroll.delegate = self;
   
    _keyStatus = - _keyBtn.size.width ;
    
    self.bgScroll.contentSize = CGSizeMake(kScreenWidth + 144 + _keyStatus, 0);

    self.bgScroll.showsHorizontalScrollIndicator = NO;
    self.topView.backgroundColor = [UIColor whiteColor];
    self.bgScroll.contentOffset = CGPointMake(0, 0);
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForTap:)];
    
    [self.bgScroll addGestureRecognizer:singleFingerOne];
    
    _keyBtn.hidden = YES;
    
}

- (void)actionForTap:(UITapGestureRecognizer *)tap
{
 
   
    
    UITableView *tableView = nil;
    float Version=[[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(Version>=7.0)
        
    {
        
        tableView = (UITableView *)self.superview.superview;
        
    }
    
    else
        
    {
        
        tableView=(UITableView *)self.superview;
        
    }
    
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    
    //传递indexPath
    _actionForPushIndex(indexPath);

    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    
    _topView.origin = CGPointMake(-scrollView.contentOffset.x, 0);
    _bgScroll.origin = CGPointMake(-scrollView.contentOffset.x, -1);
    
}

- (void)backAction:(UIButton *)sender
{
    [_bgScroll setContentOffset:CGPointMake(0, -1) animated:YES];
    
    [sender removeFromSuperview];
   // [self performSelector:@selector(canUse) withObject:nil afterDelay:0.4];

}

- (void)canUse{
    self.superview.superview.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 
    if (scrollView.contentOffset.x == 0) {
        
        [self createBackBtn];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
  
    
    if (scrollView.contentOffset.x != 0) {
    
        [self createBackBtn];
    }
    
}

- (void)createBackBtn
{
    bg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, kScreenHeight)];
    bg.backgroundColor = [UIColor clearColor];
    [bg addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:bg];
    
    //self.superview.superview.userInteractionEnabled = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
 
   
    if (velocity.x > 0) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.contentOffset = CGPointMake(144 + _keyStatus, -1);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else if(velocity.x < 0){
     
 
        
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.contentOffset = CGPointMake(0, -1);
            
        } completion:^(BOOL finished) {
            
        }];
        
 
        
    }else{
     
        if (scrollView.contentOffset.x > (144 + _keyStatus)/2.0) {
            
            [scrollView setContentOffset:CGPointMake(144 + _keyStatus, -1) animated:YES];
      
        }else{
            

            [scrollView setContentOffset:CGPointMake(0, -1) animated:YES];

        }
    }
   
}


- (IBAction)deleteAction:(UIButton *)sender {
    
    [bg removeFromSuperview];
    _actionForDelete(self);
    
}

- (IBAction)keyAction:(UIButton *)sender {
    
    [bg removeFromSuperview];
    _actionForKeyPath(self);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
