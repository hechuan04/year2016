//
//  JYAboutSecret.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/27.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAboutSecret : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *JYTextView;
@property (weak, nonatomic) IBOutlet UIButton *SelectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIButton *selected2Btn;
@property (weak, nonatomic) IBOutlet UIButton *selected3Btn;
@property (strong, nonatomic) IBOutlet UILabel *placeHolder;

@end