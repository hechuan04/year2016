//
//  JYCountDownManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYCountDownManager : NSObject




@property (nonatomic ,strong)UILabel *cellLabel;
@property (nonatomic ,strong)NSMutableAttributedString *attStr;

//开始倒计时
- (NSMutableAttributedString *)beginTimerWithModel:(RemindModel *)model;



@end
