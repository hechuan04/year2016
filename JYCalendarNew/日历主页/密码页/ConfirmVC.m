//
//  ConfirmVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/6/24.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ConfirmVC.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

static void *setSuccess = "setSuccess";
@interface ConfirmVC ()
{
 
    UITextField *_newSecret;
    UITextField *_confirmSecret;
    UIButton    *_corfimrBtn;
}
@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置密码";
    _newSecret = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    _newSecret.placeholder = @"请输入新密码";
    _newSecret.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
    label.text = @"新密码";
    label.textAlignment = NSTextAlignmentCenter;
    _newSecret.leftViewMode = UITextFieldViewModeAlways;
    _newSecret.leftView = label;
    _newSecret.delegate = self;
    _newSecret.secureTextEntry = YES;
    [self.view addSubview:_newSecret];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, _newSecret.bottom, kScreenWidth, 0.5)];
    topLine.backgroundColor = lineColor;
    [self.view addSubview:topLine];
    
    _confirmSecret = [[UITextField alloc] initWithFrame:CGRectMake(0, topLine.bottom, kScreenWidth, 55)];
    _confirmSecret.placeholder = @"请再次输入新密码";
    _confirmSecret.secureTextEntry = YES;
    _confirmSecret.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 55)];
    label1.text = @"确认新密码";
    label1.textAlignment = NSTextAlignmentCenter;
    _confirmSecret.leftViewMode = UITextFieldViewModeAlways;
    _confirmSecret.leftView = label1;
    _confirmSecret.delegate = self;
    [self.view addSubview:_confirmSecret];

    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _confirmSecret.bottom, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    [self.view addSubview:bottomLine];
    
    _corfimrBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, _confirmSecret.bottom + 60, kScreenWidth - 50, 40)];
    _corfimrBtn.layer.masksToBounds = YES;
    _corfimrBtn.layer.cornerRadius = 10.f;
    _corfimrBtn.backgroundColor = bgRedColor;
    [_corfimrBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_corfimrBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [_corfimrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_corfimrBtn];
}

- (void)confirmAction:(UIButton *)sender
{
   
 
    if ([_newSecret.text isEqualToString:_confirmSecret.text]) {
        
        if (_newSecret.text.length <= 5) {
            
            [self showAlert:@"您输入的密码过短，请重新输入"];
            
            _newSecret.text = @"";
            _confirmSecret.text = @"";
            
        }else{
        
            __weak typeof(self) weekSelf = self;
            [RequestManager changePassWordWithStr:[self md5:_newSecret.text] complish:^(BOOL success, int mid) {
                
                if (success) {
                    //设置密码
                    [[NSUserDefaults standardUserDefaults] setObject:[self md5:_newSecret.text] forKey:@"passWord"];
                    
                    UIAlertView *alert = [self showAlert:@"设置密码成功"];
                    
                    void (^successBlock)() = ^{
                    
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeSecret object:nil];
                        
                        [weekSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    };
                    
                    objc_setAssociatedObject(alert, setSuccess, successBlock, OBJC_ASSOCIATION_COPY);
 
                }else{
                    
                    [weekSelf showAlert:@"服务器异常，请重试"];
                    NSLog(@"设置密码失败");
                }
                
            }];
        }
   
    }else{
    
        [self showAlert:@"您俩次输入的密码不一致，请重新输入"];
        
    }
}

- (UIAlertView *)showAlert:(NSString *)text
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:text message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alterView show];
    return alterView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^successBlock)() = objc_getAssociatedObject(alertView, setSuccess);
    if (successBlock) {
        successBlock();
    }
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    if (range.location > 7) {
        
        return NO;
    }else{
     
        return YES;
    }
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
