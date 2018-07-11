//
//  SearchFriendModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SearchFriendModel.h"

@implementation SearchFriendModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if(self){
        
        self.uid = [[dic valueForKey:@"uid"] integerValue];
        if([[dic valueForKey:@"head"] isKindOfClass:[NSNull class]]){
            self.avatarUrl = @"";
        }else{
            self.avatarUrl = [dic valueForKey:@"head"];
        }
        NSString *remark = [dic valueForKey:@"remarkName"];
        if(![remark isKindOfClass:[NSNull class]]&&[remark length]>0){
            self.userName = [dic valueForKey:@"remarkName"];
        }else{
            self.userName = [dic valueForKey:@"userName"];
        }
        
        if([[dic valueForKey:@"tel"] isKindOfClass:[NSNull class]]){
            self.phoneNumber = @"";
        }else{
            self.phoneNumber = [dic valueForKey:@"tel"];
        }
        if([[dic valueForKey:@"status"] isKindOfClass:[NSNull class]]){
            self.status = 2;
        }else{
            self.status = [[dic valueForKey:@"status"] integerValue];
        }
        
        NSString *city = [dic valueForKey:@"city"];
        if(![city isKindOfClass:[NSNull class]]&&[city length]>0){
            self.location = [dic valueForKey:@"city"];
        }
        
        NSString *sign = [dic valueForKey:@"sign"];
        if(![sign isKindOfClass:[NSNull class]]&&[sign length]>0){
            self.signature = [dic valueForKey:@"sign"];
        }

    }
    return self;
}
- (FriendModel *)convertToFriendModel
{
    FriendModel *model = [FriendModel new];
    model.fid = self.uid;
    model.head_url = self.avatarUrl;
    model.friend_name = self.userName;
    model.tel_phone = self.phoneNumber;
    return model;
}
@end
