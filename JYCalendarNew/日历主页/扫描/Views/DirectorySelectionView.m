//
//  DirectorySelectionView.m
//  ScanDemo
//
//  Created by Gaolichao on 16/6/2.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "DirectorySelectionView.h"
#import "ScanDirectory.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation DirectoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"title";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *pullDownView = [UIImageView new];
        [self.contentView addSubview:pullDownView];
        pullDownView.contentMode = UIViewContentModeScaleAspectFit;
        pullDownView.image = [UIImage imageNamed:@"download"];
        _putDownView = pullDownView;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRGBHex:0xeeeeee];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20.f);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.putDownView.mas_left).offset(-40);
        }];
        [_putDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(20.f));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@(1.f));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title showHightLight:(BOOL)hightLight
{
    _titleLabel.text = title;
    _showHighLight = hightLight;
    
    if(hightLight){
        self.titleLabel.textColor = [UIColor redColor];
        self.putDownView.image = [UIImage imageNamed:@"download_hightlight"];
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
        self.putDownView.image = [UIImage imageNamed:@"download"];
    }

}

@end

@implementation DirectorySelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 50.f;
        [self registerClass:[DirectoryCell class] forCellReuseIdentifier:kCellIdentifier];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedRow = -1;
    }
    return self;
}
#pragma mark - public
- (void)resetSelectionState
{
    self.selectedRow = -1;
    [self reloadData];
}

#pragma mark - Protocol

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirs count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    ScanDirectory *dir = self.dirs[indexPath.row];
    BOOL hightLigth = (indexPath.row==self.selectedRow);
    [cell setTitle:dir.name showHightLight:hightLigth];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [tableView reloadData];

    if(self.selectRowBlock){
        ScanDirectory *dir = self.dirs[indexPath.row];
        NSInteger did = dir.dirId;
        self.selectRowBlock(did);
    }
}
#pragma mark - Custom Accessors

- (void)setDirs:(NSArray *)dirs
{
    _dirs = dirs;
    if(self.superview){
        [self reloadData];
    }
}
@end
