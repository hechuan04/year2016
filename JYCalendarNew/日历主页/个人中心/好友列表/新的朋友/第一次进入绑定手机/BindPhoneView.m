//
//  BindPhoneView.m
//  JYCalendarNew
//
//  Created by 何川 on 15-12-16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "BindPhoneView.h"

#define kTagMergeDataTel 100001
#define kTagMergeDataSuccess 100002

@interface BindPhoneView ()
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *maText;
@property (strong, nonatomic) IBOutlet UIImageView *maButton;
@property (nonatomic,assign) NSInteger otherAccountUid;
@end

@implementation BindPhoneView

- (void)actionForLeft:(UIButton *)sender
{
    if (_present) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    //抬头
    self.navigationItem.title=@"绑定手机号";
    
    //返回键
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;
    
    //增加发送验证码手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmSendMa)];
    [_maButton addGestureRecognizer:singleTap];
    
    //下一步不可点
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 65, 50);
    //btnView.backgroundColor = [UIColor orangeColor];
    [btnView setTitle:@"下一步" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}
- (void)dealloc
{
    NSLog(@"绑定手机---dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmSendMa {
    //手机号校验
    if(![self isPureInt:_phoneText.text] || _phoneText.text.length!=11){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:[@"我们将发送验证码短信到这个号码：\n" stringByAppendingString:_phoneText.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

//发送验证码
- (void)sendMa {
    //设置联动关系
    [_maButton setImage:[UIImage imageNamed:@"验证码1.png"]];
    [_maButton setUserInteractionEnabled:NO];
    [self.phoneText setEnabled:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"uid":[defaults objectForKey:kUserXiaomiID], @"telNum":_phoneText.text};
    manager.requestSerializer.timeoutInterval = 10;
    
    //发送短信验证码
    [manager POST:[kXiaomiUrl stringByAppendingString:@"telValidate"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){
            
            if ([[responseObject objectForKey:@"erroType"] isEqualToString:@"1"]) {
                
//                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"该手机号已注册过小秘，是否将数据合并到此账号?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                alterView.tag = kTagMergeDataTel;
//                [alterView show];
                
                //恢复联动关系
                [_maButton setImage:[UIImage imageNamed:@"验证码.png"]];
                [_maButton setUserInteractionEnabled:YES];
                [self.phoneText setEnabled:YES];

                return;
            }
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"短信验证码发送失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            //恢复联动关系
            [_maButton setImage:[UIImage imageNamed:@"验证码.png"]];
            [_maButton setUserInteractionEnabled:YES];
            [self.phoneText setEnabled:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"短信验证码发送失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        //恢复联动关系
        [_maButton setImage:[UIImage imageNamed:@"验证码.png"]];
        [_maButton setUserInteractionEnabled:YES];
        [self.phoneText setEnabled:YES];
    }];
}

//确认验证码绑定手机
- (void)bindPhone {
    [self.view endEditing:YES];
    
    //验证码校验
    if(![self isPureInt:_maText.text] || _maText.text.length!=4){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"uid":[defaults objectForKey:kUserXiaomiID], @"validate":_maText.text, @"tel":_phoneText.text};
    manager.requestSerializer.timeoutInterval = 10;
    
    //发送短信验证码
    [manager POST:[kXiaomiUrl stringByAppendingString:@"binding"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){
            
            if([[responseObject objectForKey:@"bind"] isEqualToString:@"0"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手机绑定成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [defaults setBool:YES forKey:kTiUpTel];
                
                if (_present) {
                    
                    //确认绑定
                    if (_bind) {
                        _bind();
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                }else{
                    JYGroupViewController *grVC = [[JYGroupViewController alloc] init];
                    
                    //没网络的情况下，从新加载
//                    AddressBook *add = [AddressBook shareAddressBook];
                    
//                    [RequestManager actionForAddressBookWithArr:add.arrForBeforeA isNewFriend:NO];
                    
                    [self.navigationController pushViewController:grVC animated:YES];
                }
              
            }else if([[responseObject objectForKey:@"bind"] isEqualToString:@"-1"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"短信验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }else{
                self.otherAccountUid = [[responseObject objectForKey:@"bind"] integerValue];
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"该手机号已注册过小秘，是否将数据合并到此账号?" message:@"\n温馨提示:合并后的账号信息将被全部整理合并到当前账号，原账号信息将被注销，个人信息则以当前登陆账号为准。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alterView.tag = kTagMergeDataTel;
                [alterView show];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"短信验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手机绑定失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

//手机号整形判断
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == kTagMergeDataTel){
        if(buttonIndex==1){
            if(self.otherAccountUid>0){
                __weak typeof(self) ws = self;
                [RequestManager mergeDataFromOldId:self.otherAccountUid complete:^(id data, NSError *error) {
                    if(data){
                        if(alertView.tag == kTagMergeDataTel){
                            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                            [def setBool:YES forKey:kTiUpTel];
                            //绑定第三方ID
                            NSDictionary *dic = data[@"user"];
                            if (![dic[@"qq_third_id"] isKindOfClass:[NSNull class]]) {
                                [def setObject:dic[@"qq_third_id"] forKey:kQq_third_id];
                            }else{
                                [def setObject:@"" forKey:kQq_third_id];
                            }
                            if (![dic[@"weibo_third_id"] isKindOfClass:[NSNull class]]) {
                                [def setObject:dic[@"weibo_third_id"] forKey:kWeibo_third_id];
                            }else{
                                [def setObject:@"" forKey:kWeibo_third_id];
                            }
                            if (![dic[@"wx_third_id"] isKindOfClass:[NSNull class]]) {
                                [def setObject:dic[@"wx_third_id"] forKey:kWx_third_id];
                            }else{
                                [def setObject:@"" forKey:kWx_third_id];
                            }
                            NSString *tel = [NSString stringWithFormat:@"%@",dic[@"tel"]];
                            [def setObject:tel forKey:kuserTel];
                            [def synchronize];

                            
                            if (ws.present) {
                                //确认绑定
                                if (ws.bind) {
                                    ws.bind();
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                
                            }else{
                                
                                                           }

                        }
                    }
                    ws.otherAccountUid = 0;
                    [RequestManager actionForReloadData];
                    [RequestManager actionForSelectFriendIsNewFriend:YES];
                    [RequestManager loadAllPassWordWithResult:^(id responseObject) {}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeSecretList object:nil];
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"数据合并成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        alertView.tag = kTagMergeDataSuccess;
                        [alertView show];
                    });
                }];
            }
        }
    }else if(alertView.tag==kTagMergeDataSuccess){
        
            AddressBook *add = [AddressBook shareAddressBook];
            [add actionForAddress];
            
            JYGroupViewController *grVC = [[JYGroupViewController alloc] init];
            //没网络的情况下，从新加载
            //                                AddressBook *add = [AddressBook shareAddressBook];
            //                                [RequestManager actionForAddressBookWithArr:add.arrForBeforeA isNewFriend:NO];
            [self.navigationController pushViewController:grVC animated:YES];
        

    }else if(buttonIndex == 1){
        [self sendMa];
    }
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    // 隐藏键盘.
    [sender resignFirstResponder];
}

- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
