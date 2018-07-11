//
//  JYZhengdianTimes.m
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/19.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYZhengdianTimes.h"
#import "JYZhengdianTB.h"
@interface JYZhengdianTimes ()

@end

@implementation JYZhengdianTimes

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    bgView.tag = 3000;
//    [self.view addSubview:bgView];
    
    JYZhengdianTB *zhengdianTb = [[JYZhengdianTB alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    zhengdianTb.model = self.model;
    //zhengdianTb.scrollEnabled = NO;
    [self.view addSubview:zhengdianTb];
    
    /*
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor grayColor].CGColor];
    gradientLayer.locations = @[@0.5,@1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, 25);
    
    
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 7 * 45.f - 64 - 25, kScreenWidth, 25)];
    //shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.14;
    [shadow.layer addSublayer:gradientLayer];
    [bgView addSubview:shadow];
    */
    
    [zhengdianTb setTableFooterView:[UIView new]];
    //[zhengdianTb setBtn];
    
    /*
    __weak typeof(self) weekSelf = self;
    [zhengdianTb setConfirmBlock:^{
        
        UIView *bgv = [weekSelf.view viewWithTag:3000];
        [bgv removeFromSuperview];
    }];
    
    [zhengdianTb setCancelBlock:^{
        UIView *bgv = [weekSelf.view viewWithTag:3000];
        [bgv removeFromSuperview];
    }];
    */
}

- (void)dealloc
{
    NSLog(@"释放");
    
}

- (void)actionForLeft:(UIButton *)sender
{
    if (_popBlock) {
        _popBlock();
    }
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
