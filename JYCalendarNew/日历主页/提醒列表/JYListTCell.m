//
//  JYListTCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListTCell.h"

@implementation JYListTCell

{
    UITapGestureRecognizer *_tap;
    UIButton *bg1;
    UIButton *bg2;
    UIButton *bg3;
    NSArray *_Arr;
    int      _page;
}

- (void)createBackBtn
{
    UITableView *tableView = (UITableView *)[[self superview]superview];
    if (![tableView isKindOfClass:[UITableView class]]) {
        return;
    }
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:[tableView indexPathForCell:self]];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[[tableView superview] superview]];
    //NSLog(@"frame:%@",self);
    bg1 = [[UIButton alloc] initWithFrame:CGRectMake(0, rectInSuperview.origin.y + self.height, kScreenWidth , kScreenHeight)];
    bg1.backgroundColor = [UIColor clearColor];
    [bg1 addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:bg1];
    
    bg2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , kScreenWidth , rectInSuperview.origin.y)];
    bg2.backgroundColor = [UIColor clearColor];
    [bg2 addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:bg2];
    
    bg3 = [[UIButton alloc] initWithFrame:CGRectMake(0, rectInSuperview.origin.y , kScreenWidth - 110, self.height)];
    bg3.backgroundColor = [UIColor clearColor];
    [bg3 addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:bg3];
    
    _Arr = @[bg1,bg2,bg3];
    
}

- (void)backAction:(UIButton *)sender
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    for (int i = 0; i < _Arr.count; i++) {
        
        UIButton *btn = _Arr[i];
        [btn removeFromSuperview];
    }
    
    _Arr = nil;
    _isScroll = NO;
}

//点击方法
- (void)tapAction:(UITapGestureRecognizer *)rec
{
    if (_isScroll) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.origin = CGPointMake(0, 0);
            _scrollView.origin = CGPointMake(0, 0);
            [_scrollView setContentOffset:CGPointMake(0, 0)];
        }];
        
        _isScroll = NO;
        [self backAction:nil];
        
    }else{
        if (_clickBlock) {
            _clickBlock(self);
        }
    }
}

//删除
- (void)deleteAction:(UIButton *)sender
{
    if (_deleteBlock) {
        _deleteBlock(self);
    }
    _isScroll = NO;
    [self backAction:nil];
}

//收藏
- (void)collectionAction:(UIButton *)sender
{
    if (_collectionBlock) {
        _collectionBlock(self);
    }
    
    _isScroll = NO;
    [self backAction:nil];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = CGRectMake(kScreenWidth - 55.0, 0, 55, 75);
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:    UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = bgRedColor;
        [self.contentView addSubview:_deleteBtn];
        _collcetionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _collcetionBtn.frame = CGRectMake(kScreenWidth - 55.0 - 55.0, 0, 55, 75);
        [_collcetionBtn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_collcetionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collcetionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _collcetionBtn.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_collcetionBtn];
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        
        //滑动背景
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBaseCellHeight)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth + 110, 0);
        [self.contentView addSubview:_scrollView];
        
        _page = 110;
        
        //单机选中
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_scrollView addGestureRecognizer:_tap];
        
        
        //子类复写
        [self _createContent];
        
        //是否选中状态
        _selectTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, (75 - 25)/2.0, 25, 25)];
        _selectTypeImage.image = [UIImage imageNamed:@"默认状态.png"];
        _selectTypeImage.highlightedImage = [UIImage imageNamed:@"选中状态.png"];
        _selectTypeImage.hidden = YES;
        [self addSubview:_selectTypeImage];
    }
    
    return self;
}

- (void )createShareHeadView:(RemindModel *)model
{
    [self headView:model];
 
}

