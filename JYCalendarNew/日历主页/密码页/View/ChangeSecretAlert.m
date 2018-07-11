//
//  ChangeSecretAlert.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ChangeSecretAlert.h"

@implementation ChangeSecretAlert

- (void)createAlert:(UIColor *)selectColor
{
    UILabel *titleLabel = [self _titleLabel:560 selectColor:selectColor text:@"更改密码"];
    UIView *lineView = [self _lineView:titleLabel selectColor:selectColor];
    [self _backBtnWithType:changeIn];
    
    self.textField1 = [UITextField new];
    self.textField1.backgroundColor = textFieldColor;
    self.textField1.placeholder = @"原始密码";
    self.textField1.delegate = self;
    self.textField1.keyboardType = UIKeyboardTypeNumberPad;
    self.textField1.secureTextEntry = YES;
    self.textField1.textColor = selectColor;
    [self.textField1 setValue:selectColor forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.textField1];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom).offset(55.0 / kIphone6_Height * kScreenHeight);
        make.left.equalTo(self.mas_left).offset(40.0 / kIphone6_Width * kScreenWidth);
        make.right.equalTo(self.mas_right).offset(-40.0 / kIphone6_Width * kScreenWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-420.0 / kIphone6_Height * kScreenHeight);
        
    }];
    self.textField1.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField1.leftViewMode = UITextFieldViewModeAlways;
    
    self.textField2 = [UITextField new];
    self.textField2.backgroundColor = textFieldColor;
    self.textField2.placeholder = @"新密码";
    self.textField2.delegate = self;
    self.textField2.keyboardType = UIKeyboardTypeNumberPad;
    self.textField2.secureTextEntry = YES;
    self.textField2.textColor = selectColor;
    [self.textField2 setValue:selectColor forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.textField2];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField1.mas_bottom).offset(20 / 2.0);
        make.left.equalTo(self.textField1.mas_left);
        make.right.equalTo(self.textField1.mas_right);
        make.height.equalTo(self.textField1.mas_height);
        
    }];
    self.textField2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField2.leftViewMode = UITextFieldViewModeAlways;
    
    self.textField3 = [UITextField new];
    self.textField3.backgroundColor = textFieldColor;
    self.textField3.placeholder = @"再次输入";
    self.textField3.delegate = self;
    self.textField3.keyboardType = UIKeyboardTypeNumberPad;
    self.textField3.secureTextEntry = YES;
    self.textField3.textColor = selectColor;
    [self.textField3 setValue:selectColor forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.textField3];
    
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField2.mas_bottom).offset(20 / kIphone6_Height * kScreenHeight);
        make.left.equalTo(self.textField2.mas_left);
        make.right.equalTo(self.textField2.mas_right);
        make.height.equalTo(self.textField2.mas_height);
        
    }];
    self.textField3.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField3.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *corfimBtn = [UIButton new];
    [corfimBtn addTarget:self action:@selector(corfimAction:) forControlEvents:UIControlEventTouchUpInside];
    corfimBtn.backgroundColor = textFieldColor;
    corfimBtn.layer.borderWidth = 0.5;
    corfimBtn.layer.borderColor = selectColor.CGColor;
    corfimBtn.layer.masksToBounds = YES;
    corfimBtn.layer.cornerRadius = 10.0;
    [corfimBtn setTitle:@"确认" forState:UIControlStateNormal];
    [corfimBtn setTitleColor:selectColor forState:UIControlStateNormal];
    [self addSubview:corfimBtn];
    
    [corfimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField3.mas_bottom).offset(44 / kIphone6_Height * kScreenHeight);
        make.right.equalTo(self.mas_right).offset(-100 / kIphone6_Width * kScreenWidth);
        make.left.equalTo(self.mas_left).offset(100 / kIphone6_Width * kScreenWidth);
        make.height.equalTo(self.textField3.mas_height);
        
    }];

}

@end
