//
//  PassWordDetail.m
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PassWordDetail.h"
#import <objc/runtime.h>
static void *PassWordTitleView = "PassWordTitleView";
static void *PassWordUserName = "PassWordUserName";
static void *PassWordSecret = "PassWordSecret";
#define kDeleteBtnHeight 44

@implementation PassWordDetail
{
 
    //NSString *_changeStr;
    UILabel    *_placeholderLabel;
    UIButton   *_deleteBtn;
    UIButton   *_confirmBtn;

}


- (void)dealloc
{
    NSLog(@"详情页也释放了");
}


- (instancetype)initWithFrame:(CGRect)frame
                        model:(PassWordModel *)pasModel
                        index:(int)index;
{
 
    if (self = [super initWithFrame:frame]) {
        
        _model = pasModel;
        _index = index;
        
        [self _createTime];
        [self _createDetial];
        
    }
    
    return self;
}

//创建时间label
- (void)_createTime
{
 
    _createTime = [UILabel new];
    _createTime.textAlignment = NSTextAlignmentRight;
    
    NSString *year = [_model.createTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [_model.createTime substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [_model.createTime substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [_model.createTime substringWithRange:NSMakeRange(8, 2)];
    NSString *minute  = [_model.createTime substringWithRange:NSMakeRange(10, 2)];
    
    _createTime.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
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

- (void)deleteAction:(UIButton *)sender
{
    
    if (_deleteModel) {
        _deleteModel(_model,_index,self);
    }
    NSLog(@"删除方法");
}

//创建内容
- (void)_createDetial
{
 
    NSArray *arr = [JYSkinManager shareSkinManager].detailArr;
    NSArray *arr1 = @[@"标题:",@"用户名:",@"密码:",@"描述:"];

    UIView *bgView = [UIView new];
    bgView.layer.borderColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0  alpha:1].CGColor;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.f;
    [self addSubview:bgView];
    
    __weak typeof(self) weekSelf = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(7.5);
        make.right.equalTo(self.mas_right).offset(-7.5);
        make.top.equalTo(self.createTime.mas_bottom);
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
                _title = [UITextField new];
                //运行时，把创建方法写到下边会报错
                [self _createChangeLabel:_title lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.title];
                //关联
                
                void (^block)(NSString *text) = ^(NSString *text){
                 
                    NSLog(@"标题 : %@",text);
                    if (![text isEqualToString:weekSelf.model.title]) {
                        
                        weekSelf.model.title = text;
                        weekSelf.confirmBtn.selected = NO;
                        [weekSelf passModel];
                    }else{
                     
                        [weekSelf reloadFrame];
                    }
                  

                    
                    
                    
                };
                
                
                objc_setAssociatedObject(_title, PassWordTitleView, block, OBJC_ASSOCIATION_COPY);
     
                
            }
                break;
                case 1:
            {
                _userName = [UITextField new];
                [self _createChangeLabel:_userName lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.userName];
                
                //关联
                void (^block)(NSString *text) = ^(NSString *text){
                 
                    NSLog(@"用户名: %@",text);
                    
                    if (![text isEqualToString:weekSelf.model.userName]) {
                        
                        weekSelf.model.userName = text;
                        weekSelf.confirmBtn.selected = NO;
                        [weekSelf passModel];
                    }else{
                        
                        [weekSelf reloadFrame];
                    }
                    
                };
                objc_setAssociatedObject(_userName, PassWordUserName, block, OBJC_ASSOCIATION_COPY);
                
                
            }
                break;
                case 2:
            {
                _passWord = [UITextField new];
                [self _createChangeLabel:_passWord lineV:lineV titleLabel:titleLabel bgView:bgView modelText:_model.passWord];
                
                //关联
                void (^block)(NSString *text) = ^(NSString *text){
                 
                    NSLog(@"密码 : %@",text);
                    
                    if (![text isEqualToString:weekSelf.model.passWord]) {
                        
                        weekSelf.model.passWord = text;
                        weekSelf.confirmBtn.selected = NO;
                        [weekSelf passModel];

                    }else{
                        
                        [weekSelf reloadFrame];
                    }
                    
                };
                objc_setAssociatedObject(_passWord, PassWordSecret, block, OBJC_ASSOCIATION_COPY);
                
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
                _detail.backgroundColor = [UIColor orangeColor];
                [bgView addSubview:_detail];
                _detail.delegate = self;
                [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lineV.mas_left).offset(5.0);
                    make.top.equalTo(titleLabel.mas_top).offset(10.0);
                    make.bottom.equalTo(bgView.mas_bottom).offset(0.0);
                    make.right.equalTo(lineV.mas_right);
                    
                }];
                
                _placeholderLabel = [UILabel new];
                _placeholderLabel.font = [UIFont systemFontOfSize:17.0];
                _placeholderLabel.text = @"最多可编辑150个字";
                _placeholderLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:0.3];
                [bgView addSubview:_placeholderLabel];
                [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lineV.mas_left).offset(5.0);
                    make.top.equalTo(titleLabel.mas_top).offset(10.0);
                    make.bottom.equalTo(bgView.mas_bottom).offset(-10.0-44.0);
                    make.right.equalTo(lineV.mas_right);
                    
                }];
                
                if (![_model.detail isEqualToString:@""]) {
                    
                    _placeholderLabel.hidden = YES;
                }
            
                
                _detail.textContainerInset = UIEdgeInsetsMake(3.f, 0, 0, -5.0);
                
            }
                break;
            default:
                break;
                
        }
        
        nextView = imageV;
    }
    
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setImage:[JYSkinManager shareSkinManager].deleteImage forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_deleteBtn];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(bgView.mas_bottom);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_centerX);
        make.height.mas_equalTo(44.f);

        
    }];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setImage:[JYSkinManager shareSkinManager].confirmImage forState:UIControlStateSelected];
    [_confirmBtn setImage:[JYSkinManager shareSkinManager].confirmImage forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_confirmBtn];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(bgView.mas_bottom);
        make.right.equalTo(bgView.mas_right);
        make.left.equalTo(bgView.mas_centerX);
        make.height.mas_equalTo(44.f);
   
    }];

    UIView *middleView = [UIView new];
    middleView.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [bgView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weekSelf.confirmBtn.mas_top);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(44.f);
    }];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [bgView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(bgView.mas_bottom).offset(-44.f);
        make.left.equalTo(bgView.mas_left).offset(15.f);
        make.right.equalTo(bgView.mas_right).offset(-15.f);
        make.height.mas_equalTo(0.5);
    }];
}

