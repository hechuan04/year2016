//
//  FirstLaunchVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLaunchVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic ,copy)void (^pushForLogin)();

@end
