//
//  JYContentTextView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/28.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYContentTextView.h"

@implementation JYContentTextView

- (instancetype)initWithFrame:(CGRect)frame 
{
   
    if (self = [super initWithFrame:frame]) {
    
        
        self.delegate = self;
        
        self.keyboardType = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeyDone;
     
    }

    return self;

}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    _changeFrame(YES);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self resignFirstResponder];
    
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView

{
    //textview 改变字体的行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    paragraphStyle.lineSpacing = 7;// 字体的行间距
//    
//    
//    
//    NSDictionary *attributes = @{
//                                 
//                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
//                                 
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 
//                                 };
//    
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
 
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        _changeFrame(NO);
        return NO;
    }
    
    
    return YES;
}

-(void)layoutSubviews
{
//    [super layoutSubviews];
    
//    _getContentsize(self.contentSize);
    
}

@end
