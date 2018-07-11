//
//  EditRemarkViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface EditRemarkViewController : UIViewController

@property (nonatomic,strong) FriendModel *friendModel;

@property (nonatomic,copy) void (^actionForPopWithRemarkName)(NSString *remark);
@end
