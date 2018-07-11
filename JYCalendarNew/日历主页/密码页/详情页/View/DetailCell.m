//
//  DetailCell.m
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

/*
- (void)awakeFromNib {
    [super awakeFromNib];

  
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(PassWordModel *)model
{
 
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _model = model;
        [self _createTime];
        [self _createDetial];
    }
    
    return self;
}

- (void)_createTime
{
    _createTime = [UILabel new];
    _createTime.textAlignment = NSTextAlignmentRight;
    _createTime.text = _model.createTime;
    _createTime.font = [UIFont systemFontOfSize:11.0];
    _createTime.textColor = [UIColor colorWithRed:150 / 255. green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [self addSubview:_createTime];
    
    [_createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right).offset(-7.5);
        make.height.mas_equalTo(30.f);
        
    }];
    
    
}

- (void)_createDetial
{
    
    NSArray *arr = [JYSkinManager shareSkinManager].detailArr;
    NSArray *arr1 = @[@"标题:",@"用户名:",@"密码:",@"描述:"];
    
    UIView *bgView = [UIView new];
    bgView.layer.borderColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0  alpha:1].CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(7.5);
        make.right.equalTo(self.mas_right).offset(-7.5);
        make.top.equalTo(_createTime.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(-7.5);
        
    }];
    
    
    UIImageView *nextView = nil;
    for (int i = 0; i < 4; i ++) {
        
        UIImageView *imageV = [UIImageView new];
        imageV.image = [UIImage imageNamed:arr[i]];
        [bgView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.top.equalTo(bgView.mas_top).offset(12.0);
            }else{
                make.top.equalTo(nextView.mas_bottom).offset(24.0);
            }
            
            make.left.equalTo(bgView.mas_left).offset(15.0);
            make.height.mas_offset(21.0);
            make.width.mas_offset(21.0);
            
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = arr1[i];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [bgView addSubview:titleLabel];
        //titleLabel.backgroundColor = [UIColor cyanColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(imageV.mas_right).offset(10.0);
            make.top.equalTo(imageV.mas_top).offset(-12.0);
            make.bottom.equalTo(imageV.mas_bottom).offset(12.0);
            
        }];
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        [bgView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(bgView.mas_left).offset(113.0);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(bgView.mas_right).offset(-10.f);
        }];
        
        if (i == 3) {
            
            lineV.hidden = YES;
        }
        
        switch (i) {
            case 0:
            {
                
                [self _createChangeLabel:_title lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.title];
            }
                break;
            case 1:
            {
                [self _createChangeLabel:_userName lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.userName];
            }
                break;
            case 2:
            {
                [self _createChangeLabel:_passWord lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.passWord];
            }
                break;
            case 3:
            {
                bgView.tag = 123;
                _detail = [UITextView new];
                _detail.tag = 234;
                _detail.text = _model.detail;
                _detail.textColor = [UIColor blackColor];
                _detail.font = [UIFont systemFontOfSize:15.0];
                //_detail.backgroundColor = [UIColor orangeColor];
                [bgView addSubview:_detail];
                _detail.delegate = self;
                [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lineV.mas_left).offset(5.0);
                    make.top.equalTo(titleLabel.mas_top).offset(5.0);
                    make.bottom.equalTo(bgView.mas_bottom).offset(-5.0);
                    make.right.equalTo(lineV.mas_right);
                    
                }];
                
                _numberLine = _detail.contentSize.height / _detail.font.lineHeight;

            
            }
                break;
            default:
                break;
        }
        
        nextView = imageV;
        
    }
    
}



//创建可变label
- (void)_createChangeLabel:(UITextField *)changeLabel
                     lineV:(UIView *)lineV
                titleLabel:(UILabel *)titleLabel
                    bgView:(UIView *)bgView
                 modelText:(NSString *)text
{
    bgView.tag = 123;
    changeLabel = [UITextField new];
    changeLabel.tag = 234;
    changeLabel.text = text;
    changeLabel.textColor = [UIColor blackColor];
    changeLabel.font = [UIFont systemFontOfSize:15.0];
    changeLabel.delegate = self;
    //changeLabel.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:changeLabel];
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineV.mas_left).offset(5.0);
        make.top.equalTo(titleLabel.mas_top);
        make.bottom.equalTo(titleLabel.mas_bottom);
        make.right.equalTo(lineV.mas_right);
        
    }];
    
    
}

#pragma mark textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    NSLog(@"%ld",textField.text.length);
    
    if (textField.text.length > 20) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark textView代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
 

    int numberLine = textView.contentSize.height / textView.font.lineHeight;
    _model.detail = textView.text;
    
    if (numberLine != _numberLine) {
        
        //刷新界面
        _numberLine = numberLine;
        _reloadModel(self,_model);
    }
    
    NSLog(@"%d",numberLine);
    
    if (range.location >= 150) {
        return NO;
    }
    
    return YES;
}

- (void)upDataTextViewFrame:(CGFloat )height
{
 
    if (_detail) {
        UIView *bgView = [self viewWithTag:123];
    
        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(height - 7.5);
        }];
        
        [_detail mas_updateConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
