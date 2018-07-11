//
//  BaseCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#define  kBaseCellHeight 75.f
@interface BaseCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *weekLabel;
@property (strong, nonatomic) UILabel *dayLabel;


@property (strong, nonatomic) UIButton *collcetionBtn;
@property (strong, nonatomic) UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIImageView *headImage;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *clock;

@property (strong, nonatomic) UIImageView *pointImage;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIImageView *otherClock;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *createTime;
@property (nonatomic ,strong)HeadView *headView;

@property (nonatomic ,strong)UIImageView *trigonometryImage;
@property (nonatomic ,assign)BOOL isEdit;

//删除，添加，点击
@property (nonatomic ,copy)void (^deleteAction)(BaseCell *cell);
@property (nonatomic ,copy)void (^collectionAction)(BaseCell *cell);
@property (nonatomic ,copy)void (^tapAction)(BaseCell *cell);

@property (nonatomic ,strong)UITapGestureRecognizer *tap;
@property (nonatomic ,strong)RemindModel *model;

- (void)hiddenAll;
- (void)appearAll;
- (void)hiddenTrigonometryImage;
- (void)appearTrigonmetryImage;

//分享头像方法
- (NSArray *)loadHeadWithModel:(RemindModel *)model;
@property (nonatomic ,strong)NSArray *arrForHead;

@end
