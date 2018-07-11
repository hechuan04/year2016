//
//  JYSignVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface JYSignVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,copy)void (^actionForSign)(NSString *text);

@end
