//
//  JYSystemTitleVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSystemTitleVC.h"

@interface JYSystemTitleVC ()

@end

@implementation JYSystemTitleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([_model.weekStr isEqualToString:@"100"]) {
        
        [self systemAction1];
        
    }else{
    
        [self systemAction2];

    }
    
    
}


- (void)systemAction1{
    FriendListManager *manager = [FriendListManager shareFriend];
    
    FriendModel *fModel = [manager selectDataWithFid:_model.isOther];
    
    AddressBook *addbook = [AddressBook shareAddressBook];
    NSString *telNameStr = [addbook.dicForAllTelAndName objectForKey:fModel.tel_phone];
    NSString *nameStr = @"";
    if (telNameStr != nil) {
        
        nameStr = [NSString stringWithFormat:@"%@ (%@)",fModel.friend_name,telNameStr];
        
    }else{
        
        nameStr = [NSString stringWithFormat:@"%@",fModel.friend_name];
    }
    
    self.navigationItem.title = nameStr;
    UILabel *label = [UILabel new];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:nameStr attributes:@{NSForegroundColorAttributeName:bgBlueColor}];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(15.0);
        make.right.mas_equalTo(self.view.mas_right).offset(-15.0);
        
        make.top.mas_equalTo(self.view.mas_top).offset(10.0);
        
    }];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"通过了你的好友请求！"];
    [attrStr appendAttributedString:str];
    label.numberOfLines = 0;
    label.attributedText = attrStr;

}

- (void)systemAction2{

    UILabel *label = [UILabel new];
    self.navigationItem.title = @"好友名称变更";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(15.0);
        make.right.mas_equalTo(self.view.mas_right).offset(-15.0);
        make.top.mas_equalTo(self.view.mas_top).offset(10.0);
        
    }];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您的小秘好友"];
    NSAttributedString *beforeNameId = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ID%d",_model.timeorder,_model.year] attributes:@{NSForegroundColorAttributeName:bgBlueColor}];
    [str appendAttributedString:beforeNameId];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"信息已变更。ID变更为"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",_model.day] attributes:@{NSForegroundColorAttributeName:bgBlueColor}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@",昵称变更为"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.content] attributes:@{NSForegroundColorAttributeName:bgBlueColor}]];
     
    label.numberOfLines = 0;
    label.attributedText = str;

    
    
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
