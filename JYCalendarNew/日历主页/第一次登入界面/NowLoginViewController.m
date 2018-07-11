//
//  NowLoginViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/9.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "NowLoginViewController.h"

#define widthForTitle 202 / 1334.0 * kScreenHeight
#define yForTitle 140 / 1334.0 * kScreenHeight

#define pageForZT 50 / 1334.0 * kScreenHeight

#define widthForZT 402 / 750.0 * kScreenWidth
#define heightForZT 30 / 1334.0 * kScreenHeight


#define pageForIconAndQQ 320 / 1334.0 * kScreenHeight


#define widthForBtn 502 / 750.0 * kScreenWidth
#define heightForBtn 74 / 1334.0 * kScreenHeight


#define pageForBtn 20 / 1334.0 * kScreenHeight

#define xForTextFiled 49 / 750.0 * kScreenWidth


#define xForMasBtn1 40 / 750.0 * kScreenWidth

#define xForMasBtn2 510 / 750.0 * kScreenWidth


@interface NowLoginViewController () {
 
    ShowScrollView *_showView;
    UIButton    *_wechatBtn;
    UIButton    *_weiboBtn;
    UIButton    *_qqBtn;
   
    UIButton    *_btnForTest;
    UIButton    *_iphoneLogin;
    
    UITextField    *_iphoneTextFiled;
    UITextField    *_testTextFiled;
    BOOL _isShowKeyBoard;
    
    NSTimer    *_timer;
    
    UILabel *_labelForTest;
    
    UIView *_bgView2;
    
    int _time60;
    
    TencentOAuth *tencentOAuth;
    
    UIButton * doneInKeyboaron;
    
}
@end

@interface NowLoginViewController(weChat)<WXApiDelegate>

- (void)actionForWechat;

@end

@implementation NowLoginViewController(weChat)

- (void)actionForWechat {

    [self wechatLogin];
    
}

- (void)wechatLogin {
    //注册微信
    [WXApi registerApp:@"wx2b07116467d44615"];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init] ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    //BOOL flag =  [WXApi sendReq:req];
    
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationItem setLeftBarButtonItem:nil];

    
    BOOL flag = [WXApi sendAuthReq:req viewController:self delegate:self];
    
    
    
    if (flag == 1) {

    }
}



#pragma mark 微信代理方法
- (void)onReq:(BaseReq *)req {
    
}

#pragma mark 回调方法。转换rootViewController
- (void)onResp:(BaseResp *)resp {
 
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    NSString *code = aresp.code;
    
    if (aresp.errCode == -2) {
        
        [ProgressHUD dismiss];

        return;
        
    }else if(aresp.errCode == -4){
    
        [ProgressHUD dismiss];

        return;
        
    }else if (aresp.errCode == 0) {
        //            NSString *code = aresp.code;
        //        NSDictionary *dic = @{@"code":code};
        //
        //第一步
        NSDictionary * oneDict = [self requestOne:code];
        
        if(oneDict){
            
            //第二步
            NSString *REFRESH_TOKEN = oneDict[@"refresh_token"];
            NSDictionary * secondDict = [self requestSecond:REFRESH_TOKEN];
            
            //第三步
            NSString *ACCESS_TOKEN = secondDict[@"access_token"];
            NSString *OPENID = secondDict[@"openid"];
            NSDictionary  * thirdDict = [self requestThird:ACCESS_TOKEN AndOPENID:OPENID];
            if (thirdDict != nil) {
                //说明用户信息不为空说明登陆成功

                //第一次上传
                [RequestManager actionForUpNameAndHead:weixinLogin thirdId:OPENID validate:nil];
            }
        }else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录异常，请检查您的网络设置!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alter show];
            [ProgressHUD dismiss];
        }
        
    }else {

        
    }
    
}

