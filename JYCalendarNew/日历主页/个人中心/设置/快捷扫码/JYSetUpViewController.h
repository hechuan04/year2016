//
//  JYSetUpViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSetUpViewController : UIViewController<UIAlertViewDelegate,ZBarReaderDelegate,ZBarReaderViewDelegate>


@property (nonatomic ,strong)NSArray *arrForLunarModel;
@property (nonatomic ,assign)BOOL isDisturb;
@property (nonatomic ,strong)ZBarReaderView *readerView;
@property (nonatomic ,assign)BOOL isBack;   //是否是返回上个页面还是关闭扫描二维码

@end
