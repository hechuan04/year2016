//
//  PasswordCell.h
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic ,strong)UIImageView *trigonometryImage;
@property (strong, nonatomic)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *numberLabel;
@property (nonatomic ,strong)UIImageView *addImg;
@property (nonatomic ,strong)UIButton *editNamebTN;

@property (nonatomic ,strong)UIImageView *selectImage;


@property (nonatomic ,strong)UITextField *titleField;
@property (nonatomic ,copy)void (^beginEditBlock)(UITextField *textField,CGRect rect,PasswordCell *cell);
@property (nonatomic ,copy)void (^finishEditBlock)(UITextField *textField,PasswordCell *cell);


@property (nonatomic ,assign)BOOL select;
- (void)selectCell:(BOOL)isSelect;

- (void)changeLabelWidth;
- (void)normalWidth;

- (void)hiddenLast;
- (void)appearAll;
- (void)createAddBtn;

- (void)removeAddImage;

//是否编辑状态
- (void)editType:(BOOL)isEdit;

@end
