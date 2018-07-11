//
//  BaseCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell
{
 
    UIButton *bg1;
    UIButton *bg2;
    UIButton *bg3;
    NSArray *_Arr;
}
-(UIImage *)_getImageFromURL:(NSString *)fileURL andFriendModel:(FriendModel *)model{
    
    NSString *path_sandox = NSHomeDirectory();
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@_%ld.jpg",path_sandox,model.friend_name,model.fid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
  
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *localImage = [UIImage imageWithData:data];
    
    
   UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.head_url];
    //9E892370-E21C-446C-95ED-FF02521D8AA0
    if (image||localImage) {

//        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *image = [UIImage imageWithData:data];
        
      //  NSLog(@"调用本地了");
        
        if (image) {
            return image;
        }else{
            return localImage;
        }
    
        
    }else{
     
    
        image = [UIImage imageNamed:@"默认用户头像.png"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            
            [fileManager createFileAtPath:path contents:data attributes:nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeList object:nil];
            NSLog(@"我下载完啦，更新一下吧");
        });

      //  NSLog(@"调用网络了");
        
        return image;
    }
    
    
}

-(UIImage *)_getImageFromURL:(NSString *)fileURL andGroupModel:(GroupModel *)model{
    
    NSString *path_sandox = NSHomeDirectory();
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@_%d.jpg",path_sandox,model.group_name,model.gid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.groupHeaderUrl];
    //9E892370-E21C-446C-95ED-FF02521D8AA0
    if (image) {
        

        
        //  NSLog(@"调用本地了");
        
        return image;
        
    }else{
        
        
        if (image) {
            
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *localImage = [UIImage imageWithData:data];
            
            return localImage;
            
        }else{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            UIImage *image = [UIImage imageWithData:data];
            
            [fileManager createFileAtPath:path contents:data attributes:nil];
            
            //  NSLog(@"调用网络了");
            
            return image;
        }
        
     
    }
    
    
}

- (NSArray *)loadHeadWithModel:(RemindModel *)model
{
 
    NSArray *arr = [model.fidStr componentsSeparatedByString:@","];
    NSArray *arrForG = [model.gidStr componentsSeparatedByString:@","];
    
    FriendListManager *friendList = [FriendListManager shareFriend];
    GroupListManager  *groupList = [GroupListManager shareGroup];
    NSMutableArray *arrForImage = [NSMutableArray arrayWithCapacity:arr.count];
    for (int i = 0; i < arr.count; i++) {
        
        FriendModel *friendModel = [friendList selectDataWithFid:[arr[i] intValue]];
       
        if (friendModel.head_url != nil) {
           
            UIImage *headImage = [self _getImageFromURL:friendModel.head_url andFriendModel:friendModel];
            if (headImage != nil) {
                [arrForImage addObject:headImage];
            }

        }
     
    }
    
    for (int i = 0; i < arrForG.count; i++) {
        
        GroupModel *groupModel = [groupList selectDataWithGid:[arrForG[i]integerValue]];
        
        if (groupModel.groupHeaderUrl != nil) {
            
            UIImage *headImage = [self _getImageFromURL:groupModel.groupHeaderUrl andGroupModel:groupModel];
            if (headImage != nil) {
                [arrForImage addObject:headImage];
            }
        }
        
    }
    
    
    
    return arrForImage;
}

