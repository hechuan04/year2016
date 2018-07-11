//
//  JYRememberTB.h
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYRememberTB;
@protocol rememberTBDelegate <NSObject>

- (void)passModel:(RemindModel *)model;

@end

@interface JYRememberTB : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSArray *modelArr;
@property (nonatomic ,weak)id<rememberTBDelegate>modelDelegate;

@end
