//
//  UploadSuccessView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/9/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadSuccessView : UIView

@property (nonatomic,strong) UIImageView *imgView;

+ (instancetype)sharedInstance;

+ (void)showSuccessView;
+ (void)dismiss;

@end
