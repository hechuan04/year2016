//
//  NotBindTelAlert.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "NotBindTelAlert.h"

@implementation NotBindTelAlert

- (void)createAlert:(UIColor *)selectColor
{
    UIFont *titleFont ;
    UIFont *contentFont;
    if (IS_IPHONE_5_SCREEN) {
        
        titleFont = [UIFont systemFontOfSize:17];
        contentFont = [UIFont systemFontOfSize:15];
        
    }else{
        
        titleFont = [UIFont systemFontOfSize:20];
        contentFont = [UIFont systemFontOfSize:18];
    }
    
    UILabel *titleLabel = [self _titleLabel:460 selectColor:selectColor text:@"password"];
    UIView *lineView = [self _lineView:titleLabel selectColor:selectColor];
    [self _backBtnWithType:firstIn];
    
    UILabel *tishi1 = [UILabel new];
    tishi1.textAlignment = NSTextAlignmentCenter;
    tishi1.text = @"温馨提示";
    tishi1.font = titleFont;
    [self addSubview:tishi1];
    
    [tishi1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20.f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *tishi2 = [UILabel new];
    //tishi2.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:7.f];
    
    NSDictionary *dic = @{NSParagraphStyleAttributeName:style,NSFontAttributeName:contentFont};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"您的手机号尚未绑定，为保证安全通过手机验证找回密码，您需要进行绑定后建立密码。" attributes:dic];
    tishi2.attributedText = str;
    tishi2.numberOfLines = 0;
    [self addSubview:tishi2];
    
    [tishi2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tishi1.mas_bottom).offset(10.f);
        make.left.equalTo(self.mas_left).offset(25.f);
        make.right.equalTo(self.mas_right).offset(-25.f);
    }];
    
    UIButton *corfimBtn = [UIButton new];
    [corfimBtn addTarget:self action:@selector(corfimAction:) forControlEvents:UIControlEventTouchUpInside];
    corfimBtn.backgroundColor = textFieldColor;
    corfimBtn.layer.borderWidth = 0.5;
    corfimBtn.layer.borderColor = selectColor.CGColor;
    corfimBtn.layer.masksToBounds = YES;
    corfimBtn.layer.cornerRadius = 10.0;
    [corfimBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [corfimBtn setTitleColor:selectColor forState:UIControlStateNormal];
    [self addSubview:corfimBtn];
    
    [corfimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tishi2.mas_bottom).offset(40 / 1334.0 * kScreenHeight);
        make.right.equalTo(self.mas_right).offset(-100 / 750.0 * kScreenWidth);
        make.left.equalTo(self.mas_left).offset(100 / 750.0 * kScreenWidth);
        make.height.mas_equalTo(80 / 1334.0 * kScreenHeight);
        
    }];

}

@end
