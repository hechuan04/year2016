//
//  PhotoSizeTableView.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/31.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "PhotoSizeTableView.h"
#import "Masonry.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation PhotoSizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *pointView = [UIView new];
        pointView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:pointView];
        pointView.layer.cornerRadius = 3.f;
        pointView.layer.masksToBounds = YES;
        pointView.hidden = YES;
        _selectionPointView = pointView;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"信件";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:detailLabel];
        _detailLabel = detailLabel;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        
        [_selectionPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20.f);
            make.width.height.equalTo(@6.f);
            make.centerY.equalTo(self.contentView);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectionPointView).offset(20.f);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.detailLabel.mas_left).offset(-20);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(100.f));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@(1.f));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail;
{
    _titleLabel.text = title;
    _detailLabel.text = detail;
}

- (void)setShowHighLight:(BOOL)showHighLight
{
    _showHighLight = showHighLight;
    self.selectionPointView.hidden = !showHighLight;
    if(showHighLight){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor redColor];
    }else{
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}
@end


@implementation PhotoSizeTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = [PhotoSizeTableView rowHeight];
        [self registerClass:[PhotoSizeCell class] forCellReuseIdentifier:kCellIdentifier];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return [self.titleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(indexPath.row<[self.titleArray count] && indexPath.row<[self.sizeArray count]){
        NSString *detail = [NSString stringWithFormat:@"%@ 毫米",self.sizeArray[indexPath.row]];
        [cell setTitle:self.titleArray[indexPath.row] detail:detail];
    }
    if(indexPath.row==self.selectedRow){
        cell.showHighLight = YES;
    }else{
        cell.showHighLight = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [tableView reloadData];
//    if(self.selectRowBlock){
//        self.selectRowBlock(indexPath);
//    }
    
    if([self.sizeDelegate respondsToSelector:@selector(photoSizeTableView:hidenWithSelectedIndexPath:)]){
        [self.sizeDelegate photoSizeTableView:self hidenWithSelectedIndexPath:indexPath];
    }
}
#pragma mark - Custom Accessors

- (NSArray *)titleArray
{
    if(!_titleArray){
        _titleArray = @[@"A4",@"信件",@"法律文件",@"A3",@"A5",@"账簿",@"小报",@"名片"];
    }
    return _titleArray;
}
- (void)setSizeArray:(NSArray *)sizeArray
{
    _sizeArray = sizeArray;
    [self reloadData];
}

+ (CGFloat)rowHeight
{
    return 55.f;
}

@end
