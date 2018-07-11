//
//  WeatherCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellNormalHeight (IS_BIG_THAN_IPHONE_6_SCREEN?90:(IS_SMALL_THAN_IPHONE_6_SCREEN?70.f:80.f))/ 1334.0 * kScreenHeight

@interface WeatherCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *topLineView;//上分割线
@property (nonatomic,strong) UIView *leftLineView;//左分割线
@property (nonatomic,strong) UIView *rightLineView;//右分割线
@property (nonatomic,strong) UILabel *aqiLabel;
@property (nonatomic,strong) UILabel *descLabel;


@end
