//
//  GroupNameVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/5.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupNameVC : UIViewController<UITextFieldDelegate>

@property (nonatomic ,strong)NSString *strForGroupName;

@property (nonatomic ,copy)void (^actionForPopGroupName)(NSString *groupName);

@end
