//
//  JYInvker.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYInvker.h"
static JYInvker *manager = nil;
@implementation JYInvker

+ (JYInvker *)shareInvker
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[JYInvker alloc] init];
            manager.commandArr = [NSMutableArray array];
            manager.commandList = [NSMutableArray array];
        }
    });
    
    return manager;
}



- (void)addCommandNotExecute:(id<InvkerProtocol>)command
{
    [_commandList addObject:command];
}

- (void)executeWithIndex:(NSInteger )index
{
    [_commandList[index] execute];
}

- (void)rollBack:(NSInteger)index
{
    [_commandList[index] rollBackExecute];
}

- (void)rollBackAll
{
    for (id<InvkerProtocol> command in _commandList) {
        [command rollBackExecute];
    }
    
    [_commandList removeAllObjects];
    
    //编辑&分享按钮变为NO
    _commandBtn.selected = NO;
}



/////////////////////////单独
- (void)addCommand:(id<InvkerProtocol>)command
{
    [command execute];
    [_commandArr addObject:command];
}

- (void)rollBack
{
    [_commandArr.lastObject rollBackExecute];
    [_commandArr removeLastObject];
}




@end
