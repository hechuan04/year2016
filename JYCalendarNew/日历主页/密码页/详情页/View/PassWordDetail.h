//
//  PassWordDetail.h
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PassWordDetail : UIView<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic ,strong)PassWordModel *model;

@property (nonatomic ,strong)UITextField       *title;
@property (nonatomic ,strong)UITextField       *userName;
@property (nonatomic ,strong)UITextField       *passWord;
@property (nonatomic ,strong)UITextView       *detail;
@property (nonatomic ,strong)UILabel       *createTime;
@property (nonatomic ,strong)UIButton      *deleteBtn;
@property (nonatomic ,strong)UIButton   *confirmBtn;

@property (nonatomic ,assign)int    numberLine;
@property (nonatomic ,assign)CGFloat nextHeight;
@property (nonatomic ,assign)int index;

- (instancetype)initWithFrame:(CGRect)frame
                        model:(PassWordModel *)pasModel
                        index:(int )index;
#pragma mark - textView
//textView开始编辑
@property (nonatomic ,copy)void (^selectTextViewBlock)(UITextView *textView,int index);

@property (nonatomic ,copy)void (^changeFrameBlock)(int index,CGFloat height,CGFloat textHeight);

@property (nonatomic ,copy)void (^reloadFrameBlock)();


#pragma mark - textField
//textField开始编辑
@property (nonatomic ,copy)void (^selectTextFieldBlock)(UITextField *textField,int index);


#pragma mark - passModel
@property (nonatomic ,copy)void (^endEditBlock)(PassWordModel *model,int index);

@property (nonatomic ,copy)void (^deleteModel)(PassWordModel *model ,int index ,PassWordDetail *detailV);

@property (nonatomic ,copy)void (^saveModel)(PassWordModel *model ,int index,PassWordDetail *detailV);

- (void)upAction;

@end
