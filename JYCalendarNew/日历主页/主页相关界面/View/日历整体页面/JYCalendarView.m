//
//  JYCalendarView.m
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYCalendarView.h"
#import "HolidayManager.h"

@implementation JYCalendarView {
  
    int  _width;
    NSInteger _tagForLabel;
    NSMutableArray  *_arrForLabel;
    NSMutableArray  *_arrForPoint;
    NSMutableArray  *_arrForBtn;
    NSInteger _tagForBefoerLabel;

}

- (instancetype)initWithFrame:(CGRect)frame
                  arrForLabel:(NSArray *)arrForText
                    andBtnTag:(NSInteger )tagForBtn
                       isShow:(BOOL)isShow {
  
    if (self = [super initWithFrame:frame]) {
        
        _arrForLabel = [NSMutableArray array];
        _arrForPoint = [NSMutableArray array];
        _arrForBtn = [NSMutableArray array];
        _arrForXiuOrWork = [NSMutableArray array];
        
        _width = kScreenWidth / 7;  //int类型，否则不圆问题
        _manager = [JYSelectManager shareSelectManager];
        _skinManage = [JYSkinManager shareSkinManager];
        _tagForLabel = tagForBtn;
        [self createLabelWithArr:arrForText btnTag:tagForBtn isShow:isShow];
        
    }

    return self;
    
}
- (void)dealloc
{
    NSLog(@"JYCalendarView == dealloc");
    [_arrForBtn removeAllObjects];
    [_arrForLabel removeAllObjects];
    [_arrForPoint removeAllObjects];
    [_arrForXiuOrWork removeAllObjects];
}
- (void)createLabelWithArr:(NSArray *)arrForText
                    btnTag:(NSInteger )tagForBtn
                    isShow:(BOOL )isShow {

    for (int i = 0; i < 7; i ++) {
        
        int xForLabel = _width *i +4.5;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xForLabel + 3, 4.5, _width - 9 , _width - 9 )];
        //label.backgroundColor = [UIColor whiteColor];
        label.attributedText  = arrForText[i];
        label.tag = tagForBtn + i;
        label.numberOfLines = 0;
        label.layer.masksToBounds = NO;
        label.layer.allowsEdgeAntialiasing = true;
        
        label.layer.cornerRadius = label.bounds.size.width / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        
        
        [_arrForLabel addObject:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _width, _width - 3)];
        btn.tag = tagForBtn + i;
        [btn addTarget:self action:@selector(actionForSelectCalendar:isNotBtnSelect:isChangeTopView:) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:btn];
        
        [_arrForBtn addObject:btn];
        
        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake( xForLabel + _width / 2.0 - 3, label.bottom , 2.5, 2.5)];
        pointView.backgroundColor = _skinManage.colorForDateBg;
        pointView.hidden = YES;
        [self addSubview:pointView];
        

        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1.75, 1.75, 2.5, 2.5)];
//        imageView.backgroundColor = _skinManage.colorForDateBg;
//        imageView.tag = 1000 + i;
//        [pointView addSubview:imageView];
        
        [_arrForPoint addObject:pointView];
        
        //只有当前显示的需要展示Point
        
        if (isShow) {
            
            DataArray *dataArr = [DataArray shareDateArray];
            
            int year = [[_manager.dicForAllYear objectForKey:@(label.tag)]intValue];
            int month = [[_manager.dicForAllMonth objectForKey:@(label.tag)]intValue];
            int day = [[_manager.dicForAllDay objectForKey:@(label.tag)]intValue];
            
            for (int i = 0; i < dataArr.arrForAllData.count; i ++) {
                
                RemindModel *model =  dataArr.arrForAllData[i];
                
                if (model.isShare == 1) {
                    continue;
                }
                
                //重复情况下判断是否是当天
                BOOL isNowDay = NO;
                
                if (model.randomType != 0) {
                    isNowDay = [Tool actionForJudgementAndNotNotification:model year:year month:month day:day];
                }
                
                //没有选中重复的情况，是否超过提醒时间,且是否与选中天数相等
                BOOL isNotReapeat = NO;
                if (model.randomType == 0 && model.year == year && model.month == month && model.day == day) {
        
                    isNotReapeat = YES;
                    
                }
                
                //判断是否需要增加显示的cell
                if (isNotReapeat || isNowDay){
                    
                    pointView.hidden = NO;
                    break;
                    
                }
                
            }
            
        }
        
    }
    
}

//********************************点击传值方法******************************//

