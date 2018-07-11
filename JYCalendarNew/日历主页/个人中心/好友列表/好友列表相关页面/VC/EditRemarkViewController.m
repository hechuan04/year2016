//
//  EditRemarkViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "EditRemarkViewController.h"

#define kMaxTextLength 10

@interface EditRemarkViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *remarkField;
@property (nonatomic,strong) UILabel *limitLabel;
@end

@implementation EditRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    self.navigationItem.title = @"备注信息";
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    
    UITextField *field = [UITextField new];
    field.backgroundColor = [UIColor whiteColor];
    field.text = self.friendModel.remarkName;
    field.placeholder = @"十个字以内";
    UIView *viewForLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = viewForLeft;
    field.delegate = self;
    field.keyboardType = UIKeyboardAppearanceDefault;
    field.returnKeyType = UIReturnKeyDone;
    [field becomeFirstResponder];
//    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:field];
    self.remarkField = field;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                name:UITextFieldTextDidChangeNotification   object:field];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = [NSString stringWithFormat:@"%ld/10",self.friendModel.remarkName.length];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:label];
    self.limitLabel = label;

    [self.remarkField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(60.f));
    }];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkField.mas_bottom).offset(15.f);
        make.width.equalTo(@(80.f));
        make.right.equalTo(self.view).offset(-15.f);
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.remarkField.text = self.friendModel.remarkName;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction
{
    [self.view endEditing:YES];
    if (self.remarkField.text.length > 10) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"备注不能超过10个字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return ;
    }
    
//    if ([self.remarkField.text isEqualToString:@""]) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"备注不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return ;
//    }
    __weak typeof(self) ws = self;
    [RequestManager actionForSetRemark:self.remarkField.text
                             forFriend:[NSString stringWithFormat:@"%ld",ws.friendModel.fid]
                        completedBlock:^(id data, NSError *error) {
        
        [[FriendListManager shareFriend] updateRemarkName:ws.remarkField.text withFid:ws.friendModel.fid];
        NSString *remark = ws.remarkField.text;
        if(ws.actionForPopWithRemarkName){
            ws.actionForPopWithRemarkName(remark);
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)textFieldDidChange:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.remarkField) {
        
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
            }
        }
        
        self.limitLabel.text = [NSString stringWithFormat:@"%ld/%d",MIN(textField.text.length,kMaxTextLength),kMaxTextLength];
    }
}

@end
