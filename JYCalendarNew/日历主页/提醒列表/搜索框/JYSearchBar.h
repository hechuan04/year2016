//
//  JYSearchBar.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSearchBar : UISearchBar<UISearchBarDelegate>

- (instancetype)initWithSuperView:(UINavigationController *)nav
                      andEditBtnX:(CGFloat )editX
                        calendarX:(CGFloat )calendarX;

/**
 *  编辑过程中传递text
 */
@property (nonatomic ,copy)void (^searchBarText)(NSString *text);

/**
 *  开始编辑
 */
@property (nonatomic ,copy)void (^beginSearch)();


/**
 *  结束编辑
 */
@property (nonatomic ,copy)void (^endSearch)(NSString *text);

@property (nonatomic ,assign)BOOL tbVC;





- (void)changeSearchBar:(CGRect )rect;


@end
