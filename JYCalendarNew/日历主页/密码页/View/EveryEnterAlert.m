//
//  EveryEnterAlert.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "EveryEnterAlert.h"

@implementation EveryEnterAlert

- (void)createAlert:(UIColor *)selectColor
{
    UILabel *titleLabel = [self _titleLabel:382 selectColor:selectColor text:@"password"];
    UIView *lineView = [self _lineView:titleLabel selectColor:selectColor];
    [self _backBtnWithType:firstIn];
    
    self.textField1 = [UITextField new];
    self.textField1.backgroundColor = textFieldColor;
    self.textField1.placeholder = @"输入密码";
    self.textField1.delegate = self;
    self.textField1.keyboardType = UIKeyboardTypeNumberPad;
    self.textField1.secureTextEntry = YES;
    self.textField1.textColor = selectColor;
    [self.textField1 setValue:selectColor forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.textField1];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom).offset(55.0 / kIphone6_Height * kScreenHeight );
        make.left.equalTo(self.mas_left).offset(40.0 / kIphone6_Width * kScreenWidth);
        make.right.equalTo(self.mas_right).offset(-40.0 / kIphone6_Width * kScreenWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-237.0 / kIphone6_Height * kScreenHeight);
        
    }];
    self.textField1.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField1.leftViewMode = UITextFieldViewModeAlways;
    
    
    UILabel *prompt = [UILabel new];
    prompt.textColor = [UIColor grayColor];
    prompt.font = [UIFont systemFontOfSize:9.0];
    prompt.textAlignment = NSTextAlignmentRight;
    //prompt.backgroundColor = [UIColor orangeColor];
    prompt.text = @"请输入6-8位阿拉伯数字";
    [self addSubview:prompt];
    
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField1.mas_bottom).offset(2.5);
        make.left.equalTo(self.textField1.mas_left);
        make.right.equalTo(self.textField1.mas_right).offset(-12.0);
        make.height.mas_equalTo(15.);
        
    }];
    
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
        
        make.top.equalTo(self.textField1.mas_bottom).offset(80 / kIphone6_Height * kScreenHeight);
        make.right.equalTo(self.mas_centerX).offset(-15.f);
        make.left.equalTo(self.textField1.mas_left);
        make.height.equalTo(self.textField1.mas_height);
        
    }];
    
    UIButton *backSecret = [UIButton new];
    [backSecret addTarget:self action:@selector(backSecret:) forControlEvents:UIControlEventTouchUpInside];
    backSecret.backgroundColor = textFieldColor;
    backSecret.layer.borderWidth = 0.5;
    backSecret.layer.borderColor = selectColor.CGColor;
    backSecret.layer.masksToBounds = YES;
    backSecret.layer.cornerRadius = 10.0;
    [backSecret setTitle:@"找回密码" forState:UIControlStateNormal];
    [backSecret setTitleColor:selectColor forState:UIControlStateNormal];
    [self addSubview:backSecret];
    
    [backSecret mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField1.mas_bottom).offset(80 / kIphone6_Height * kScreenHeight);
        make.left.equalTo(self.mas_centerX).offset(10.f);
        make.right.equalTo(self.textField1.mas_right);
        make.height.equalTo(self.textField1.mas_height);
        
        
    }];

}

@end
