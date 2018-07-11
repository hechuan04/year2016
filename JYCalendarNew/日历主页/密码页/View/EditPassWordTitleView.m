
//
//  EditPassWordTitleView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/7/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "EditPassWordTitleView.h"

@implementation EditPassWordTitleView
{
   
    UITextField *_textField;
    UIButton *_confirm;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)textFieldChange123:(NSNotification *)obj
{
    //NSLog(@"%@",obj.object);
    UITextField *textField = (UITextField *)obj.object;
    NSString *text = textField.text;
    NSString *lang = [textField textInputMode].primaryLanguage;
    
    NSLog(@"%ld",text.length);
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        //判断是否是已经选中的状态
        UITextRange *selectRange = [textField markedTextRange];
        UITextPosition *postion = [textField positionFromPosition:selectRange.start offset:0];
        if (!postion) {
            
            if (text.length >= 16.0) {
                textField.text = [text substringWithRange:NSMakeRange(0, 15)];
            }
        }
        
    }else{
        
        if (text.length >= 16.0) {
            textField.text = [text substringWithRange:NSMakeRange(0, 15)];
        }
    }
    self.text = textField.text;
}
 

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
                      content:(NSString *)content
{
   
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange123:) name:@"UITextFieldTextDidChangeNotification" object:_textField];
        
        [self _createBGview:title content:content];
    }

    return self;
}

- (void)_createBGview:(NSString *)title
              content:(NSString *)content
{
  
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10.f;
    [self addSubview:bgView];
    
    NSLog(@"%lf",kScreenWidth);
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(200 / 1334.0 * kScreenHeight);
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 490/2.0)/ 2.0);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 490/2.0)/ 2.0);
        make.height.mas_equalTo(145.f);
        
    }];
    
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = lineColor;
    [bgView addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(-40.f);
        make.width.equalTo(bgView.mas_width);
        make.height.mas_equalTo(0.5);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = lineColor;
    [bgView addSubview:centerLine];
    
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(-40.f);
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    UIButton *cancelBtn = [UIButton new];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[JYSkinManager shareSkinManager].colorForDateBg};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"取消" attributes:dic];
    [cancelBtn setAttributedTitle:str forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_bottom).offset(-39.f);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    
    _confirm = [UIButton new];
    
    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[JYSkinManager shareSkinManager].colorForDateBg};
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"储存" attributes:dic1];
    [_confirm setAttributedTitle:str1 forState:UIControlStateNormal];
    [_confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_confirm];
    
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_bottom).offset(-39.f);
        make.right.equalTo(bgView.mas_right);
        make.left.equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];

    _textField = [UITextField new];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.leftView = leftView;
    _textField.layer.borderColor = lineColor.CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.font = [UIFont systemFontOfSize:15.f];
    [bgView addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_confirm.mas_top).offset(-10.f);
        make.left.equalTo(bgView.mas_left).offset(15.f);
        make.right.equalTo(bgView.mas_right).offset(-15.f);
        make.height.mas_equalTo(25.f);
        
    }];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:18];
    //titleLabel.backgroundColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(15.f);
        make.centerX.equalTo(bgView.mas_centerX);
        //make.height.mas_equalTo(30.f);
    }];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.text = content;
    //tishiLabel.backgroundColor = [UIColor yellowColor];
    tishiLabel.font = [UIFont systemFontOfSize:14];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tishiLabel];
    
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.centerX.equalTo(bgView.mas_centerX);
        //make.height.mas_equalTo(20.f);
    }];

}

- (void)setText:(NSString *)text
{
    if (text != _text) {
        _text = text;
       // _textField.text = _text;
        
        if ([_text isEqualToString:@""]) {
            
            NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor grayColor]};
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"储存" attributes:dic1];
            [_confirm setAttributedTitle:str1 forState:UIControlStateNormal];
            _confirm.userInteractionEnabled = NO;
            
        }else{
            NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[JYSkinManager shareSkinManager].colorForDateBg};
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"储存" attributes:dic1];
            [_confirm setAttributedTitle:str1 forState:UIControlStateNormal];
            _confirm.userInteractionEnabled = YES;

        }
    }
    
}

- (void)cancel:(UIButton *)sender
{
    _cancelBlock();
}

- (void)confirm:(UIButton *)sender
{
    _confirmBlock(_text);
}



@end
