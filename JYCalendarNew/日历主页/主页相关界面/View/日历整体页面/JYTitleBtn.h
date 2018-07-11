//
//  JYTitleBtn.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/4/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTitleBtn : UIView
- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title;

@property (nonatomic ,strong)UILabel *calendarTitle;
@property (nonatomic ,copy)void (^selectCalendarBlock)();

@end