//第一步 获取code后，请求以下链接获取access_token,refresh_token
-(NSDictionary *)requestOne:(NSString * )code{
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx2b07116467d44615&secret=5440ea902c7b1fb02a5a7387499b5ec4&code=%@&grant_type=authorization_code",code];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic;
    if(response){
        weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    }
    
    return weatherDic;
}

//第二步refresh_token
-(NSDictionary *)requestSecond:(NSString *)REFRESH_TOKEN{
    
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx2b07116467d44615&grant_type=refresh_token&refresh_token=%@",REFRESH_TOKEN];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    return weatherDic;
    
}

//第三部 获取个人信息
-(NSDictionary *)requestThird:(NSString *)ACCESS_TOKEN AndOPENID:(NSString*)OPENID{
    
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",ACCESS_TOKEN,OPENID];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![[defaults objectForKey:kIsLogin] boolValue]) {
        
        [defaults setObject:[weatherDic objectForKey:@"nickname"] forKey:kUserName];
        [defaults setObject:[weatherDic objectForKey:@"headimgurl"] forKey:kUserHead];
        [defaults setObject:[weatherDic objectForKey:@"openid"] forKey:kThirdOpenID];
        
        [defaults setBool:YES forKey:kUserFirstLogin];
        [defaults setBool:YES forKey:kIsLogin];
        [defaults synchronize];
    }
    
    return weatherDic;
    
}

@end


@interface NowLoginViewController(weiBo)<WeiboSDKDelegate>

- (void)actionForWeibo;

@end

@implementation NowLoginViewController(weiBo)

