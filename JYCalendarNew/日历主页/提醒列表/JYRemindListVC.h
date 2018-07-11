//
//  JYRemindListVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JYSearchBar.h"
#import "JYRemindViewController.h"

@protocol searchBarDelegate <NSObject>

- (void)beginEdit;

- (void)editing:(NSString *)text;

- (void)endEdit:(NSString *)text;

@end

@interface JYRemindListVC : BaseViewController<JYRemindViewControllerDelegate>

@property (nonatomic ,assign)BOOL noSearch; //没有查询到内容
@property (nonatomic ,weak)id<searchBarDelegate>searchBarDelegate;
@property (nonatomic ,assign)BOOL isNowVC; //当前页面，不走代理

@property (nonatomic ,strong)ManagerForButton *managerForBtn;

@end
