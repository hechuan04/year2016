//
//  AddNoteViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleLengthLimit 18
#define kImageViewBaseTag 1000

@class JYNote;
@interface AddNoteViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (nonatomic,strong) UIView *lineView;
//@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UILabel *placeholderLabel;
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,strong) UIButton *cameraButton;

@property (nonatomic,strong) UIView *imageContainerView;

@property (nonatomic,copy) NSString *imageStoragePath;
@property (nonatomic,strong) JYNote *note;
@property (nonatomic,readonly) BOOL contentHasChanged;

- (void)textViewDidChange:(UITextView *)textView;
- (void)layoutImageViews;

- (void)pop;

- (void)deleteImage:(UIButton *)sender;
@end