- (void)actionForWeibo {
    
    WBAuthorizeRequest *weiboRequest = [WBAuthorizeRequest request];
    weiboRequest.redirectURI = kWeiboRedirectURI;
    weiboRequest.scope = @"all";
    weiboRequest.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                              @"Other_Info_1": [NSNumber numberWithInt:123],
                              @"Other_Info_2": @[@"obj1", @"obj2"],
                              @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};;
    
    [WeiboSDK sendRequest:weiboRequest];
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response123 {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = response123.userInfo[@"uid"];
    
    if(uid == 0){
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        [ProgressHUD dismiss];
        
        return;
    }
    
    NSString *token = response123.userInfo[@"access_token"];
    [defaults setObject:token forKey:kWeiboToken];
    
    NSString *urlStr =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",uid,token];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *dic = dict;
        
        NSString *name = dic[@"name"];
        NSString *headUrl = dic[@"profile_image_url"];
        
        if (![[defaults objectForKey:kIsLogin] boolValue]) {
            
            [defaults setObject:name forKey:kUserName];
            [defaults setObject:headUrl forKey:kUserHead];
            [defaults setObject:uid forKey:kThirdOpenID];
            
            [defaults setBool:YES forKey:kUserFirstLogin];
            [defaults setBool:YES forKey:kIsLogin];
            
            [defaults synchronize];
            //第一次上传头像
            [RequestManager actionForUpNameAndHead:weiboLogin thirdId:uid validate:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录异常，请检查您的网络设置!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alter show];
        [ProgressHUD dismiss];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {}

@end


@interface NowLoginViewController(QQ)<TencentSessionDelegate>

- (void)actionForQQ;

@end

@implementation NowLoginViewController(QQ)

#pragma mark -- TencentSessionDelegate
//登陆完成调用
- (void)tencentDidLogin {
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
        [tencentOAuth getUserInfo];
    }
    else {
    
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled {

    if (cancelled) {

        [ProgressHUD dismiss];
        
    }else{

        [ProgressHUD dismiss];

    }
    
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork {

    [ProgressHUD dismiss];

}

-(void)getUserInfoResponse:(APIResponse *)response {
    
//    #warning 增加腾讯的名字等
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = response.jsonResponse;
    NSString *name = [dic objectForKey:@"nickname"];
    NSString *uid = tencentOAuth.openId;
    NSString *headUrl = [dic objectForKey:@"figureurl_qq_2"];
    
    if (![[defaults objectForKey:kIsLogin] boolValue]) {
        
        [defaults setObject:name forKey:kUserName];
        [defaults setObject:headUrl forKey:kUserHead];
        [defaults setObject:uid forKey:kThirdOpenID];
        
        //[defaults setBool:YES forKey:kUserFirstLogin];
        //[defaults setBool:YES forKey:kIsLogin];
        [defaults synchronize];
        
        //第一次上传头像
        [RequestManager actionForUpNameAndHead:qqLogin thirdId:uid validate:nil];

    }

}

- (void)actionForQQ {
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104941751" andDelegate:self];
    [self loginAct];
}

-(void)loginAct {

    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo",nil];
    [tencentOAuth authorize:permissions inSafari:NO];
    
}

@end


@implementation NowLoginViewController

static NowLoginViewController *loginViewController = nil;

- (void)createTitleImage {
    
//    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForTitle / 2.0, yForTitle, widthForTitle, widthForTitle)];
//    _titleImage.image = [UIImage imageNamed:@"小秘标题.png"];
//    [self.view addSubview:_titleImage];
}

- (void)createLoginType {
    
//    _loginImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForZT / 2.0, _titleImage.bottom + pageForZT, widthForZT, heightForZT)];
//    _loginImage.image = [UIImage imageNamed:@"zt.png"];
//    [self.view addSubview:_loginImage];
}

- (void)createIphoneBtn{
 
 
    _showView = [[ShowScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 790/1334.0*kScreenHeight)];
    _showView.clipsToBounds = YES;
    _showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showView];
    
    //微信按钮
    [self createWechatBtn];
    
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _wechatBtn.bottom + 15, kScreenWidth, 100 / 1334.0 * kScreenHeight)];
    bgView1.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:217 / 255.0 alpha:1];
    [self.view addSubview:bgView1];
    
    
    NSMutableAttributedString *iphoneStr = [[NSMutableAttributedString alloc] initWithString:@"输入手机号"];
    [iphoneStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1] range:NSMakeRange(0, 5)];
    
    _iphoneTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(xForTextFiled, 0, kScreenWidth, bgView1.height)];
    _iphoneTextFiled.tag = 40;
    _iphoneTextFiled.delegate = self;
    _iphoneTextFiled.attributedPlaceholder = iphoneStr;
    _iphoneTextFiled.textColor = [UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1];
    _iphoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    [bgView1 addSubview:_iphoneTextFiled];

    
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.bottom + 1.5, kScreenWidth, bgView1.height)];
    _bgView2.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:217 / 255.0 alpha:1];
    [self.view addSubview:_bgView2];
    
    NSMutableAttributedString *secretStr = [[NSMutableAttributedString alloc] initWithString:@"输入验证码"];
    [secretStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1] range:NSMakeRange(0, 5)];
    
    _testTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(xForTextFiled, 0, kScreenWidth, bgView1.height)];
    _testTextFiled.tag = 50;
    _testTextFiled.delegate = self;
    _testTextFiled.attributedPlaceholder = secretStr;
    _testTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    _testTextFiled.textColor = [UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1];
    [_bgView2 addSubview:_testTextFiled];
    
    
    _btnForTest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForTest.frame = CGRectMake(584 / 750.0 * kScreenWidth, (bgView1.height - 52 / 1334.0 * kScreenHeight) / 2.0, 139 / 750.0 * kScreenWidth, 52 / 1334.0 * kScreenHeight);
    [_btnForTest addTarget:self action:@selector(actionForTest:) forControlEvents:UIControlEventTouchUpInside];
    _btnForTest.backgroundColor  = [UIColor colorWithRed:255 / 255.0 green:135 / 255.0 blue:129 / 255.0 alpha:1];
    [_btnForTest.titleLabel setFont:_btnTitleFontl];
    _btnForTest.layer.cornerRadius = 5;
    _btnForTest.layer.masksToBounds = YES;
    _btnForTest.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:254 / 255.0 alpha:1].CGColor;
    _btnForTest.layer.borderWidth = 0.5;
    [_bgView2 addSubview:_btnForTest];
    
    
    _labelForTest = [UILabel new];
    _labelForTest.text = @"发送验证码";
    _labelForTest.textColor = [UIColor whiteColor];
    _labelForTest.textAlignment = NSTextAlignmentCenter;
    _labelForTest.font = _btnTitleFontl;
    
    [_btnForTest addSubview:_labelForTest];
    
    [_labelForTest mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_btnForTest.mas_top);
        make.bottom.equalTo(_btnForTest.mas_bottom);
        make.left.equalTo(_btnForTest.mas_left);
        make.right.equalTo(_btnForTest.mas_right);
        
    }];
    

    
    CGFloat loginWidth = 505/750.0*kScreenWidth;
    CGFloat loginHeight = 90/1334.0*kScreenHeight;
    CGFloat loginY = _bgView2.bottom + 30/1334.0*kScreenHeight;
    _iphoneLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _iphoneLogin.frame = CGRectMake(kScreenWidth/2.0 - loginWidth/2.0, loginY, loginWidth, loginHeight);
    [_iphoneLogin addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_iphoneLogin setTitle:@"登录" forState:(UIControlStateNormal)];
    _iphoneLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_iphoneLogin setTitleColor:[UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1] forState:UIControlStateNormal];
    _iphoneLogin.backgroundColor  = [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:217 / 255.0 alpha:1];
        [self.view addSubview:_iphoneLogin];
    _iphoneLogin.layer.cornerRadius = 8;
    _iphoneLogin.layer.masksToBounds = YES;
    _iphoneLogin.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:135 / 255.0 blue:129 / 255.0 alpha:1].CGColor;
    _iphoneLogin.layer.borderWidth = 0.5;
    
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    [_testTextFiled resignFirstResponder];
    [_iphoneTextFiled resignFirstResponder];
    
}

