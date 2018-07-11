//
//  JYRemindViewController+UIForRemind.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindViewController.h"
#import "CamerManager.h"
#import "VPImageCropperViewController.h"

@interface JYRemindViewController (UIForRemind)<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,rememberTBDelegate>

- (void)setUI;



@end
