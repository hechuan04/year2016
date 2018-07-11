//
//  NewFriendBar.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/24.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "NewFriendBar.h"

@interface NewFriendBar ()

@end

@implementation NewFriendBar

- (void)awakeFromNib
{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _headImage.layer.cornerRadius = _headImage.width / 2.0;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.allowsGroupOpacity = true;

    });
}

- (void)actionForLeft:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _model.friend_name;
    
    NSString *xiaomiStr = [NSString stringWithFormat:@"%ld",(long)_model.fid];
    xiaomiStr = [NSString stringWithFormat:@"xiaomi%@",xiaomiStr];
    UIImage *image = [QRCodeGenerator qrImageForString:xiaomiStr imageSize:self.barImage.width*3];
    self.barImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.barImage setImage:image];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        _headImage.layer.cornerRadius = _headImage.width / 2.0;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.allowsGroupOpacity = true;
        
    });
    int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
    if (_model.fid == uid) {
        NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        
    }else{
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.head_url]];
    }
    
    self.nameLbael.text = _model.friend_name;
    self.xiaomiId.text = [NSString stringWithFormat:@"小秘号：%ld",(long)_model.fid];
    
    
    self.myContentView.layer.borderColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:0.5].CGColor;
    self.myContentView.layer.borderWidth = 1;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
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