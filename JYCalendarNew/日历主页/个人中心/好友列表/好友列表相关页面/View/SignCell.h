//
//  SignCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignCell : UITableViewCell

@property (nonatomic,strong) UILabel *signDescLabel;
@property (nonatomic,strong) UILabel *signContentLabel;

+ (CGFloat)heightForSign:(NSString *)sign;
@end
