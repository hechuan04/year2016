//
//  JYCommand.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCommand.h"

@implementation JYCommand

- (UIAlertView *)showAlert:(NSString *)text
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:text message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alterView show];
    return alterView;
}

- (UIAlertView *)showSingleAlert:(NSString *)text
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:text message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alterView show];
    return alterView;
}

- (void)execute
{
    
}

- (void)rollBackExecute
{
    
}

- (void)dealloc
{
    NSLog(@"销毁了！！！！！");
}

@end
