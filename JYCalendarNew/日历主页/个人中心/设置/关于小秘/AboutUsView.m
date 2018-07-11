//
//  AboutUsView.m
//  aboutBar
//
//  Created by 何川 on 15-12-18.
//  Copyright (c) 2015年 金源互动科技有限公司. All rights reserved.
//

#import "AboutUsView.h"

@interface AboutUsView ()
@property (strong, nonatomic) IBOutlet UIImageView *gyqImageview;
@property (strong, nonatomic) IBOutlet UIImageView *lnycImageview;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation AboutUsView

- (void)actionForLeft:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toGYQ)];
    [_gyqImageview addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLNYC)];
    [_lnycImageview addGestureRecognizer:singleTap2];
    
    self.versionLabel.text = [NSString stringWithFormat:@"  小秘版本 %@",kAppVersion];
    if(IS_IPHONE_6P_SCREEN){
        self.bottomConstraint.constant = 5.f;
    }
    self.descLabel.text = @"@金源互动\n小秘©2016. JINYUAN TECHNOLOGY";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toGYQ {
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yin-qian-shang-xiang/id992045925?l=en&mt=8"]];
}
-(void)toLNYC {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/2016liu-nian-yun-cheng/id1050885664?l=en&mt=8"]];
}

@end
