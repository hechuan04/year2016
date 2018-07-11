//
//  PassWordVC.h
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordVC : UIViewController<UIAlertViewDelegate>

@property (nonatomic ,strong)UIButton *selectAllBtn;
@property (nonatomic ,strong)UIButton *deleteBtn;
@property (nonatomic ,strong)UIButton *shareBtn;
@property (nonatomic ,strong)UIButton *topBtn;

@property (nonatomic ,strong)NSArray  *dataArr;

@property (nonatomic ,assign)BOOL isEdit;

@end
