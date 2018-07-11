//
//  ActivityCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *activityLabel;

- (void)setTitle:(NSString *)title;

@end
