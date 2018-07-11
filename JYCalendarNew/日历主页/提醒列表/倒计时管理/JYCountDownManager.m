//
//  JYCountDownManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCountDownManager.h"
#import "JYTimerManager.h"

@implementation JYCountDownManager
{
    NSInteger zongchazhi;
    JYTimerManager *timerManager;
}

- (id)init
{
    if (self = [super init]) {
        timerManager = [JYTimerManager manager];
        
    }
    
    return self;
}

- (NSMutableAttributedString *)beginTimerWithModel:(RemindModel *)model
{
    
    NSInteger hour = [[Tool actionforNowHour]integerValue];
    NSInteger minute = [[Tool actionforNowMinute]integerValue];
    
    NSInteger zong = hour * 60 * 60 + minute * 60;
    
    
        
    NSInteger selectZong = model.hour * 60 * 60 + model.minute * 60;
    NSInteger chahzi = selectZong - zong;
    
    //精确到秒
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"ss"];
    
    //剩余秒数，精确到系统秒数,已经走过的秒数
    NSInteger cha_second = [[dateFor stringFromDate:nowDate]integerValue];

    //总秒数 - 已经走过的秒数
   zongchazhi = chahzi - cha_second;
    
   NSMutableAttributedString *str = [self attributedString];
    
    
    NSTimer *_timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    //添加到管理者
    [timerManager.timerArr addObject:_timer];
    
    return  str;
}


- (void )timeAction:(NSTimer *)timer
{
    zongchazhi --;
    NSInteger cha_hour     = zongchazhi / 60 / 60 ;  //剩余小时
    NSInteger cha_minute   = (zongchazhi / 60) % 60; //剩余分钟
    NSInteger cha_second   =  zongchazhi - (cha_hour * 60 * 60 + cha_minute * 60);

   
    NSString *timeStr ;
    if (cha_hour > 0) {
        
        timeStr = [NSString stringWithFormat:@"还有%02ld小时%02ld分钟",cha_hour,cha_minute];
        
    }else if(cha_minute > 0){
       
        timeStr = [NSString stringWithFormat:@"还有%02ld分钟%02ld秒",cha_minute,cha_second];
        
    }else{
       
        timeStr = [NSString stringWithFormat:@"还有%02ld秒",zongchazhi];
    }
    
    if (cha_second <= 0 && cha_hour <= 0 && cha_minute <= 0) {
        
        [timer invalidate];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
    }
    
    //倒计时时间
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, timeStr.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(150, 150, 150)} range:NSMakeRange(0, timeStr.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(215, 119, 128)} range:NSMakeRange(2, 2)];
    
    cha_hour>0 || cha_minute >0 ? [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(215, 119, 128)} range:NSMakeRange(6, 2)] : nil;
    
    _cellLabel.attributedText = attStr;
    _attStr = attStr;
   // NSLog(@"剩余小时:%02ld   剩余分钟:%02ld  剩余秒数:%02ld",cha_hour,cha_minute,cha_second);
    
}

- (NSMutableAttributedString *)attributedString
{
    NSInteger cha_hour     = zongchazhi / 60 / 60 ; //剩余小时
    NSInteger cha_minute   = (zongchazhi / 60) % 60;       //剩余分钟
   
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"ss"];
    
    //剩余秒数，精确到系统秒数
    NSInteger cha_second = 60 - [[dateFor stringFromDate:nowDate]integerValue];
    
    
    NSString *timeStr ;
    if (cha_hour > 0) {
        
        timeStr = [NSString stringWithFormat:@"还有%02ld小时%02ld分钟",cha_hour,cha_minute];
        
    }else if(cha_minute > 0){
        
        timeStr = [NSString stringWithFormat:@"还有%02ld分钟%02ld秒",cha_minute,cha_second];
        
    }else{
        
        timeStr = [NSString stringWithFormat:@"还有%02ld秒",zongchazhi];
    }
    

    
    //倒计时时间
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, timeStr.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(150, 150, 150)} range:NSMakeRange(0, timeStr.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(215, 119, 128)} range:NSMakeRange(2, 2)];
    
    cha_hour>0 || cha_minute >0 ? [attStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(215, 119, 128)} range:NSMakeRange(6, 2)] : nil;
   
    return attStr;
}

@end
