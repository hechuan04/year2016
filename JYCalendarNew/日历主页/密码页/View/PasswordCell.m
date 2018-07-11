//
//  PasswordCell.m
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PasswordCell.h"

@implementation PasswordCell


 
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _trigonometryImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _trigonometryImage.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_trigonometryImage];

    _numberLabel = [UILabel new];
    _numberLabel.text = @"0";
    _numberLabel.textColor = [UIColor colorWithRed:151 / 255.0 green:151 / 255.0 blue:151 / 255.0 alpha:1];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    //_numberLabel.backgroundColor = [UIColor redColor];
    _numberLabel.font = [UIFont systemFontOfSize:17.f];
    [self.contentView addSubview:_numberLabel];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(14.5);
        make.bottom.equalTo(self.mas_bottom).offset(-14.5);
        make.right.equalTo(self.mas_right).offset(-26.0);
        make.width.equalTo(_numberLabel.mas_height);
        
    }];
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.layer.cornerRadius = _numberLabel.size.width / 2.0;
    });
    */
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15.0);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    _titleField = [UITextField new];
    _titleField.font = [UIFont systemFontOfSize:17.f];
    //_titleField.backgroundColor = [UIColor orangeColor];
    _titleField.delegate = self;
    _titleField.userInteractionEnabled = NO;
    [self.contentView addSubview:_titleField];
    
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15.0+20.0+7.5);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15.f-7.5-20.0-7.5);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    _editNamebTN = [UIButton new];
    [self.contentView addSubview:_editNamebTN];
    
    [_editNamebTN addTarget:self action:@selector(beginEditNow:) forControlEvents:UIControlEventTouchUpInside];
    [_editNamebTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleField.mas_top);
        make.left.equalTo(_titleField.mas_left).offset(20.f);
        make.right.equalTo(_titleField.mas_right);
        make.bottom.equalTo(_titleField.mas_bottom);
    }];
    

    _selectImage = [UIImageView new];
    _selectImage.image = [UIImage imageNamed:@"未选中.png"];
    [self.contentView addSubview:_selectImage];
    
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15.f);
        make.centerY.equalTo(self.mas_centerY);

        make.width.mas_equalTo(20.f);
        make.height.mas_equalTo(20.f);
    }];
 
}

- (void)selectCell:(BOOL)isSelect
{
   
    
    if (isSelect) {
        _selectImage.image = [UIImage imageNamed:@"选中.png"];
        
    }else{
    
        _selectImage.image = [UIImage imageNamed:@"未选中.png"];
    }
    
}

- (void)removeAddImage
{
 
    if (_addImg) {
        
        [_addImg removeFromSuperview];
        _addImg = nil;
    }
}

- (void)editType:(BOOL)isEdit
{
    
    if (_addImg) {
        
        _titleLabel.hidden = YES;
        _titleField.hidden = YES;
        _selectImage.hidden = YES;
        return;
    }
 
    if (isEdit) {
        
        _titleLabel.hidden = YES;
        _titleField.hidden = NO;
        _selectImage.hidden = NO;
        
    }else{
        
        _titleLabel.hidden = NO;
        _titleField.hidden = YES;
        _selectImage.hidden = YES;
    }
    
}

- (void)createAddBtn
{
 
    if (!_addImg) {
        
        _addImg = [UIImageView new];
        _addImg.image = [UIImage imageNamed:@"addImage.png"];
        [self.contentView addSubview:_addImg];
        
        [_addImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15.0);
            make.top.equalTo(self.mas_top).offset(10.0);
            make.bottom.equalTo(self.mas_bottom).offset(-10.0);
            make.width.equalTo(_addImg.mas_height);
            
        }];
        
    }
    
}

- (void)hiddenLast
{
    _titleField.hidden = YES;
    _titleLabel.hidden = YES;
    _numberLabel.hidden = YES;
    _selectImage.hidden = YES;
}

- (void)appearAll
{
    _titleField.hidden = NO;
    _titleLabel.hidden = NO;
    _numberLabel.hidden = NO;
    _selectImage.hidden = NO;
}

- (void)normalWidth
{
    [_numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(14.5);
        make.bottom.equalTo(self.mas_bottom).offset(-14.5);
        make.right.equalTo(self.mas_right).offset(-26.0);
        make.width.equalTo(_numberLabel.mas_height);
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _numberLabel.layer.cornerRadius = _numberLabel.size.width / 2.0;
    });
}

- (void)changeLabelWidth
{

        [_numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(_numberLabel.mas_height).offset(10.f);
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                _numberLabel.layer.cornerRadius = 11.0;
        });
    
}


- (void)beginEditNow:(UIButton *)sender
{
    if (_beginEditBlock) {
        
        UITableView *tableView = (UITableView *)[[self superview]superview];
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:[tableView indexPathForCell:self]];
        CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[[tableView superview] superview]];
        _beginEditBlock(_titleField,rectInSuperview,self);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_beginEditBlock) {
        
        UITableView *tableView = (UITableView *)[[self superview]superview];
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:[tableView indexPathForCell:self]];
        CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[[tableView superview] superview]];
        _beginEditBlock(textField,rectInSuperview,self);
    }
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
 
    if (_finishEditBlock) {
        _finishEditBlock(textField,self);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
