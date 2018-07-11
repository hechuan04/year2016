//
//  JYContentTexgFiled.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeFrame)(BOOL isEditOk);

@interface JYContentTexgFiled : UITextField<UITextFieldDelegate>

@property (nonatomic ,copy)ChangeFrame changeFrame;

@end
