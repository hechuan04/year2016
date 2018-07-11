//
//  GroupNameVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/5.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "GroupNameVC.h"
#import "GroupTextField.h"
@interface GroupNameVC ()
{
 
    GroupTextField *_textField;
    UITextField *groupTextField;
}
@end

@implementation GroupNameVC

- (void)viewDidLoad {
    [super viewDidLoad];

    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    
    [btnView setTitleColor:skinManager.colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;

   
    groupTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 60)];
    groupTextField.text = _strForGroupName;
    groupTextField.backgroundColor  = [UIColor whiteColor];
    
    UIView *viewForLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 60)];
    
    groupTextField.leftViewMode = UITextFieldViewModeAlways;
    groupTextField.leftView = viewForLeft;
    groupTextField.delegate = self;
    groupTextField.keyboardType = UIKeyboardAppearanceDefault;
    groupTextField.returnKeyType = UIReturnKeyDone;

    [self.view addSubview:groupTextField];
    
    [groupTextField becomeFirstResponder];
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
// 
//    if (toBeString.length > 18) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return NO;
//    }
    
    return YES;
    
}

//点击return出发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.text.length > 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"名称不能超过18个字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    [self popAction];
    
    [self resignFirstResponder];
    
    return YES;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (CGRect )textRectForBounds:(CGRect)bounds
{
    
    [groupTextField textRectForBounds:bounds];
    
    return CGRectInset(bounds, 15, 0);
    
}

- (CGRect )editingRectForBounds:(CGRect)bounds
{
    
    [groupTextField editingRectForBounds:bounds];
    
    return CGRectInset(bounds, 15, 0);
}

- (CGRect )placeholderRectForBounds:(CGRect)bounds
{
    [groupTextField placeholderRectForBounds:bounds];
    
    return CGRectInset(bounds, 15, 0);
}

- (void)rightAction
{
    if (groupTextField.text.length > 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"名称不能超过18个字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return ;
    }
    
    if ([groupTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"名称不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return ;

    }
    
    
    //检查群组名称是否已存在
    if([[FriendForGroupListManager shareFriendGroup] ifGroupNameHasExist:groupTextField.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该名称已存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self popAction];
}

- (void)actionForLeft:(UIButton *)sender
{
    //_actionForPopGroupName(textField.text);

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)popAction
{
 
    _actionForPopGroupName(groupTextField.text);
    
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
