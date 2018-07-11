//
//  JYContentTexgFiled.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYContentTexgFiled.h"

@implementation JYContentTexgFiled


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.keyboardType = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeyDone;
        
    }
    
    return self;
}

- (BOOL )textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    NSLog(@"%@",string);
//    NSLog(@"%@",toBeString);
//    NSLog(@"%@",textField.text);
//    
//    if (textField.text.length > 18) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return NO;
//    }
//    
    return YES;
}

//delegate代理方法,将要编辑出发的方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    _changeFrame(YES);
    return YES;
}

//点击return出发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    if (textField.text.length > 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"标题不能超过18个字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    [self resignFirstResponder];
 
    _changeFrame(NO);
    return YES;
}

- (CGRect )textRectForBounds:(CGRect)bounds
{
  
    return CGRectInset(bounds, 15, 0);
    
}

- (CGRect )editingRectForBounds:(CGRect)bounds
{

  
    return CGRectInset(bounds, 15, 0);
}

- (CGRect )placeholderRectForBounds:(CGRect)bounds
{
  
    return CGRectInset(bounds, 15, 0);
}

@end
