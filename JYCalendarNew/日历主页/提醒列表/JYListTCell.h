//
//  JYListTCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupAvatarView.h"

@interface JYListTCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic ,copy)void (^clickBlock)(JYListTCell *cell);//点击cell
@property (nonatomic ,copy)void (^deleteBlock)(JYListTCell *cell); //删除
@property (nonatomic ,copy)void (^collectionBlock)(JYListTCell *cell); //收藏

@property (nonatomic ,strong)UIScrollView *scrollView; //滚动视图

@property (nonatomic ,strong)UIImageView *headImage; //普通头像
@property (nonatomic ,strong)HeadView *shareHeadImage; //分享的拼接头像
@property (nonatomic ,strong)GroupAvatarView *avatarView;


@property (nonatomic ,assign)int page;

@property (nonatomic ,strong) UIView  *bgView ;  //背景

@property (strong, nonatomic) UILabel *createTime;//创建时间
@property (strong, nonatomic) UILabel *dayLabel;  //单日
@property (strong, nonatomic) UILabel *weekLabel; //星期
@property (strong, nonatomic) UIImageView *clock; //闹钟图标
@property (strong, nonatomic) UIImageView *otherClock;//他人发送图标
@property (strong, nonatomic) UILabel *nameLabel; //发送人姓名
@property (strong, nonatomic) UILabel *titleLabel; //内容
@property (strong, nonatomic) UIImageView *pointImage; //未查看的红点

@property (strong, nonatomic) UIButton *collcetionBtn; //收藏按钮
@property (strong, nonatomic) UIButton *deleteBtn;     //删除按钮

@property (nonatomic ,strong)UIImageView *selectTypeImage; //是否选中状态

@property (nonatomic ,assign)BOOL isScroll;  //左划状态判断


/**
 *  创建分享他人头像
 */
- (void )createShareHeadView:(RemindModel *)model;

@end
