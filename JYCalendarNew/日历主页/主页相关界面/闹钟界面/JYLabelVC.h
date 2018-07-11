//
//  JYLabelVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface JYLabelVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *labelText;

@property (nonatomic ,strong)ClockModel *model;

@property (nonatomic ,copy)void (^passModel)(ClockModel *model);

@end
