//
//  SearchFriendCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SearchFriendCell.h"
#import "SearchFriendModel.h"

@implementation SearchFriendCell

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
    CGFloat imageWidth = 40.f;
    //头像
    _avatarView = [UIImageView new];
    _avatarView.layer.cornerRadius = imageWidth/2;
    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];
    //姓名
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    
    //电话
//    _phoneLabel = [UILabel new];
//    [self.contentView addSubview:_phoneLabel];
    
    //操作
    _actionButton = [UIButton new];
    _actionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_actionButton setImage:[UIImage imageNamed:@"添加朋友"] forState:UIControlStateNormal];
    [_actionButton addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_actionButton];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imageWidth);
        make.leading.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_avatarView.mas_trailing).offset(10.f);
        make.centerY.equalTo(self.contentView);
    }];
    
//    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.nameLabel);
//        make.bottom.equalTo(self.contentView).offset(-10.f);
//    }];
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_nameLabel.mas_trailing).offset(20.f);
        make.trailing.equalTo(self.contentView).offset(-20.f);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(35.f);
        make.width.mas_equalTo(70.f);
    }];
}

- (void)setFriendModel:(SearchFriendModel *)friendModel{
    _friendModel = friendModel;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:friendModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    _nameLabel.text = friendModel.userName;
//    _phoneLabel.text = friendModel.phoneNumber;
    
    switch (friendModel.status) {
        case -1://验证通过
            [_actionButton setImage:[UIImage imageNamed:@"添加朋友"] forState:UIControlStateNormal];
            break;
        case 0://等待验证
            [_actionButton setImage:[UIImage imageNamed:@"等待验证"] forState:UIControlStateNormal];
            break;
        case 1://已添加
            [_actionButton setImage:[UIImage imageNamed:@"已添加"] forState:UIControlStateNormal];
            break;
        case 2://可添加
            [_actionButton setImage:[UIImage imageNamed:@"添加朋友"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)actionBtnClicked:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    if(self.actionBlock){
        self.actionBlock(weakSelf.friendModel);
    }
}

@end