- (void)actionForTest:(UIButton *)sender 
{
    
    
    if (_iphoneTextFiled.text.length < 11) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的手机号有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        return;
        
    }else{
        
        if ( [self checkTel:_iphoneTextFiled.text] == YES ) {
            
            NSLog(@"%@",_iphoneTextFiled.text);
            
            sender.userInteractionEnabled = NO;
            
            [RequestManager actionForPostTest:_iphoneTextFiled.text andBtn:sender];
            [_testTextFiled becomeFirstResponder];

        }   
    }

    NSLog(@"发送验证码");
}

- (void)_timerAction:(NSTimer *)timer
{
    _time60 --;

    _labelForTest.text = [NSString stringWithFormat:@"%d秒",_time60];
    

    if (_time60 == 0) {
        
        _labelForTest.text = @"重新发送";
        _time60 = 60;
        _btnForTest.userInteractionEnabled = YES;
        [timer invalidate];
    }
    
    
    NSLog(@"1");
    
}

//判断手机号是否合法
- (BOOL)checkTel:(NSString *)str {
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return NO;
        
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    
    NSLog(@"5555555  %@",string);
    
    if (textField.tag == 50) {
        
        if (textField.text.length >= 4 && ![string isEqualToString:@""]) {
            
            return NO;
        }
        
    }else{
     
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            
            return NO;
        }
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 
    if (textField.tag == 40) {
        
        NSLog(@"手机");
        [_testTextFiled resignFirstResponder];

    }else{
    
        NSLog(@"验证码");
        [_iphoneTextFiled resignFirstResponder];

        
    }
}


