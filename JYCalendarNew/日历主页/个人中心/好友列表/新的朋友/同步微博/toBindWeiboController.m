//
//  toBindWeiboController.m
//  JYCalendarNew
//
//  Created by 何川 on 16-1-11.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "toBindWeiboController.h"

@interface toBindWeiboController ()

@property (strong, nonatomic) IBOutlet UIButton *bingWeiboBtn;

@end

@implementation toBindWeiboController

static toBindWeiboController *tbwController = nil;

+ (toBindWeiboController *)shareToBindWeiboController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tbwController == nil) {
            tbwController = [[toBindWeiboController alloc] init];
        }
    });
    
    return tbwController;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (tbwController == nil) {
            
            tbwController = [super allocWithZone:zone];
            
        }
    });
    
    return tbwController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //抬头
    self.navigationItem.title=@"绑定微博好友";
    
    //返回键
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;
    
    _bingWeiboBtn.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionForLeft:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bindWeibo:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kBindWeiBoLogin];
    
    WBAuthorizeRequest *weiboRequest = [WBAuthorizeRequest request];
    weiboRequest.redirectURI = kWeiboRedirectURI;
    weiboRequest.scope = @"all";
    
    //添加菊花图
    [ProgressHUD show:@"绑定微博中…"];
    
    [WeiboSDK sendRequest:weiboRequest];
}

#pragma mark 微博登录回调
- (void)didReceiveWeiboRequest:(WBBaseResponse *)request {}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response123 {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kBindWeiBoLogin];
    
    NSString *uid = response123.userInfo[@"uid"];
    if(uid == 0){
        //去掉菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"绑定微博失败！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        return;
    }
    
    NSString *token = response123.userInfo[@"access_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                              
    NSDictionary *parameters = @{@"uid":[defaults objectForKey:kUserXiaomiID], @"weibo":[[uid stringByAppendingString:@"|"] stringByAppendingString:token]};
    manager.requestSerializer.timeoutInterval = 10;
    
    //账号绑定微博
    [manager POST:[kXiaomiUrl stringByAppendingString:@"bindingWeibo"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){
            if([[responseObject objectForKey:@"bindWeibo"] isEqualToString:@"0"]){
                [defaults setObject:[[uid stringByAppendingString:@"|"] stringByAppendingString:token] forKey:kTiUpWeiBo];
                
                //去掉菊花
                [ProgressHUD dismiss];
                 
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"绑定微博成功！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterView show];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyWeiboListController *mwbVC = [[MyWeiboListController alloc] init];
                    mwbVC.weiboBindOpenId = uid;
                    mwbVC.weiboBindToken = token;
                    [self.navigationController pushViewController:mwbVC animated:YES];
                });
                
            }else{
                //去掉菊花
                [ProgressHUD dismiss];
                
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"该微博账号已被其他小秘账号绑定，无法再次绑定！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterView show];
            }
        }else{
            //去掉菊花
            [ProgressHUD dismiss];
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"绑定微博失败,请检查您的网络！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //去掉菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"绑定微博失败,请检查您的网络！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
    }];
    
}

@end