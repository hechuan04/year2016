//
//  CollectionCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "CollectionCell.h"
#import "RemindCollectionModel.h"

@implementation CollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return  self;
}
- (void)setupSubViews{
    CGFloat imageWidth = 45.f;
    
    //头像
    _avatarView = [UIImageView new];
    _avatarView.layer.cornerRadius = imageWidth/2;
    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];
    
    //姓名
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:15.f];
    _nameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nameLabel];
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.contentView addSubview:_titleLabel];
    
    //日期
    _dateLabel = [UILabel new];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont systemFontOfSize:11.f];
    _dateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_dateLabel];
    
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imageWidth);
        make.leading.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_avatarView.mas_trailing).offset(10.f);
        make.top.equalTo(_avatarView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_nameLabel);
        make.bottom.equalTo(_avatarView.mas_bottom);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_nameLabel.mas_trailing).offset(10);
        make.trailing.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(100.f);
        make.top.equalTo(_nameLabel);
    }];
    
}

- (void)setRemindModel:(RemindCollectionModel *)remindModel{
    _remindModel = remindModel;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:remindModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    _titleLabel.text = remindModel.title;
    _nameLabel.text = remindModel.senderName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yy/MM/dd";
    _dateLabel.text = [NSString stringWithFormat:@"收藏于%@",[formatter stringFromDate:remindModel.createTime]];
    
}
@end
