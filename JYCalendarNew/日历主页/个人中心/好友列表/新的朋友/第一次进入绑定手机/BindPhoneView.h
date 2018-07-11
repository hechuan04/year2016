//
//  BindPhoneView.h
//  JYCalendarNew
//
//  Created by 何川 on 15-12-16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYGroupViewController.h"

@interface BindPhoneView : UIViewController<UIAlertViewDelegate>
@property (nonatomic ,assign)BOOL present;
@property (nonatomic ,copy)void (^bind)();
@end
