//
//  FestivalDetailViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/8.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FestivalType){
    FestivalTypeNormal = 1,
    FestivalTypeFoLi = 2
};

@interface FestivalDetailViewController : UIViewController

- (instancetype)initWithFestivalType:(FestivalType)type name:(NSString *)name;

@end
