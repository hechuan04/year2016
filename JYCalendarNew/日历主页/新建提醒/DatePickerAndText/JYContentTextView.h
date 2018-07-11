//
//  JYContentTextView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/28.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangeFrame)(BOOL isEditOk);

//typedef void(^GetTextViewContentSize)(CGSize size);


@interface JYContentTextView : UITextView<UITextViewDelegate>

@property (nonatomic ,copy)ChangeFrame changeFrame;

//@property (nonatomic ,copy)GetTextViewContentSize getContentsize;


@end
