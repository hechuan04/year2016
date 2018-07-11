//
//  SecretView.m
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SecretView.h"
#import <CommonCrypto/CommonDigest.h>


@implementation SecretView

- (void)dealloc
{
    NSLog(@"编辑密码页移除了");
}

- (UILabel *)_titleLabel:(CGFloat )bottom
             selectColor:(UIColor *)selectColor
                    text:(NSString *)text
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = text;
    if (kSystemVersion >= 8.2) {
        titleLabel.font = [UIFont systemFontOfSize:25 weight:0.1];
    }else{
        titleLabel.font = [UIFont systemFontOfSize:25];
    }
    
    titleLabel.textColor = selectColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(120 / 1334.0 * kScreenHeight);
        
    }];
   
    return titleLabel;
}

- (UIView *)_lineView:(UILabel *)titleLabel
          selectColor:(UIColor *)selectColor
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = selectColor;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLabel.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(1.0);
        
    }];
    
    return lineView;
}

- (void)_backBtnWithType:(NSInteger )type
{
    UIButton *backbtn = [UIButton new];
    [backbtn setImage:[UIImage imageNamed:@"passBack.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backbtn.tag = type;
    [self addSubview:backbtn];
    
    [backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.width.mas_equalTo(38 / 2.0);
        make.height.mas_equalTo(38 / 2.0);
        
    }];

}

- (void)backAction:(UIButton *)sender
{
    
    if (sender.tag == firstIn) {
        
        _cancelBtn(YES);
        
    }else if(sender.tag == changeIn){
        
        _cancelBtn(NO);
    }
}

- (void)createAlert:(UIColor *)selectColor
{};

- (void)backSecret:(UIButton *)sender
{
    _backSecretBlock();
    NSLog(@"找回密码");
}


- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)corfimAction:(UIButton *)sender
{
    if (_confirmBlock) {
        _confirmBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSLog(@"%ld",range.location);
    if (range.location > 7) {
                
        return NO;
    }else{
        
        return YES;
    }
    return YES;
}

@end
