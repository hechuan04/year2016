//
//  JYZhengdianTB.h
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYZhengdianTB : UITableView<UITableViewDelegate,UITableViewDataSource>
- (void)setBtn;
@property (nonatomic ,strong)RemindModel *model;

@property (nonatomic ,copy)void (^confirmBlock)();
@property (nonatomic ,copy)void (^cancelBlock)();
@end
