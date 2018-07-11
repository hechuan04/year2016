//
//  JYCommand.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYInvker.h"
#import "JYTodayListView.h"
#import "JYListTableView.h"

@interface JYCommand : NSObject<InvkerProtocol>

@property (nonatomic ,copy)void (^commandComplete)();
- (UIAlertView *)showAlert:(NSString *)text;
- (UIAlertView *)showSingleAlert:(NSString *)text;
@end
