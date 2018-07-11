//
//  BackSecretVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/6/24.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BackSecretVC.h"
#import "ConfirmVC.h"
#import <objc/runtime.h>
static void *telephoneBlock = @"telephoneBlock";
static void *testBlock      = @"testBlock";

@interface BackSecretVC ()
{
 
    UITextField *_telephoneNumber;
    UITextField *_testNumber;
    UIButton    *_testBtn;
    UIButton    *_changeSecretBtn;
    int i;
    NSString    *_testStr;
    
}
@end

@implementation BackSecretVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 60;
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self _createTextField];
    [self _createLeftBtn];
}

- (void)_createLeftBtn
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,60, 20)];
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSForegroundColorAttributeName:[JYSkinManager shareSkinManager].colorForDateBg,NSFontAttributeName:[UIFont systemFontOfSize:17.0]} ];
    [leftBtn setAttributedTitle:text forState:UIControlStateNormal];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 18)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)backAction:(UIButton *)sender
{

    [_testNumber resignFirstResponder];
    [_telephoneNumber resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    [_testNumber resignFirstResponder];
    [_telephoneNumber resignFirstResponder];
    
}

- (void)_createTextField
{
 
    _telephoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    _telephoneNumber.placeholder = @"请输入手机号";
    _telephoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
    label.text = @"手机号";
    label.textAlignment = NSTextAlignmentCenter;
    _telephoneNumber.leftViewMode = UITextFieldViewModeAlways;
    _telephoneNumber.leftView = label;
    _telephoneNumber.delegate = self;
    [self.view addSubview:_telephoneNumber];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, _telephoneNumber.bottom, kScreenWidth, 0.5)];
    topLine.backgroundColor = lineColor;
    [self.view addSubview:topLine];
    
    _testNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, topLine.bottom, kScreenWidth, 55)];
    _testNumber.placeholder = @"请输入验证码";
    _testNumber.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
    label1.text = @"验证码";
    label1.textAlignment = NSTextAlignmentCenter;
    _testNumber.leftViewMode = UITextFieldViewModeAlways;
    _testNumber.leftView = label1;
    _testNumber.delegate = self;
    [self.view addSubview:_testNumber];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _testNumber.bottom, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    [self.view addSubview:bottomLine];
    
    
    _testBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70 - 15,55 + (55 - 25) / 2.0, 70, 25)];
    _testBtn.layer.masksToBounds = YES;
    _testBtn.layer.cornerRadius = 5.f;
    _testBtn.layer.borderColor = bgPinkColor.CGColor;
    _testBtn.backgroundColor = [UIColor whiteColor];
    _testBtn.layer.borderWidth = 1.f;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发送验证码" attributes:@{NSForegroundColorAttributeName:bgPinkColor,NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
    [_testBtn setAttributedTitle:str forState:UIControlStateNormal];
    [_testBtn addTarget:self action:@selector(sendTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testBtn];
    
    
    [self _textFieldBlock];
    
    _changeSecretBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, _testNumber.bottom + 60, kScreenWidth - 50, 40)];
    _changeSecretBtn.layer.masksToBounds = YES;
    _changeSecretBtn.layer.cornerRadius = 10.f;
    _changeSecretBtn.backgroundColor = lineColor;
    [_changeSecretBtn addTarget:self action:@selector(changeSecretAction:) forControlEvents:UIControlEventTouchUpInside];
    [_changeSecretBtn setTitle:@"验证" forState:UIControlStateNormal];
    [_changeSecretBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_changeSecretBtn];
    _changeSecretBtn.userInteractionEnabled = NO;
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:@"UITextFieldTextDidChangeNotification" object:_testNumber];
}

//textField改变的通知
- (void)textFieldChange:(NSNotification *)obj{
    
    //NSLog(@"%@",obj.object);
    UITextField *textField = (UITextField *)obj.object;
    NSString *text = textField.text;
    
    if (text.length == 4 && _telephoneNumber.text.length == 11) {
        _changeSecretBtn.backgroundColor = bgRedColor;
        _changeSecretBtn.userInteractionEnabled = YES;
    }else{
        _changeSecretBtn.backgroundColor = lineColor;
        _changeSecretBtn.userInteractionEnabled = NO;
    }
    
}


- (void)changeSecretAction:(UIButton *)sender
{
   
    if ([_testStr isEqualToString:_testNumber.text]) {
        
        ConfirmVC *vc = [[ConfirmVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码有误，请重新输入" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
 
    NSLog(@"验证");
}

- (void)sendTest:(UIButton *)sender
{
 
    if (_telephoneNumber.text.length != 11) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码输入有误，请重新输入" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        return;
        
    }else{
        
        sender.userInteractionEnabled = NO;
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@telValidate",kXiaomiUrl];
        NSDictionary *dic = @{@"telNum":_telephoneNumber.text};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
                
                //NSLog(@"%@",[[responseObject objectForKey:@"validateNum"] class])
                _testStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"validateNum"]];
               
                NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器异常" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
               
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
          
            NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
            NSLog(@"%@",error);
        }];
        
    }
}

- (void)timerAction:(NSTimer *)timer
{
    i--;
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%2d",i] attributes:@{NSForegroundColorAttributeName:bgPinkColor}];
    [_testBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    if (i == 0) {
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"重新发送验证码" attributes:@{NSForegroundColorAttributeName:bgPinkColor,NSFontAttributeName:[UIFont systemFontOfSize:9.0]}];
        [_testBtn setAttributedTitle:str forState:UIControlStateNormal];
        _testBtn.userInteractionEnabled = YES;
        i = 60;
        [timer invalidate];
    }
    
    
    
    NSLog(@"1");
    
}

- (void)_textFieldBlock
{
    //根据相应的block返回对应的textField
    BOOL (^_telephoneBlock)(NSRange range) = ^(NSRange range){
    
        if (range.location > 10) {
            
            return NO;
        }
        return YES;
    };
    
    objc_setAssociatedObject(_telephoneNumber, telephoneBlock, _telephoneBlock, OBJC_ASSOCIATION_COPY);
    
    BOOL (^_testBlock)(NSRange range) = ^(NSRange range){
     
        if (range.location > 3) {
            
            return NO;
        }
        return YES;
    };
    
    objc_setAssociatedObject(_testNumber, testBlock, _testBlock, OBJC_ASSOCIATION_COPY);
    
}

#pragma mark -textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    BOOL (^phoneBlock)(NSRange range) = objc_getAssociatedObject(textField, telephoneBlock);
    if (phoneBlock) {
        
        return phoneBlock(range);
        
    }
    
    BOOL (^_testBlock)(NSRange range) = objc_getAssociatedObject(textField, testBlock);
    if (_testBlock) {
        
        return _testBlock(range);
    }

    return NO;
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
