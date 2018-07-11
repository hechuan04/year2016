//
//  WeatherMenuView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/20.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherMenuView.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation WeatherMenuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"title";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRGBHex:0xeeeeee];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-1);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8.f);
            make.right.equalTo(self.contentView).offset(-8.f);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@(.5f));
        }];
    }
    return self;
}

@end

@implementation WeatherMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 50.f;
        [self registerClass:[WeatherMenuViewCell class] forCellReuseIdentifier:kCellIdentifier];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
#pragma mark - public
- (void)resetSelectionState
{
    [self reloadData];
}

#pragma mark - Protocol

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuNames count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.titleLabel.text = self.menuNames[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row==[self.menuNames count]-1){
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.selectRowBlock){
        self.selectRowBlock(indexPath.row);
    }
}
#pragma mark - Custom Accessors

- (void)setMenuNames:(NSArray *)menuNames
{
    _menuNames = menuNames;
    
    [self reloadData];
    
}
@end
