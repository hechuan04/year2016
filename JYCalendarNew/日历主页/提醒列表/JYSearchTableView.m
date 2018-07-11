//
//  JYSearchTableView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSearchTableView.h"

@implementation JYSearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
   
    if (self = [super initWithFrame:frame style:style]) {
        
        self.showArr = @[];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
        [self addGestureRecognizer:tap];
        
        _emptyImageViewForSearch = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_提醒列表_搜索"]];
        _emptyImageViewForSearch.center = CGPointMake(kScreenWidth/2.f,100.f);
        _emptyImageViewForSearch.hidden = YES;
        [self addSubview:_emptyImageViewForSearch];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)cancelAction:(UITapGestureRecognizer *)ges
{
    self.showFriendArr = @[];
    self.showArr = @[];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)changeData:(NSArray *)data type:(NSInteger)type
{
    self.showArr = data;
    self.showFriendArr = [self _showFriendArr:data];
    self.listType = type;
    [self reloadData];
    
    if (self.showArr.count == 0) {
        _emptyImageViewForSearch.hidden = NO;
    }else{
        _emptyImageViewForSearch.hidden = YES;
    }
}

- (void)removeData
{
    self.showArr = @[];
    [self reloadData];
}

#pragma mark - Keyboard NSNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.contentInset = UIEdgeInsetsMake(0, 0, height,0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentInset = UIEdgeInsetsMake(0, 0, 0,0);
}


@end
