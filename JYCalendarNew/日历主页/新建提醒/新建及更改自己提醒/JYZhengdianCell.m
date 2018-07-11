//
//  JYZhengdianCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYZhengdianCell.h"

@implementation JYZhengdianCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, kScreenWidth, 0.5)];
        _line.backgroundColor = lineColor;
        //[self.contentView addSubview:_line];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(15.f);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            
        }];
        
    }
    
    return _titleLabel;
}

- (UIImageView *)selectImage
{
    if (!_selectImage) {
        _selectImage = [UIImageView new];
        [self.contentView addSubview:_selectImage];
        
        [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15.f);
            make.height.mas_equalTo(20.f);
            make.width.mas_equalTo(20.f);
        }];
        _selectImage.image = [UIImage imageNamed:@"重复未选中"];
        _selectImage.highlightedImage = [UIImage imageNamed:@"重复选中"];
    }
    
    return _selectImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
