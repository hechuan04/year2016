//
//  RootTabViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic,assign) BOOL isFirstLogin;

+ (RootTabViewController *)shareInstance;

- (void)handle3DTouch;

- (void)logout;
@end
