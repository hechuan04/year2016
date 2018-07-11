//
//  SecretView.h
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
#define textFieldColor [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:217 / 255.0  alpha:1]
typedef NS_ENUM(NSInteger ,in_type) {
    
    firstIn = 1000,
    changeIn ,
    everyIn,
    
};

@interface SecretView : UIView<UITextFieldDelegate>

@property (nonatomic ,strong)UITextField *textField1;
@property (nonatomic ,strong)UITextField *textField2;
@property (nonatomic ,strong)UITextField *textField3;

@property (nonatomic ,copy)void (^confirmBlock)();
@property (nonatomic ,copy)void (^backSecretBlock)();
@property (nonatomic ,copy)void (^cancelBtn)(BOOL isDismiss);

//创建不同alert
- (void)createAlert:(UIColor *)selectColor;

//md5加密
- (NSString *) md5:(NSString *) input;


- (UILabel *)_titleLabel:(CGFloat )bottom
             selectColor:(UIColor *)selectColor
                    text:(NSString *)text;

- (UIView *)_lineView:(UILabel *)titleLabel
          selectColor:(UIColor *)selectColor;


- (void)_backBtnWithType:(NSInteger )type;

@end
