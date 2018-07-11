//
//  GroupTextField.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/5.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "GroupTextField.h"

@implementation GroupTextField

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
        
        
        self.delegate = self;
        self.keyboardType = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeyDone;
    }
    
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}


//点击return出发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    _actionForPush();
    
    [self resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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