- (void)actionForSelectCalendar:(UIButton *)sender
                 isNotBtnSelect:(BOOL )isNotBtn
                isChangeTopView:(BOOL )isChange//判断非点击调用
{

    JYSkinManager *skingManager = [JYSkinManager shareSkinManager];
    
    //判断是否是Btn调用的，btn调用的传入空值为一个很大的数值
    NSString *str = [NSString stringWithFormat:@"%d",isChange];

    //不是刷新才更改之前的label,否则会出现之前的更改留在刷新后的页面
    if (!_manager.isLoad) {
        
        //上个label需要更改text,刷新的时候更改会出错，所以判断一下
        _manager.labelForBefore.attributedText = _manager.strForBeforeLabel;
    }
    
    _manager.labelForBefore.backgroundColor = [UIColor clearColor];
    _manager.labelForBefore.layer.masksToBounds = NO;

    
    UILabel *label = (UILabel *)[self viewWithTag:sender.tag];
    label.backgroundColor = skingManager.colorForDateBg;
    
    //之前的日期
    NSString *strForBLabel = [NSString stringWithFormat:@"%@",_manager.labelForBefore.text];
    NSArray *arrForBDay = [strForBLabel componentsSeparatedByString:@"\n"];
    int beforeDay = [arrForBDay[0] intValue];
    
    
    //存储给之前的Label用
    _manager.labelForBefore = label;
    _manager.strForBeforeLabel = label.attributedText;
  
    
    //改变选中时间的日期
    NSString *strForLabel = [NSString stringWithFormat:@"%@",label.text];
    NSArray *arrForDay = [strForLabel componentsSeparatedByString:@"\n"];
    [_manager actionForChangeSingleDay:[arrForDay[0] intValue]];
   
    //佛祖节日显示不下的情况
    NSString *holiday = arrForDay[1];
    if (holiday.length >= 4) {
     
        
        holiday = [holiday substringWithRange:NSMakeRange(0, 3)];
        NSMutableAttributedString *strForSolorDay = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",arrForDay[0]]];
        [strForSolorDay addAttribute:NSFontAttributeName value:_manager.fontForSolar range:NSMakeRange(0, strForSolorDay.length)];
        
        NSMutableAttributedString *foDayHoliday = [JYToolForCalendar attributedString:holiday font:_manager.fontForLunar color:skingManager.colorForNormalHoliday alpha:1];
        
        [strForSolorDay appendAttributedString:foDayHoliday];
        label.attributedText = strForSolorDay;

        
    }
    
    
    
    
    label.textColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    
    
    //在这里加判断，避免一直调用数据库造成卡顿
    //4s在这里显示有问题,bool赋值正好相反
    if (IS_IPHONE_4_SCREEN) {
        isChange = !isChange;
        isNotBtn = !isNotBtn;
    }
  
    
    if ([str isEqualToString:@"1"]) {
        
        return;
    }
    
    //if (!isNotBtn) {
        
        //传递选中的label tag,通过tag判断类型
        _actionForSendDay((int )sender.tag);

    //}
    
    NSLog(@"%ld",sender.tag);
    if (_manager.g_changeDay != 0) {
        
        _manager.g_changeMonth = [_manager.dicForAllMonth[@(sender.tag)] intValue];
        _manager.g_changeYear = [_manager.dicForAllYear[@(sender.tag)] intValue];
 
        if (_isTop) {
            
            int isChangeMonth = abs(_manager.g_changeDay - beforeDay);
            
            if (isChangeMonth > 15) {
                
                if (_manager.g_changeDay > beforeDay) {
                    
                    _manager.g_changeMonth--;
                    
                }else{
                    
                    _manager.g_changeMonth++;
                }
                
            }
        }
        
        //传递时间
        _actionForChangeDay(_manager.g_changeYear,_manager.g_changeMonth,_manager.g_changeDay,_arrForPoint,(int )sender.tag);
        
    }
    
    _manager.isLoad = NO;
    
}



- (void)reloadDataForChangePoint:(NSArray *)arrForText {
    
    for (int i = 0; i < _arrForLabel.count; i++) {
        
        UILabel *label = _arrForLabel[i];
    
        UIView *point = _arrForPoint[i];
        point.hidden = YES;
        
        UIImageView *imageV = [point viewWithTag:1000 + i];
        imageV.backgroundColor = _skinManage.colorForDateBg;

        //只有当前显示的需要展示Point
   
            DataArray *dataArr = [DataArray shareDateArray];
            
            int year = [[_manager.dicForAllYear objectForKey:@(label.tag)]intValue];
            int month = [[_manager.dicForAllMonth objectForKey:@(label.tag)]intValue];
            int day = [[_manager.dicForAllDay objectForKey:@(label.tag)]intValue];
            
            for (int i = 0; i < dataArr.arrForAllData.count; i ++) {
                
                RemindModel *model =  dataArr.arrForAllData[i];
            
                if (model.isShare == 1) {
                    continue;
                }
                
                //重复情况下判断是否是当天
                BOOL isNowDay = NO;
                
                if (model.randomType != 0) {
         
                    isNowDay = [Tool actionForJudgementAndNotNotification:model year:year month:month day:day];
             
                }
                
                //没有选中重复的情况，是否超过提醒时间,且是否与选中天数相等
                BOOL isNotReapeat = NO;
                
                
                if (model.randomType == 0 && model.year == year && model.month == month && model.day == day) {
                    
                    //在没有重复的情况下判断是否超过当天时间
      
                    isNotReapeat = YES;
                    
                }
                
                //判断是否需要增加显示的cell
                if (isNotReapeat || isNowDay){
                    point.backgroundColor = _skinManage.colorForDateBg;
                    if (month != _manager.nowMonth) {
                        point.alpha = 0.1;
                    }else{
                        point.alpha = 1;
                    }
                    point.hidden = NO;
                    break;
                    
                }
        }
    }
    
}

