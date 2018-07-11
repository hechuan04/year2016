//
//  DetailCell.h
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic ,strong)PassWordModel *model;

@property (nonatomic ,strong)UITextField       *title;
@property (nonatomic ,strong)UITextField       *userName;
@property (nonatomic ,strong)UITextField       *passWord;
@property (nonatomic ,strong)UITextView       *detail;
@property (nonatomic ,strong)UILabel       *createTime;
@property (nonatomic ,assign)CGFloat       widthForText;
@property (nonatomic ,assign)int    numberLine;

@property (nonatomic ,copy)void (^reloadModel)(DetailCell *cell ,PassWordModel *model);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(PassWordModel *)model;

- (void)upDataTextViewFrame:(CGFloat )height;

@end
