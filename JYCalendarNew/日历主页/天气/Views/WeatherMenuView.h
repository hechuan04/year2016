//
//  WeatherMenuView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/20.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuRowHeight 45.f

@interface WeatherMenuViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;

@end

@interface WeatherMenuView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *menuNames; //of NSString

@property (nonatomic,copy) void (^selectRowBlock)(NSInteger selectedRow);
@end
