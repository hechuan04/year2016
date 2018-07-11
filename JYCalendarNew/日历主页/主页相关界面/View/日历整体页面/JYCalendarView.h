//
//  JYCalendarView.h
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCalendarView : UIView


- (instancetype)initWithFrame:(CGRect)frame
                  arrForLabel:(NSArray *)arrForText
                    andBtnTag:(NSInteger )tagForBtn
                       isShow:(BOOL )isShow;


@property (nonatomic ,strong)NSMutableArray  *arrForLabel;

@property (nonatomic ,copy)void (^actionForSendDay)(int lineType);
@property (nonatomic ,copy)void (^actionForReloadData)(NSString *str);
@property (nonatomic ,copy)void (^actionForChangeDay)(int year ,int month ,int day,NSArray *arrForPoint,int senderTag);
@property (nonatomic ,strong)JYSelectManager *manager;
@property (nonatomic ,strong)JYSkinManager   *skinManage;

@property (nonatomic ,strong)NSMutableArray *arrForXiuOrWork;

@property (nonatomic ,assign)BOOL isTop;//是否是顶部scroll

/**
 *  改变label的text
 */
- (void)changeLabelText:(NSArray *)arrForText
                 isShow:(BOOL )isShow
                withTag:(int )tag;

/**
 *  点击label的方法
 */
- (void)actionForSelectCalendar:(UIButton *)sender
                 isNotBtnSelect:(BOOL )isNotBtn
                isChangeTopView:(BOOL )isChange;

/**
 *  选中以后刷新是否有点
 */
- (void)reloadDataForChangePoint:(NSArray *)arrForText;

/**
 *  只为JYScrollViewForUp里的子类共用
 */
- (void)reloadDataForChangePoint:(NSArray *)arrForText
                      andTrueTag:(int )tag;

@end
