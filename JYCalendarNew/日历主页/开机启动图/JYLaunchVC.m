//
//  JYLaunchVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYLaunchVC.h"
#import "JYMainViewController.h"
#import "RootTabViewController.h"
#import "AppDelegate.h"

#define widthForTitle 202 / 1334.0 * kScreenHeight
#define yForTitle 260 / 1334.0 * kScreenHeight

#define widthForCompany 601 / 750.0 * kScreenWidth
#define heightForCompany 57 / 1334.0 * kScreenHeight

#define pageForCompany 70 / 1334.0 * kScreenHeight

#define pageForZT 50 / 1334.0 * kScreenHeight

#define widthForZT 283 / 750.0 * kScreenWidth
#define heightForZT 37 / 1334.0 * kScreenHeight

@interface JYLaunchVC ()

{
 
    UIImageView *_titleImage;
    UIImageView *_loginImage;
    UIImageView *_companyImage;
    JYMainViewController *jyMainVc;
}

@end

@implementation JYLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:98 / 255.0 alpha:1];
    
    [self createTitle];
    
    [self createLoginType];
    
    [self createCompany];
    

    //新加，通过3d touch启动，不要再睡3秒了
    if(kAppDelegate.forceTouchArgument!=ForceTouchTypeNone){
        kAppDelegate.forceTouchArgument=ForceTouchTypeNone;
        [self performSelector:@selector(changeRootVC)];
    }else{
        [self performSelector:@selector(changeRootVC) withObject:nil afterDelay:0.5];
    }
    
    
}

- (void)changeRootVC
{
    //请求后台数据，同步
    [RequestManager actionForReloadData];
    //同步好友数据
    //[RequestManager actionForSelectFriendIsNewFriend:YES];
    //同步待接收好友状态
    //[RequestManager actionForSelectLoginFriendIsNew:NO];
    //同步群组数据
    [RequestManager actionForGroup];
 
//    jyMainVc = [[JYMainViewController alloc] init];
// 
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:jyMainVc];
    
//    JYTabBarVC *tabVC = [[JYTabBarVC alloc] init];
    
    RootTabViewController *tabVC = [RootTabViewController shareInstance];
    UIApplication *pla = [UIApplication sharedApplication];
    pla.delegate.window.rootViewController = tabVC;
}

- (void)createTitle
{
 
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForTitle / 2.0, yForTitle, widthForTitle, widthForTitle)];
    _titleImage.image = [UIImage imageNamed:@"小秘标题.png"];
    [self.view addSubview:_titleImage];
    
}

- (void)createLoginType
{
 
    _loginImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForZT / 2.0, _titleImage.bottom + pageForZT, widthForZT, heightForZT)];
    _loginImage.image = [UIImage imageNamed:@"zt.png"];
    _loginImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_loginImage];
}


- (void)createCompany
{
 
//    _companyImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForCompany / 2.0, kScreenHeight - heightForCompany - pageForCompany, widthForCompany, heightForCompany)];
//    _companyImage.image = [UIImage imageNamed:@"bbh.png"];
//    [self.view addSubview:_companyImage];

    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForCompany / 2.0, kScreenHeight - heightForCompany - pageForCompany, widthForCompany, heightForCompany)];
    companyLabel.text = @"@金源互动\n小秘©2016. JINYUAN TECHNOLOGY";
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.font = [UIFont systemFontOfSize:10.f];
    companyLabel.textColor = [UIColor whiteColor];
    companyLabel.numberOfLines = 2;
    [self.view addSubview:companyLabel];
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
