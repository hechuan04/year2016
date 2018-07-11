//
//  JYLabelVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYLabelVC.h"
#define kMaxTextLength 15

@interface JYLabelVC ()<UITextFieldDelegate>

@end

@implementation JYLabelVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _labelText.text = _model.textStr;
    _labelText.delegate = self;
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(_saveRemind:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    [self.navigationItem setRightBarButtonItem:right];

    
    [_labelText becomeFirstResponder];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                name:UITextFieldTextDidChangeNotification   object:_labelText];
}

- (void)textFieldDidChange:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField == _labelText) {
        
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > kMaxTextLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxTextLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:kMaxTextLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxTextLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标签长度不能多于15个字!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)_saveRemind:(UIButton *)sender
{

    if(kSystemVersion<8.0){
        if([_labelText.text length]>15){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标签长度不能多于15个字!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    
    _model.textStr = _labelText.text;
    
    _passModel(_model);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)actionForLeft:(UIButton *)sender
{

    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