- (void)reloadDataForChangePoint:(NSArray *)arrForText
                      andTrueTag:(int )tag {
    
    for (int i = 0; i < _arrForLabel.count; i++) {
        
        int trueTag = tag + i;
        
        UIView *point = _arrForPoint[i];
        point.hidden = YES;
        UIImageView *imageV = [point viewWithTag:1000 + i];
        imageV.backgroundColor = _skinManage.colorForDateBg;
        
        //只有当前显示的需要展示Point
        DataArray *dataArr = [DataArray shareDateArray];
        
        int year = [[_manager.dicForAllYear objectForKey:@(trueTag)]intValue];
        int month = [[_manager.dicForAllMonth objectForKey:@(trueTag)]intValue];
        int day = [[_manager.dicForAllDay objectForKey:@(trueTag)]intValue];
        
        for (int i = 0; i < dataArr.arrForAllData.count; i ++) {
            
            RemindModel *model =  dataArr.arrForAllData[i];
            
            if (model.isShare == 1) {
                continue;
            }
            
            //重复情况下判断是否是当天
            BOOL isNowDay = NO;
            
            if (model.randomType != 0) {
                
                isNowDay = [Tool actionForJudgementAndNotNotification:model year:year month:month day:day];
                
            }
            
            //没有选中重复的情况，是否超过提醒时间,且是否与选中天数相等
            BOOL isNotReapeat = NO;
            
            
            if (model.randomType == 0 && model.year == year && model.month == month && model.day == day) {
                
                //在没有重复的情况下判断是否超过当天时间
                
                isNotReapeat = YES;
                
            }
            
            //判断是否需要增加显示的cell
            if (isNotReapeat || isNowDay){
                
                point.backgroundColor = _skinManage.colorForDateBg;
                if (month != _manager.nowMonth) {
                    point.alpha = 0.1;
                }else{
                    point.alpha = 1;
                }
                point.hidden = NO;
                break;
                
            }
            
        }
        
    }
    
}


- (void)changeLabelText:(NSArray *)arrForText
                 isShow:(BOOL )isShow
                withTag:(int )tag{

    for (int i = 0; i < _arrForXiuOrWork.count; i++) {
        
        UIImageView *imageV = _arrForXiuOrWork[i];
        [imageV removeFromSuperview];
    }
    
    [_arrForXiuOrWork removeAllObjects];
    for (int i = 0; i < _arrForLabel.count; i++) {
        
        UILabel *label = _arrForLabel[i];
        label.attributedText = arrForText[i];
     
        //只有当前显示的页需要
        if (isShow) {
            
            HolidayManager *manager = [HolidayManager shareManager];
            NSMutableAttributedString *str = arrForText[i];
            
            NSString *str1 = [str string];
            NSArray *nowDayArr = [str1 componentsSeparatedByString:@"\n"];
            int nowDAY = [nowDayArr[0] intValue];
            int monthNow = [_manager.dicForAllMonth[@(tag + i)] intValue];
            
            NSString *dayAndMonth = [NSString stringWithFormat:@"%02d%02d",monthNow,nowDAY];
            NSInteger dayType = [manager isWork:dayAndMonth year:[_manager.dicForAllYear[@(tag + i)]intValue]];
    
            if (dayType != 0) {
                dayType == 100 ? [self actionForAddXiuImage:i andMonth:monthNow] : [self actionForAddWorkImage:i andMonth:monthNow];
            }
        }
    }
}

- (void)actionForAddXiuImage:(int )i_X andMonth:(int )month
{
    UIImageView *xiuImage = [[UIImageView alloc] initWithFrame:CGRectMake(_width * i_X + _width - 14, 2, 14, 14)];
    
    if (month == _manager.nowMonth) {
        xiuImage.image = [UIImage imageNamed:@"休.png"];
    }else{
        xiuImage.image = [UIImage imageNamed:@"浅色休.png"];
    }
    
    [self addSubview:xiuImage];
    [_arrForXiuOrWork addObject:xiuImage];
}

- (void)actionForAddWorkImage:(int )i_X andMonth:(int )month
{
    UIImageView *xiuImage = [[UIImageView alloc] initWithFrame:CGRectMake(_width * i_X + _width - 14, 2, 14, 14)];
    
    if (month == _manager.nowMonth) {
        xiuImage.image = [UIImage imageNamed:@"班.png"];
    }else{
        xiuImage.image = [UIImage imageNamed:@"浅色班.png"];
    }
    
    [self addSubview:xiuImage];
    [_arrForXiuOrWork addObject:xiuImage];
    
}

 
@end
