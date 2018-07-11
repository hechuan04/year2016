//
//  JYNoteCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/27.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYNoteCell.h"
#import "JYNote.h"

@implementation JYNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor whiteColor];
//        self.multipleSelectionBackgroundView = selectedBackgroundView;
//        self.selectedBackgroundView = selectedBackgroundView;
        [self setupSubViews];
        
    }
    return  self;
}

- (void)setupSubViews
{
    CGFloat horMargin = 15.f;
    
    _checkView = [UIImageView new];
    _checkView.contentMode = UIViewContentModeScaleAspectFit;
    _checkView.image = [UIImage imageNamed:@"默认状态"];
    [self.contentView addSubview:_checkView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.contentView addSubview:_titleLabel];
    
    _syncView = [UIImageView new];
    _syncView.hidden = YES;
    _syncView.image = [UIImage imageNamed:[NSString stringWithFormat:@"同步_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    _syncView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_syncView];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:_lineView];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:11.f];
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:_bottomLineView];
    
    [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@25.f);
        make.left.equalTo(self.contentView).offset(horMargin);
        self.checkWidthConstraint = make.width.equalTo(@0.f);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        self.titleLeftConstraint = make.left.equalTo(self.checkView.mas_right).offset(horMargin);
        make.right.equalTo(self.syncView.mas_left).offset(-horMargin);
        
    }];
    [_syncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20.f);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.lineView.mas_left).offset(-horMargin);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel.mas_left).offset(-horMargin);
        make.width.equalTo(@(0.5f));
        make.top.bottom.equalTo(self.contentView);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(70.f));
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setNote:(JYNote *)note
{
    _note = note;
    if(note){
        if(note.title.length==0){
            self.titleLabel.text = @"无标题";
        }else{
            self.titleLabel.text = note.title;
        }
        NSString *time = [self.dateFormat stringFromDate:note.updateTime];
        self.timeLabel.text = time;
    }else{
        self.titleLabel.text = @"";
        self.timeLabel.text = @"";
    }
    
    if([note.updateTime isEqualToDate:note.syncTime]){
        self.syncView.hidden = NO;
    }else{
        self.syncView.hidden = YES;
    }
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(isSelected){
        [_checkView setImage:[UIImage imageNamed:@"选中状态"]];
    }else{
        [_checkView setImage:[UIImage imageNamed:@"默认状态"]];
    }
}


#pragma mark - Custom Accessors
- (NSDateFormatter *)dateFormat
{
    if(!_dateFormat){
        _dateFormat = [NSDateFormatter new];
        _dateFormat.dateFormat = @"yyyy/MM/dd";
    }
    return _dateFormat;
}
@end
