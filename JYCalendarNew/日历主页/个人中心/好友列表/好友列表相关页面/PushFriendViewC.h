//
//  PushFriendViewC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/25.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "NewAddFriend.h"

@interface PushFriendViewC : NewAddFriend<UIAlertViewDelegate>

@property (nonatomic ,assign)BOOL isKeyStatus;

@property (nonatomic, assign) BOOL showRemarkView;//是否需要显示备注、之前列表需要显示自己、从自己跳转不需要显示备注
@property (nonatomic ,assign)BOOL onlyInspect;

@end
