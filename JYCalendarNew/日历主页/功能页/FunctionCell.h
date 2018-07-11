//
//  FunctionCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)setIcon:(UIImage *)image title:(NSString *)title;
@end
