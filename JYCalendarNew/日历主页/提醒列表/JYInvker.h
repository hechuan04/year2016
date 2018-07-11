//
//  JYInvker.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InvkerProtocol <NSObject>

@required

- (void)execute;
- (void)rollBackExecute;

@end

@interface JYInvker : NSObject

+ (JYInvker *)shareInvker;

//群体操作
- (void)executeWithIndex:(NSInteger )index;
- (void)rollBack:(NSInteger )index;
- (void)rollBackAll;

//单个操作
- (void)addCommand:(id<InvkerProtocol>)command;
- (void)rollBack;

@property (nonatomic ,strong)NSMutableArray *commandList;
@property (nonatomic ,strong)NSMutableArray *commandArr;
@property (nonatomic ,strong)UIButton       *commandBtn;

@end
