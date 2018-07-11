//
//  PassWordDetailVC.h
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordDetailVC : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)NSMutableArray *heightArr;
@property (nonatomic ,strong)NSMutableArray *arrForModel;
@property (nonatomic ,strong)NSMutableArray *arrForDetailView;
@property (nonatomic ,strong)NSMutableArray *textViewHeight;
@property (nonatomic ,strong)PassWordTitleModel *titleModel;

@property (nonatomic ,assign)CGFloat widthForText;
@property (nonatomic ,assign)int arrIndex;  //第几行
//刷新数据
@property (nonatomic ,copy)void (^reloadDataBlock)(int index,NSArray *modelArr);
@property (nonatomic ,assign)BOOL firstIn;

@end