- (void)createWechatBtn {
    
    CGFloat btnWidth = 200/750.0*kScreenWidth;
    CGFloat btnHeight = 84/1334.0*kScreenHeight;
    CGFloat space = 40/750.0*kScreenWidth;
    CGFloat top = _showView.bottom + 30/1334.0*kScreenHeight;
    
    _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatBtn.frame = CGRectMake(40/750.0*kScreenWidth, top, btnWidth, btnHeight);
    _wechatBtn.tag = 10;
    [_wechatBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_wechatBtn setImage:[UIImage imageNamed:@"new微信"] forState:UIControlStateNormal];
    [self.view addSubview:_wechatBtn];
    
    
    _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqBtn.frame = CGRectMake(_wechatBtn.right + space, top, btnWidth, btnHeight);
    [_qqBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    _qqBtn.tag = 30;
    [_qqBtn setImage:[UIImage imageNamed:@"newQQ"] forState:UIControlStateNormal];
    [self.view addSubview:_qqBtn];
    
    
    _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weiboBtn.frame = CGRectMake(_qqBtn.right + space, top, btnWidth, btnHeight);
    [_weiboBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    _weiboBtn.tag = 20;
    [_weiboBtn setImage:[UIImage imageNamed:@"new微博"] forState:UIControlStateNormal];
    [self.view addSubview:_weiboBtn];
    

}

- (void)createWeiboBtn {
    _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [_weiboBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    _weiboBtn.tag = 20;
    [_weiboBtn setBackgroundImage:[UIImage imageNamed:@"wb.png"] forState:UIControlStateNormal];
    _weiboBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _weiboBtn.layer.borderWidth = 1;
    _weiboBtn.layer.cornerRadius = _heightForBtn / 2.0;
    _weiboBtn.layer.masksToBounds = YES;
    [self.view addSubview:_weiboBtn];
    
    [_weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_qqBtn.mas_left);
        make.right.equalTo(_qqBtn.mas_right);
        make.height.equalTo(_qqBtn.mas_height);
        make.top.equalTo(_showView.mas_bottom).offset(5.f);
    }];
    
}

- (void)createQQBtn {
    _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
    [_qqBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    _qqBtn.tag = 30;
    [_qqBtn setBackgroundImage:[UIImage imageNamed:@"QQ.png"] forState:UIControlStateNormal];
    _qqBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _qqBtn.layer.borderWidth = 1;
    _qqBtn.layer.cornerRadius = _heightForBtn / 2.0;
    _qqBtn.layer.masksToBounds = YES;
    [self.view addSubview:_qqBtn];
    
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(xForMasBtn1);
        make.right.equalTo(self.view.mas_right).offset(-xForMasBtn1);
        
        make.top.equalTo(_showView.mas_bottom).offset(150 / 1334.0 * kScreenHeight);
        make.height.mas_equalTo(_heightForBtn);
        
    }];
}

- (void)actionForLogin:(UIButton *)sender {
 
    [self.view endEditing:YES];
    [self.view becomeFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kWechatLogin];
    [defaults setBool:NO forKey:kWeiboLogin];
    [defaults setBool:NO forKey:kQQLogin];
    
    if (sender.tag == 10) {
        
        //微信
        [defaults setBool:YES forKey:kWechatLogin];

        [self actionForWechat];
        
    }else if(sender.tag == 20) {
    
        //微博
        [defaults setBool:YES forKey:kWeiboLogin];

        [self actionForWeibo];
        
    }else if(sender.tag == 30){
    
        //qq
        [defaults setBool:YES forKey:kQQLogin];

        [self actionForQQ];

    }else{
     
        
        if (_testTextFiled.text.length == 4 && _iphoneTextFiled.text.length == 11) {
            
  
            [RequestManager actionForUpNameAndHead:telLogin thirdId:_iphoneTextFiled.text validate:_testTextFiled.text];

            _iphoneTextFiled.text = @"";
            _testTextFiled.text   = @"";
            /*
            [RequestManager actionForBind:_testTextFiled.text andIPhone:_iphoneTextFiled.text finishBlock:^(BOOL success) {
                
                if (success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [_testTextFiled resignFirstResponder];
                        [_iphoneTextFiled resignFirstResponder];

                    });
                    
                  
                }
            }];
            */
            [_timer invalidate];
            
            _labelForTest.text = @"发送验证码";
            
            _btnForTest.userInteractionEnabled = YES;

            
            
        }else{
         
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入有误，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
        
   
        
        NSLog(@"自定义登录");
    }
    
}

+ (NowLoginViewController *)shareNowLoginViewController {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (loginViewController == nil) {
            loginViewController = [[NowLoginViewController alloc] init];
        }
    });
 
    return loginViewController;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (loginViewController == nil) {
            
            loginViewController = [super allocWithZone:zone];
            
        }
    });
    
    return loginViewController;
}

