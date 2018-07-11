//
//  EditPassWordTitleView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/7/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPassWordTitleView : UIView

@property (nonatomic ,copy)NSString *text;

@property (nonatomic ,copy)void (^cancelBlock)();
@property (nonatomic ,copy)void (^confirmBlock)(NSString *text);
@property (nonatomic ,strong)UITextField *textField;

@property (nonatomic ,strong)UIButton *confirm;

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
                      content:(NSString *)content;

@end
