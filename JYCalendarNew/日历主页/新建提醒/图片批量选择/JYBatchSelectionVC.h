//
//  JYBatchSelectionVC.h
//  JYCalendarNew
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBatchSelectionVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,copy)void (^actionBatchSelection)(NSArray *imageArr);
@property (nonatomic ,assign)NSInteger imageCount;

@property (nonatomic,assign) NSInteger limitCount;
@end