- (void )headView:(RemindModel *)model
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    
    FriendListManager *fManager = [FriendListManager shareFriend];
    GroupListManager  *gManager = [GroupListManager shareGroup];
    NSArray *fidStr = [model.fidStr componentsSeparatedByString:@","];
    NSArray *gidStr = [model.gidStr componentsSeparatedByString:@","];
    NSMutableArray *urlArr = [NSMutableArray array];
    NSMutableArray *headImages = [NSMutableArray array];

    for (NSString *fid in fidStr) {
        
        FriendModel *f_model = [fManager selectDataWithFid:[fid integerValue]];
        if (f_model) {
            [urlArr addObject:f_model.head_url];
        }
    }
    
    for (NSString *gid in gidStr) {
        
        GroupModel *g_model = [gManager selectDataWithGid:[gid integerValue]];
        if (g_model) {
            [urlArr addObject:g_model.groupHeaderUrl];
        }
    }
    
    for (NSString *headUrlStr in urlArr) {
        NSURL *headUrl = [NSURL URLWithString:headUrlStr];
        if ([manager diskImageExistsForURL:headUrl]) {
            
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:headUrlStr];
            if (image) {
                [headImages addObject:image];
            }
        }
    }
  
    /*
    _shareHeadImage = [[HeadView alloc] initWithFrame:CGRectMake(10, 12.5, 50, 50) andType:(int )count andArr:headImages];
    [_bgView addSubview:_shareHeadImage];
     */
    
    _avatarView = [[GroupAvatarView alloc] initWithFrame:CGRectMake(10, 12.5, 50, 50)];
    _avatarView.avatarUrls = urlArr;
    [_bgView addSubview:_avatarView];
    
}

- (void)_createContent
{
    //普通头像
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 50, 50)];
    self.headImage.layer.cornerRadius = self.headImage.width / 2.0;
    self.headImage.layer.masksToBounds = YES;
    [_bgView addSubview:_headImage];

    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 12.5, 149, 18)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    [_bgView addSubview:_nameLabel];
    
    //内容
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 41, kScreenWidth  - 48 - 48 - 67 - 10, 21)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_bgView addSubview:_titleLabel];
    
    
    //创建时间
    _createTime = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 178, 10, 178, 20)];
    _createTime.textAlignment = NSTextAlignmentRight;
    _createTime.font = [UIFont systemFontOfSize:11.0];
    _createTime.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [_bgView addSubview:_createTime];
    
    //日
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth  - 48 - 45, 18, 48, 58)];
    //_dayLabel.backgroundColor = [UIColor orangeColor];
    _dayLabel.font = [UIFont systemFontOfSize:38];
    _dayLabel.textColor = skinManager.colorForDateBg;
    [_bgView addSubview:_dayLabel];
    
    
    //星期
    _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 45, 29, 45, 21)];
    _weekLabel.font = [UIFont systemFontOfSize:12.0];
    _weekLabel.textAlignment = NSTextAlignmentRight;
    _weekLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [_bgView addSubview:_weekLabel];
    
    
    _clock = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 15 - 2 - 15, 49, 15, 15)];
    [_bgView addSubview:_clock];
    
    
    
    _otherClock = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 15, 49, 15, 15)];
    [_bgView addSubview:_otherClock];
    _otherClock.image = [UIImage imageNamed:@"他人发送闹钟.png"];
    
    
    _pointImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 9, 9)];
    _pointImage.image = [UIImage imageNamed:@"圆点.png"];
    [_bgView addSubview:_pointImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _bgView.origin = CGPointMake(-scrollView.contentOffset.x, 0);
    _scrollView.origin = CGPointMake(-scrollView.contentOffset.x, 0);

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"停止减速11");
    [self scrollViewStopScroll:scrollView];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSLog(@"停止拖拽");
        [self scrollViewStopScroll:scrollView];
    }
}

//scrollView停止滚动
- (void)scrollViewStopScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.x >= _page / 2.0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _bgView.origin = CGPointMake(-_page, 0);
            scrollView.origin = CGPointMake(-_page, 0);
        }];
        [scrollView setContentOffset:CGPointMake(_page, 0)];
        _isScroll = YES;
        
    }else{
     
        [UIView animateWithDuration:0.3 animations:^{
            
            _bgView.origin = CGPointMake(0, 0);
            scrollView.origin = CGPointMake(0, 0);
            
        }];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        _isScroll = NO;
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    CGFloat speed = velocity.x;
   
    
    if (speed > 0.2) {
        [self createBackBtn];
    }else if(speed < -0.2){
        [self backAction:nil];
    }else{
       
        if (scrollView.contentOffset.x >= _page / 2.0) {
            [self createBackBtn];
        }else{
            [self backAction:nil];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