- (void)awakeFromNib {
    // Initialization code
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.headImage.layer.cornerRadius = self.headImage.width / 2.0;
        self.headImage.layer.masksToBounds = YES;

    });
    

    
    _headView = [[HeadView alloc] initWithFrame:CGRectMake(10, 8, 50, 50) andType:0 andArr:nil];
    _headView.backgroundColor = [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1];
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = 45.0 / 2.0;
    [self.topView addSubview:_headView];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:_tap];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteBtn.frame = CGRectMake(kScreenWidth - 55.0, 0, 55, kBaseCellHeight);
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = bgRedColor;
    [self.contentView addSubview:_deleteBtn];
    
    
    
    _collcetionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _collcetionBtn.frame = CGRectMake(kScreenWidth - 55.0 - 55.0, 0, 55, kBaseCellHeight);
    [_collcetionBtn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_collcetionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collcetionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _collcetionBtn.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_collcetionBtn];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_topView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 44, 44)];
    [_topView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 10, 149, 18)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    [_topView addSubview:_nameLabel];
    
                                                                    //dayLabel的X
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 31, kScreenWidth  - 48 - 48 - 67 - 10, 21)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_topView addSubview:_titleLabel];
    
    _createTime = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 8 - 178, 2, 178, 21)];
    _createTime.textAlignment = NSTextAlignmentRight;
    _createTime.font = [UIFont systemFontOfSize:11.0];
    _createTime.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [_topView addSubview:_createTime];
    
    
    _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 8 - 45, 18, 45, 21)];
    _weekLabel.font = [UIFont systemFontOfSize:12.0];
    _weekLabel.textAlignment = NSTextAlignmentRight;
    _weekLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [_topView addSubview:_weekLabel];
    
    
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth  - 48 - 48, 9, 48, 58)];
    _dayLabel.font = [UIFont systemFontOfSize:38];
    _dayLabel.textColor = skinManager.colorForDateBg;
    [_topView addSubview:_dayLabel];
    
    
    _clock = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 8 - 15 - 2 - 15, 38, 15, 15)];
    [_topView addSubview:_clock];
    
    _otherClock = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 8 - 15, 38, 15, 15)];
    [_topView addSubview:_otherClock];
    _otherClock.image = [UIImage imageNamed:@"他人发送闹钟.png"];
    
    _pointImage = [[UIImageView alloc] initWithFrame:CGRectMake(46, 10, 9, 9)];
    _pointImage.image = [UIImage imageNamed:@"圆点.png"];
    [_topView addSubview:_pointImage];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBaseCellHeight)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth + 110, 0);
    [self.contentView addSubview:_scrollView];
    
    _trigonometryImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _trigonometryImage.image = [UIImage imageNamed:@"展开.png"];
    [self insertSubview:_trigonometryImage belowSubview:_deleteBtn];
    
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:_tap];

    
    
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
    UITableView *tableView = (UITableView *)[[self superview]superview];
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
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    ManagerForButton *manager = [ManagerForButton shareManagerBtn];
    
    if (manager.isBaseCellOpen) {
        
        manager.cell.scrollView.origin = CGPointMake(0, 0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [manager.cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            manager.isBaseCellOpen = NO;

        });
        
    }else{
     
        _tapAction(self);

    }
 
    
    //NSLog(@"点击事件");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _topView.origin = CGPointMake(-scrollView.contentOffset.x, 0);
    _scrollView.origin = CGPointMake(-scrollView.contentOffset.x, 0);
  
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
 
    ManagerForButton *manager = [ManagerForButton shareManagerBtn];
    CGFloat widthForSize = 0;  //只能删除不能收藏的情况
    if (scrollView.contentSize.width == kScreenWidth + 110) {
        
        widthForSize = 110;
        
    }else{
     
        widthForSize = 55;
    }
    
    if (manager.isBaseCellOpen && manager.cell != self) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            manager.cell.scrollView.origin = CGPointMake(0, 0);
            [manager.cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            manager.cell = self;
   
        });
      
        [self.scrollView setContentOffset:CGPointMake(widthForSize, 0) animated:YES];
        
        
    }else{
     
        if (velocity.x > 0) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _topView.origin = CGPointMake(-widthForSize, 0);
                
            }];
            
            manager.isBaseCellOpen = YES;
            manager.cell = self;
            scrollView.contentOffset = CGPointMake(widthForSize, 0);
            
        }else if(velocity.x < 0){
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _topView.origin = CGPointMake(0, 0);
                
            }];
            
            manager.isBaseCellOpen = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            
            
        }else{
            
            if (scrollView.contentOffset.x > widthForSize / 2.0) {
                
                [scrollView setContentOffset:CGPointMake(widthForSize, 0) animated:YES];
                manager.isBaseCellOpen = YES;
                manager.cell = self;
                
            }else{
                
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                manager.isBaseCellOpen = NO;
                manager.cell = self;
                
                
            }
            
        }

    }
 
}





//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    //NSLog(@"cell内部 ： %lf",self.topView.frame.origin.x);
  
   // NSLog(@"又刷新我了");
       //Configure the view for the selected state
    
}

- (void)deleteAction:(UIButton *)sender {
    [self backAction:nil];
    //[_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    //NSLog(@"删除");
    _deleteAction(self);
}

- (void)collectionAction:(UIButton *)sender {
    
    [self backAction:nil];
    //[_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    //NSLog(@"收藏");
    _collectionAction(self);
}

- (void)hiddenAll
{
 
    self.collcetionBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    self.selectImage.hidden = YES;
    self.topView.hidden =  YES;
    self.scrollView.scrollEnabled = NO;
}

- (void)appearAll
{
    self.collcetionBtn.hidden = NO;
    self.deleteBtn.hidden = NO;
    self.selectImage.hidden = NO;
    self.topView.hidden = NO;
    self.scrollView.scrollEnabled = YES;
}



- (void)hiddenTrigonometryImage
{
 
    self.trigonometryImage.hidden = YES;
}

- (void)appearTrigonmetryImage
{
 
    self.trigonometryImage.hidden = NO;
}


//赋值
- (void)setModel:(RemindModel *)model
{
 
    if (model != _model) {
        
        _model = model;
        
        if (_model.isShare == 0 || _model.isOther == 0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userHead = [userDefaults objectForKey:kUserHead];
            [_headImage sd_setImageWithURL:[NSURL URLWithString:userHead]];
            _nameLabel.text = [userDefaults objectForKey:kUserName];
            _titleLabel.text = _model.title;
            _createTime.text = [Tool actionForListTimeStr:_model.createTime type:sendType];
       
            
        }
        
    }
    
}


@end
