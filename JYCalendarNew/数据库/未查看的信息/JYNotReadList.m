//
//  JYNotReadList.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYNotReadList.h"

static JYNotReadList *notReadList = nil;

@implementation JYNotReadList

+ (JYNotReadList *)shareNotReadList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        notReadList = [[JYNotReadList alloc] init];
        
    });
    
    return notReadList;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        notReadList = [super allocWithZone:zone];
    });
    
    return notReadList;
}

- (void)selectNotReadRemind
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
    
        int number = 0;
        NSString *sql = [NSString stringWithFormat:@"SELECT isLook FROM saveIncident union all SELECT isLook FROM shareList"];
        
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
       
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                    
                int a = sqlite3_column_int(stmt, 0);
                
                number += a;
                    
            }
       
        }
        
        int newFriendNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] intValue];
        NSLog(@"未查看事件 ： %d",number);
        NSLog(@"未添加好友 ： %d",newFriendNumber);
        ManagerForButton *manager = [ManagerForButton shareManagerBtn];
        
        int allNumber = number + newFriendNumber;
        
        if (allNumber > 0) {
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = allNumber;
            
        }else{
         
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        }
        
        if (number > 0) {
            
            manager.numberLabelForRemind.text = [NSString stringWithFormat:@"%d",number];
            manager.numberLabelForRemind.hidden = NO;
            
        }else{
         
            manager.numberLabelForRemind.hidden = YES;
        }
        
        
        
        if (newFriendNumber > 0) {
//            manager.numberLabelForPerson.text = [NSString stringWithFormat:@"%d",newFriendNumber];
//            manager.numberLabelForPerson.hidden = NO;
            
            id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
            if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
                if (newFriendNumber > 0) {
                    ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%d",newFriendNumber];
                }
            }
            
            manager.numberOfNewfriendLabel.hidden = NO;
            manager.numberOfNewfriendLabel.text = [NSString stringWithFormat:@"%d",newFriendNumber];
            
        }else{
            
//            manager.numberLabelForPerson.hidden = YES;
            manager.numberOfNewfriendLabel.hidden = YES;
            
            id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
            if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
                
                ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = nil;
            }

        }
        
        
    }else{
    
    }
    
    
}

- (void)selectNotReadFriend
{

}

@end