- (void)notificationAction
{
 
    _labelForTest.text = @"60秒";
   _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    
    _btnForTest.userInteractionEnabled = NO;
    

}

- (void)removeAllText
{
    JYSelectManager *select = [JYSelectManager shareSelectManager];
    
    [[NSUserDefaults standardUserDefaults] setObject:select.linshiUid forKey:kUserXiaomiID];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogin];
    
    _time60 = 60;
    _testTextFiled.text = nil;
    _iphoneTextFiled.text = nil;
    _btnForTest.userInteractionEnabled = YES;

}

- (void)dealloc
{
 
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kNotificationForTest];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kNotificationForTestAndIphone];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
//
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _time60 = 60;
    
    _isShowKeyBoard = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:kNotificationForTest object:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllText) name:kNotificationForTestAndIphone object:@""];
    
    
    if (IS_IPHONE_4_SCREEN) {
        
        _heightForBtn = heightForBtn + 10;
        _btnTitleFontl = [UIFont systemFontOfSize:10];
        
    }else{
     
        _heightForBtn = heightForBtn ;
        _btnTitleFontl = [UIFont systemFontOfSize:11];
    }
    
    
    
        
    //自定义登录
    [self createIphoneBtn];
    
    
    // 增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    // 增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAction:) name:UIKeyboardWillHideNotification object:nil];
  
  
}
#pragma mark -----
#pragma mark 通知

//当键盘出现或改变时调用
- (void)showKeyboardAction:(NSNotification *)notification
{

    if (!_isShowKeyBoard) {
 
        //获取键盘高度
        NSValue *keyboardRectAsObject=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect;
        [keyboardRectAsObject getValue:&keyboardRect];
        
        CGFloat curkeyBoardHeight = keyboardRect.size.height;
        CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // 第三方键盘回调三次问题，监听仅执行最后一次
        if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
            
            
            //设置动画的名字
            [UIView beginAnimations:@"Animation" context:nil];
            //设置动画的间隔时间
            [UIView setAnimationDuration:0.50];
            //使用当前正在运行的状态开始下一段动画
            [UIView setAnimationBeginsFromCurrentState: YES];
            //设置视图移动的位移
            self.view.frame = CGRectMake(0, 0 - curkeyBoardHeight, self.view.frame.size.width, self.view.frame.size.height);
            //设置动画结束
            [UIView commitAnimations];
            
            
            _isShowKeyBoard = YES;
            
            NSLog(@"keyboardWillShow");
            
        }     

    }
   
}

//当键退出时调用
- (void)hideKeyboardAction:(NSNotification *)notification
{
    
        
    if (_isShowKeyBoard) {
        
        //获取键盘高度
        NSValue *keyboardRectAsObject=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect;
        [keyboardRectAsObject getValue:&keyboardRect];
        
        //设置动画的名字
        [UIView beginAnimations:@"Animation" context:nil];
        //设置动画的间隔时间
        [UIView setAnimationDuration:0.50];
        //使用当前正在运行的状态开始下一段动画
        [UIView setAnimationBeginsFromCurrentState: YES];
        //设置视图移动的位移
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //设置动画结束
        [UIView commitAnimations];
        
        
        _isShowKeyBoard = NO;
        
        NSLog(@"keyboardWillHide");
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



