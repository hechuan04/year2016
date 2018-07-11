//
//  FirstEnterAlert.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FirstEnterAlert.h"

@implementation FirstEnterAlert

- (void)createAlert:(UIColor *)selectColor
{
    UILabel *titleLabel = [self _titleLabel:560 selectColor:selectColor text:@"新建密码"];
    UIView  *lineView   = [self _lineView:titleLabel selectColor:selectColor];
    
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
        
        make.top.equalTo(lineView.mas_bottom).offset(55.0 / 1334.0 * kScreenHeight);
        make.left.equalTo(self.mas_left).offset(40.0 / 750.0 * kScreenWidth);
        make.right.equalTo(self.mas_right).offset(-40.0 / 750.0 * kScreenWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-420.0 / 1334.0 * kScreenHeight);
        
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
    
    
    self.textField2 = [UITextField new];
    self.textField2.backgroundColor = textFieldColor;
    self.textField2.placeholder = @"再次输入";
    self.textField2.delegate = self;
    self.textField2.keyboardType = UIKeyboardTypeNumberPad;
    self.textField2.secureTextEntry = YES;
    self.textField2.textColor = selectColor;
    [self.textField2 setValue:selectColor forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.textField2];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textField1.mas_bottom).offset(65 / 1334.0 * kScreenHeight);
        make.left.equalTo(self.textField1.mas_left);
        make.right.equalTo(self.textField1.mas_right);
        make.height.equalTo(self.textField1.mas_height);
        
    }];
    self.textField2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField2.leftViewMode = UITextFieldViewModeAlways;
    
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
        
        make.top.equalTo(self.textField2.mas_bottom).offset(65 / 1334.0 * kScreenHeight);
        make.right.equalTo(self.mas_right).offset(-100 / 750.0 * kScreenWidth);
        make.left.equalTo(self.mas_left).offset(100 / 750.0 * kScreenWidth);
        make.height.equalTo(self.textField2.mas_height);
        
    }];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.text = @"温馨提示";
    tishiLabel.textColor = [UIColor grayColor];
    tishiLabel.font = [UIFont systemFontOfSize:12.0];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tishiLabel];
    
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(corfimBtn.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *num1 = [NSString stringWithFormat:@"%@",[[defaults objectForKey:kuserTel] substringWithRange:NSMakeRange(0, 3)]];
    NSString *num2 = [NSString stringWithFormat:@"%@",[[defaults objectForKey:kuserTel] substringWithRange:NSMakeRange(7, 4)]];
    NSString *telephoneNumber = [NSString stringWithFormat:@"您的手机%@....%@已经完成绑定，通过手机验证，即可安全找回密码",num1,num2];
    UILabel *tishiLabel2 = [UILabel new];
    tishiLabel2.text = telephoneNumber;
    tishiLabel2.numberOfLines = 0;
    tishiLabel2.textColor = [UIColor grayColor];
    tishiLabel2.font = [UIFont systemFontOfSize:10.0];
    tishiLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tishiLabel2];
    
    [tishiLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tishiLabel.mas_bottom).offset(5.f);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(20.f);
        make.right.equalTo(self.mas_right).offset(-20.f);
    }];

}

@end
