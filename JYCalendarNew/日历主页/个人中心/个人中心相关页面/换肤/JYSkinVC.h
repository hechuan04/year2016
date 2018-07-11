//
//  JYSkinVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface JYSkinVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSUserDefaults *userDefault;
@property (nonatomic ,copy)NSString *selectColor;

@end