//保存方法
- (void)confirmAction:(UIButton *)sender
{
   
    [_title resignFirstResponder];
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    [_detail resignFirstResponder];
    
    [self performSelector:@selector(save) withObject:nil afterDelay:0.5];
  
    
}

- (void)save{

    if (_saveModel) {
        _saveModel(_model,_index,self);
    }
}

- (void)upAction
{
 

}



//创建可变label
- (void)_createChangeLabel:(UITextField *)changeLabel
                    lineV:(UIView *)lineV
               titleLabel:(UILabel *)titleLabel
                    bgView:(UIView *)bgView
                 modelText:(NSString *)text
{
    bgView.tag = 123;
    changeLabel.tag = 234;
    changeLabel.text = text;
    changeLabel.delegate = self;
    changeLabel.textColor = [UIColor blackColor];
    changeLabel.font = [UIFont systemFontOfSize:15.0];
    //changeLabel.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:changeLabel];
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineV.mas_left).offset(5.0);
        make.top.equalTo(titleLabel.mas_top);
        make.bottom.equalTo(titleLabel.mas_bottom);
        make.right.equalTo(lineV.mas_right);
        
    }];

    /*
    _deleteBtn = [UIButton new];
    _deleteBtn.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [bgView addSubview:_deleteBtn];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right);
        make.width.mas_equalTo(25.0);
        make.height.mas_equalTo(25.0);
        
    }];
    
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"passwordDelete.png"];
    [_deleteBtn addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_deleteBtn.mas_centerX);
        make.centerY.equalTo(_deleteBtn.mas_centerY);
        make.width.mas_equalTo(13.0);
        make.height.mas_equalTo(13.0);
        
    }];
    */
}


#pragma mark textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    if (range.location > 13) {
        textField.text = [textField.text substringToIndex:14];
        return NO;
    }
    NSLog(@"%@",string);
    */
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 
    _selectTextFieldBlock(textField,_index);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
 
    //title
    void (^titleBlock)(NSString *text) = objc_getAssociatedObject(textField, PassWordTitleView);
    if (titleBlock) {
        
        titleBlock(textField.text);
    }
    
    //userName
    void (^userNameBlock)(NSString *text) = objc_getAssociatedObject(textField, PassWordUserName);
    if (userNameBlock) {
        
        userNameBlock(textField.text);
    }
    
    //密码
    void (^secretBlock)(NSString *text) = objc_getAssociatedObject(textField, PassWordSecret);
    if (secretBlock) {
        
        secretBlock(textField.text);
    }
    
    
}

//textField结束编辑
- (void)passModel
{
    _endEditBlock(_model,_index);
}

//刷新
- (void)reloadFrame
{
    _reloadFrameBlock();
}

#pragma mark textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
 
    _placeholderLabel.hidden = YES;
    
    _numberLine = textView.contentSize.height / textView.font.lineHeight;
    
    NSLog(@"%lf",self.bottom);
    
    _selectTextViewBlock(textView,_index);
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *text = textView.text;
    if (textView.text.length > 150) {
        text = [textView.text substringToIndex:150];
        textView.text = text;
        
        [self textViewDidChange:textView];
    }
    
    _model.detail = text;
    _confirmBtn.selected = NO;

    if ([_model.detail isEqualToString:@""]) {
        
        _placeholderLabel.hidden = NO;
    }else{
     
        _placeholderLabel.hidden = YES;
    }
    
    [self passModel];
    
    [self setNeedsLayout];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    int line = textView.contentSize.height / textView.font.lineHeight;
    //NSLog(@"第几行:%d",_numberLine);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    //CGFloat gao = [textView.text boundingRectWithSize:CGSizeMake(textView.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
//    NSLog(@"换行调用：%@",textView.text);
//    NSLog(@"行数: %d",line);
//    NSLog(@"高度: %lf",gao);
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width, 0)];
    
    NSLog(@"宽度:%lf",size.width);
    NSLog(@"高度:%lf",size.height);
    
    if (_nextHeight != size.height) {
        
        NSLog(@"改变了！");
        _numberLine = line;
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
   
        CGFloat oneLine = [@"一行" boundingRectWithSize:CGSizeMake(textView.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
  
      
         _changeFrameBlock(_index,size.height + 435 / 2.0 + kDeleteBtnHeight - oneLine, size.height - oneLine);
        
     

        _nextHeight = size.height;
    }
  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
 
 
    if (range.location + text.length > 150) {
        
        NSInteger index = 150;
        if (range.location > 150) {
            index = 150;
        }else{
            index = range.location;
        }
        
        textView.text = [textView.text substringToIndex:index];

        return NO;
        
    }else{
     

        return YES;
    }
    
}


@end
