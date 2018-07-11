//
//  JYSearchTableView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListTableView.h"

@interface JYSearchTableView : JYListTableView

//改变搜索内容
- (void)changeData:(NSArray *)data type:(NSInteger )type;
- (void)removeData;



//取消搜搜
@property (nonatomic ,copy)void (^cancelBlock)();

@property (nonatomic,strong) UIImageView *emptyImageViewForSearch;

@end
