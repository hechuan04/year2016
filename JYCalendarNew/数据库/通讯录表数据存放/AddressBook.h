//
//  AddressBook.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/23.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBook : NSObject

+ (AddressBook *)shareAddressBook;

@property (nonatomic ,strong)NSArray *arrForBeforeA; //还没请求下来
@property (nonatomic ,strong)NSArray *arrForAddress;
@property (nonatomic ,strong)NSArray *arrForFriend;

@property (nonatomic ,strong)NSDictionary *dicForAllName; //所有人
@property (nonatomic ,strong)NSDictionary *dicForAllTelAndName; //手机号和名字


- (void)actionForAddress;

@end
