//
//  toBindWeiboController.h
//  JYCalendarNew
//
//  Created by 何川 on 16-1-11.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "MyWeiboListController.h"

@interface toBindWeiboController : UIViewController<WeiboSDKDelegate>

+ (toBindWeiboController *)shareToBindWeiboController;

@end
