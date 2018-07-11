//
//  RemindTypeCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "RemindTypeCell.h"

@implementation RemindTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        CGFloat width = kScreenWidth;
        CGFloat height = 60.f;
        CGFloat arrowWidth = 6.f;
        CGFloat arrowHeight = 20.f;
        CGFloat horMargin = 10.f;
        CGFloat horPadding = 15.f;
        CGFloat unreadLabelWidth = 20.f;
        CGFloat unreadLabelHeight = 20.f;
        CGFloat titleWidth = 200.f;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(horPadding + 20 + 15, 0, titleWidth, height)];
        [self.contentView addSubview:_titleLabel];
        
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(width-arrowWidth-horPadding,(height-arrowHeight)/2.f,arrowWidth,arrowHeight)];
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowView.image = [UIImage imageNamed:@"展开"];
        [self.contentView addSubview:_arrowView];
        
        _unreadCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-arrowWidth-horPadding-horMargin-unreadLabelWidth,(height - unreadLabelHeight) / 2.0,unreadLabelWidth,unreadLabelHeight)];
//        _unreadCountLabel.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _unreadCountLabel.backgroundColor = bgRedColor;
        _unreadCountLabel.font = [UIFont systemFontOfSize:12];
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.layer.cornerRadius = unreadLabelWidth/2.f;
        _unreadCountLabel.layer.masksToBounds =  YES;
        _unreadCountLabel.hidden = YES;
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        [_unreadCountLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_unreadCountLabel];
        
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (60 - 20.0) / 2.0, 20, 20)];
        //_headImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_headImage];
     
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(20));
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(titleWidth));
            make.height.equalTo(@(height));
            make.left.equalTo(_headImage.mas_right).offset(horPadding);
        }];
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(arrowWidth));
            make.height.equalTo(@(arrowHeight));
            make.right.equalTo(self.contentView).offset(-horPadding);
            make.centerY.equalTo(self.contentView);
        }];
        [_unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_arrowView.mas_left).offset(-horPadding);
            make.height.equalTo(@(unreadLabelHeight));
            make.centerY.equalTo(self.contentView);
            make.width.greaterThanOrEqualTo(@(unreadLabelWidth));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title unreadCount:(NSString *)unreadCount{
    
    _titleLabel.text = title;
    
    if([unreadCount isEqualToString:@"0"]){
        _unreadCountLabel.hidden = YES;
    }else{
        _unreadCountLabel.hidden = NO;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 4.f;
    style.tailIndent = 4.f;
    _unreadCountLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@  ",unreadCount] attributes:@{NSFontAttributeName:_unreadCountLabel.font,NSParagraphStyleAttributeName:style}];
}

@end
