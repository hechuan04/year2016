//
//  JYMainViewController+ScrollView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController+ScrollView.h"
#import "JYMainViewController+UI.h"
#import "JYMainViewController+Action.h"
#import "JYCalendarModel.h"
@implementation JYMainViewController (ScrollView)

/**
 *  创建中间日历滑动视图
 */
- (void)createCalendarScrollView
{
    
   CGFloat width = kScreenWidth / 7.0;

 
    NSDictionary *dicForBefore  = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:YES];
    NSArray *arr2 = [JYToolForReturnAllArray actionForReturnArrayWithYear:[dicForBefore[@"year"] intValue] month:[dicForBefore[@"month"] intValue] day:[dicForBefore[@"day"] intValue] isNowArr:NO];
    
    NSDictionary *dicForNext = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:NO];
    NSArray *arr3 = [JYToolForReturnAllArray actionForReturnArrayWithYear:[dicForNext[@"year"] intValue] month:[dicForNext[@"month"] intValue] day:[dicForNext[@"day"] intValue] isNowArr:NO];
    
    
    NSArray *arr1 = [JYToolForReturnAllArray actionForReturnArrayWithYear:self.changeYear month:self.changeMonth   day:self.changeDay isNowArr:YES];
    
    //用于给隐藏的arr赋值
    self.changeArrForHidden = arr1;
    
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40)];
    //_bgScrollView.backgroundColor = [UIColor orangeColor];
    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    self.bgScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.bgScrollView.delegate = self;
    self.bgScrollView.decelerationRate = 2;
    [self.view addSubview:self.bgScrollView];
    
    self.bgScrollView.bounces = NO;
    
    //用于显示的
    self.scrollView = [[JYScrollViewForCalendar alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight) andTextArr:arr1 isShow:YES];
    //_scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.scrollView.contentSize = CGSizeMake(0, kScreenHeight + width * 6 + kHeightForWeek-1);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.scrDelegate = self;          //代理，用于隐藏topView
    [self.bgScrollView addSubview:self.scrollView];
    
    self.scrollView.bounces = NO;
    
    
    
    
    
    
    //加载数据的
    self.scrollView1 = [[JYScrollViewForCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) andTextArr:arr2 isShow:NO];
    self.scrollView1.userInteractionEnabled = NO;
    self.scrollView1.contentSize = CGSizeMake(0 ,0);
    [self.bgScrollView addSubview:self.scrollView1];
    
    
    
    self.scrollView2 = [[JYScrollViewForCalendar alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 40) andTextArr:arr3 isShow:NO];
    self.scrollView2.userInteractionEnabled = NO;
    self.scrollView2.directionalLockEnabled = YES;
    self.scrollView2.contentSize = CGSizeMake(0, 0);
    [self.bgScrollView addSubview:self.scrollView2];
    

}

/**
 *  日历点击回调block
 */
- (void)actionForCalendarBlock
{
 
    
    __weak JYMainViewController *_vc = self;
    //获取label的tag以及属性，确定怎么移动view
    [self.scrollView setActionForTag:^(int tag ,int type) {
        
        _vc.x_Collection = tag;
        
        switch (type) {
            case firstLine:
                
                _vc.calendarView = _vc.scrollView.calendar1;
                _vc.lineSign = firstLine;
                
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[0] isShow:YES withTag:100];
                
                _vc.selectTag = 100;
                break;
                
            case secondLine:
                
                _vc.calendarView = _vc.scrollView.calendar2;
                _vc.lineSign = secondLine;
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[1] isShow:YES withTag:200];
                
                _vc.selectTag = 200;
                break;
                
            case thirdLine:
                
                _vc.calendarView = _vc.scrollView.calendar3;
                _vc.lineSign = thirdLine;
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[2] isShow:YES withTag:300];
                
                _vc.selectTag = 300;
                break;
                
            case fourthLine:
                
                _vc.calendarView = _vc.scrollView.calendar4;
                _vc.lineSign = fourthLine;
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[3] isShow:YES withTag:400];
                
                _vc.selectTag = 400;
                break;
                
            case fifthLine:
                
                _vc.calendarView = _vc.scrollView.calendar5;
                _vc.lineSign = fifthLine;
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[4] isShow:YES withTag:500];
                
                _vc.selectTag = 500;
                break;
                
            case sixthLine:
                
                _vc.calendarView = _vc.scrollView.calendar6;
                _vc.lineSign = sixthLine;
                [_vc.scrollViewForUp.calendarView changeLabelText:_vc.changeArrForHidden[5] isShow:YES withTag:600];
                
                _vc.selectTag = 600;
                break;
                
            default:
                break;
        }

        
    }];
  
    //****************************按钮点击方法回调***************************//
    
    __weak JYSelectManager *manger = self.selectManager;
    [self.scrollView setActionForChangeDay:^(int year, int month , int day ,NSArray *arrForPoint ,int senderTag) {
        
        
        
        //用于判断是否隐藏点
        int index = senderTag / 100;
        int tag = index * 100;
        _vc.selectTag = tag;
        int nowIndex = senderTag - tag;
        int indexForCalendar = _vc.x_Collection / 100;  //在topView中选中，改变_x_collection的方法
        int selectTat = indexForCalendar * 100;
        
        _vc.x_Collection = selectTat + nowIndex;
        
        
        UIView *viewForPoint = nil;
        if (arrForPoint.count > 0 && nowIndex <= 6 && nowIndex >= 0) {
            
            viewForPoint = arrForPoint[nowIndex];
            
        }
        
        UIView *viewForBefore = manger.viewForPoint;
        viewForBefore.hidden = manger.isHiddenPoint;
        
        
        manger.viewForPoint = viewForPoint;
        manger.isHiddenPoint = viewForPoint.hidden;
        
        viewForPoint.hidden = YES;
        
        if (_vc.changeYear == year && _vc.changeMonth == month && _vc.changeDay == day) {
            
            return ;
        }
       
        _vc.jyWeatherView.calendarModel = [[JYCalendarModel alloc]initWithYear:year month:month day:day];
        
//        _vc.title = [NSString stringWithFormat:@"%d年%d月",year,month];
//        _vc.jyWeatherView.solarCalendar.text = [NSString stringWithFormat:@"%d",day];
//        
//        _vc.jyWeatherView.weekDay.text = [Tool actionForEnglishWeekWithYear:year month:month day:day];
//        _vc.jyWeatherView.lunarCalendar.text = [Tool actionForLunarWithYear:year month:month day:day];
//
//        _vc.jyWeatherView.holiDay.attributedText = [JYToolForCalendar actionForReturnTextWithYear:year month:month day:day weather:_vc.jyWeatherView];
//        _vc.jyWeatherView.holidayIcon.hidden = [self.jyWeatherView.holiDay.attributedText length]==0;
        
        if (year != _vc.selectManager.g_notChangeYear || month != _vc.selectManager.g_notChangeMonth || day != _vc.selectManager.g_notChangeDay) {
            
            _vc.btnForToday.alpha = 1;
            
        }else {
            
            _vc.btnForToday.alpha = 0;
        }
        
        
        BOOL isAwait = [_vc.jyRemindView.awaitTableView loadData:year month:month day:day isAwaysChange:NO];
        BOOL isOther = [_vc.jyRemindView.alreayTableView loadData:year month:month day:day isAwaysChange:NO];
        
        //用于跳转
        RemindModel *model = [[RemindModel alloc] init];
        model.year = year;
        model.month = month;
        model.day = day;
        
        if (_vc.isSelectPass) {
            
            if (isOther) {
                _vc.jyRemindView.btnForEdit.hidden = NO;
            }else{
                _vc.jyRemindView.btnForEdit.hidden = YES;
            }
            
        }else{
            
            if (isAwait) {
                _vc.jyRemindView.btnForEdit.hidden = NO;
            }else{
                _vc.jyRemindView.btnForEdit.hidden = YES;
            }
        }
        
        if (isAwait) {
            
            [_vc actionForHiddenNotRemindView:NO];
            
        }else if (isOther){
            
            
            [_vc actionForHiddenNotRemindView:NO];
            
        }else {
            
            [_vc actionForHiddenNotRemindView:YES];
        }
        
        //下个月
        if (year > _vc.changeYear || month > _vc.changeMonth) {
            
            
            //选中红点置为nil
            _vc.selectManager.viewForPoint = nil;
            _vc.selectManager.isHiddenPoint = NO;
            [_vc actionForTurnSelectViewWithModel:model isTop:NO];
            
        }else if (year < _vc.changeYear || month < _vc.changeMonth){
            
            //选中红点置为nil
            _vc.selectManager.viewForPoint = nil;
            _vc.selectManager.isHiddenPoint = NO;
            [_vc actionForTurnSelectViewWithModel:model isTop:NO];
            
        }
        
        _vc.changeDay = day;
        _vc.changeMonth = month;
        _vc.changeYear = year;
        
    }];
    
    
    //上下滑动一直调用的方法，确定是否显示UpScrollView
    __weak UIScrollView *scr = self.bgScrollView;
    [self.scrollView setHiddenForCollection:^(BOOL isHidden) {
        
        scr.scrollEnabled = isHidden;
        //_vc.isUp = !isHidden;
        
    }];

    
    //初始化当天数据
    [self actionForNowDay];
 
}


/**
 *  初始化当天的数据
 */
- (void)actionForNowDay
{

    //初始化当天数据
    self.x_Collection = self.selectManager.todayTag;
    
    if (self.selectManager.todayTag >=600) {
        
        self.calendarView = self.scrollView.calendar6;
        self.lineSign = sixthLine;
        self.scrollView.typeForLine = sixthLine;
        
        self.selectTag = 600;
        
    }else if (self.selectManager.todayTag < 600 && self.selectManager.todayTag >= 500){
        
        self.calendarView = self.scrollView.calendar5;
        self.lineSign = fifthLine;
        self.scrollView.typeForLine = fifthLine;
        
        
        self.selectTag = 500;
        
    }else if (self.selectManager.todayTag < 500 && self.selectManager.todayTag >= 400){
        
        
        self.calendarView = self.scrollView.calendar4;
        self.lineSign = fourthLine;
        self.scrollView.typeForLine = fourthLine;
        
        
        self.selectTag = 400;
        
    }else if (self.selectManager.todayTag < 400 && self.selectManager.todayTag >= 300){
        
        self.calendarView = self.scrollView.calendar3;
        self.lineSign = thirdLine;
        self.scrollView.typeForLine = thirdLine;
        
        self.selectTag = 300;
        
    }else if (self.selectManager.todayTag < 300 && self.selectManager.todayTag >= 200){
        
        self.calendarView = self.scrollView.calendar2;
        self.lineSign = secondLine;
        self.scrollView.typeForLine = secondLine;
        
        
        self.selectTag = 200;
        
    }else if (self.selectManager.todayTag < 200 && self.selectManager.todayTag >= 100){
        
        self.calendarView = self.scrollView.calendar1;
        self.lineSign = firstLine;
        self.scrollView.typeForLine = firstLine;
        
        
        self.selectTag = 100;
    }
 
}


/**
 *  初始化UPScrollView
 */
- (void)actionForUpScrollViewWithWidth:(CGFloat )width andArr:(NSArray *)arr1
{
    
    if (arr1 == nil) {
        
        arr1 = self.changeArrForHidden;

    }
    
    //上啦显示的
    self.scrollViewForUp = [[JYScrollViewForUp alloc] initWithFrame:CGRectMake(0,self.weekView.bottom , kScreenWidth, width ) andArr:arr1 andTag:(int )self.selectTag / 100 - 1];
    self.scrollViewForUp.contentSize = CGSizeMake(kScreenWidth * 3.0, 0);
    self.scrollViewForUp.contentOffset = CGPointMake(kScreenWidth, 0);
    self.scrollViewForUp.hidden = NO;
    self.scrollViewForUp.backgroundColor = [UIColor whiteColor];
    self.scrollViewForUp.scrollEnabled = NO;
    
    [self.view addSubview:self.scrollViewForUp];
    
    [self actionForUpCalendarBlockChangeData];
}


/**
 *  UpScrollView回调方法
 */
- (void)actionForUpCalendarBlock
{
    __weak JYMainViewController *_vc = self;
    __weak JYSelectManager *manger = self.selectManager;
    [self.scrollViewForUp setActionForChangeData:^(int year, int month , int day ,NSArray *arrForPoint ,int senderTag) {
 
        
        int index = senderTag / 100;
        int tag = index * 100;
        int nowIndex = senderTag - tag;
        
        int indexForCalendar = _vc.x_Collection / 100;  //在topView中选中，改变_x_collection的方法
        int selectTat = indexForCalendar * 100;
        
        _vc.x_Collection = selectTat + nowIndex;

        

        UIView *viewForPoint = nil;
        if (arrForPoint.count > 0 && nowIndex <= 6 && nowIndex >= 0) {
            
            viewForPoint = arrForPoint[nowIndex];
            
        }
        
        UIView *viewForBefore = manger.viewForPoint;
        viewForBefore.hidden = manger.isHiddenPoint;
        
        
        manger.viewForPoint = viewForPoint;
        manger.isHiddenPoint = viewForPoint.hidden;
        
        viewForPoint.hidden = YES;
        
        //避免上下滑动一直走以下方法
        if (_vc.changeYear == year && _vc.changeMonth == month && _vc.changeDay == day) {
            
            return ;
        }
        
        
        _vc.navigationItem.title = [NSString stringWithFormat:@"%d年%d月",year,month];
        _vc.jyWeatherView.calendarModel = [[JYCalendarModel alloc]initWithYear:year month:month day:day];

//        
//        _vc.jyWeatherView.holiDay.attributedText = [JYToolForCalendar actionForReturnTextWithYear:year month:month day:day weather:_vc.jyWeatherView];
//        _vc.self.jyWeatherView.holidayIcon.hidden = [self.jyWeatherView.holiDay.attributedText length]==0;
        
        [_vc.jyRemindView.awaitTableView loadData:year month:month day:day isAwaysChange:NO];
        [_vc.jyRemindView.alreayTableView loadData:year month:month day:day isAwaysChange:NO];

        
        if (year != _vc.selectManager.g_notChangeYear || month != _vc.selectManager.g_notChangeMonth || day != _vc.selectManager.g_notChangeDay) {
            
            _vc.btnForToday.alpha = 1;
            
        }else {
            
            _vc.btnForToday.alpha = 0;
        }
        
        
        
        BOOL isAwait = [_vc.jyRemindView.awaitTableView loadData:year month:month day:day isAwaysChange:NO];
        BOOL isOther = [_vc.jyRemindView.alreayTableView loadData:year month:month day:day isAwaysChange:NO];
        
        //用于跳转
        RemindModel *model = [[RemindModel alloc] init];
        model.year = year;
        model.month = month;
        model.day = day;
        
        if (isAwait) {
            
            [_vc actionForHiddenNotRemindView:NO];
            
        }else if (isOther){
            
            
            [_vc actionForHiddenNotRemindView:NO];
            
        }else {
            
            [_vc actionForHiddenNotRemindView:YES];
        }
        
        //下个月
        if (year > _vc.changeYear || month > _vc.changeMonth) {
            
            //选中红点置为nil
            _vc.selectManager.viewForPoint = nil;
            _vc.selectManager.isHiddenPoint = NO;
            [_vc actionForTurnSelectViewWithModel:model isTop:YES];
            
        }else if (year < _vc.changeYear || month < _vc.changeMonth){
            
            //选中红点置为nil
            _vc.selectManager.viewForPoint = nil;
            _vc.selectManager.isHiddenPoint = NO;
            [_vc actionForTurnSelectViewWithModel:model isTop:YES];
            
        }
        
        _vc.changeDay = day;
        _vc.changeMonth = month;
        _vc.changeYear = year;
        
        
    }];
    
}

- (void)actionForUpCalendarBlockChangeData
{
    //__weak JYMainViewController *_vc = self;
    [self.scrollViewForUp setActionForLoad:^(int tag) {
        
        //_vc.calendarView.actionForSendDay(tag - 300 + 100);
//        RemindModel *model = [[RemindModel alloc] init];
//        model.year = 2016;
//        model.month = 2;
//        model.day = 29;
//        [_vc actionForTurnSelectViewWithModel:model];
        NSLog(@"%d",tag);
    }];
    
}

#pragma mark scrollView代理方法

//*************************滚动调用方法，切换页面的关键方法**************//
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //NSLog(@"%lf",velocity.x);
    //向右翻，速度大于0.15
    if(scrollView==self.bgScrollView){
        
        if (velocity.x > 0.15) {
            
            self.changeMonth ++;
            //        self.changeDay = 1;
            if (self.changeMonth > 12) {
                
                self.changeMonth = 1;
                self.changeYear++;
            }
            JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:1];
            NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:model.date];
            if(self.changeDay>days.length){
                self.changeDay = (int)days.length;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                
                scrollView.contentOffset = CGPointMake(2 * kScreenWidth, 0);
                
            } completion:^(BOOL finished) {
                
                
                [self performSelector:@selector(_actionForChangeSubView) withObject:nil afterDelay:0];
                
            }];
            
            
            
            //向左翻，速度小于-0.15
        }else if (velocity.x < -0.15){
            
            self.changeMonth --;
            //        self.changeDay = 1;
            if (self.changeMonth <= 0) {
                
                self.changeMonth = 12;
                self.changeYear --;
            }
            JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:1];
            NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:model.date];
            if(self.changeDay>days.length){
                self.changeDay = (int)days.length;
            }
            
            
            
            [UIView animateWithDuration:0.25 animations:^{
                
                scrollView.contentOffset = CGPointMake(0, 0);
                
                
            } completion:^(BOOL finished) {
                
                [self performSelector:@selector(_actionForChangeSubView) withObject:nil afterDelay:0];
                
                
            }];
            
            //其他速度相当于拖拽，走下边方法
        }else{
            
            [self actionForChangeFrame:scrollView];
        }
    }
 
    
}


#pragma mark 拖拽结束调用的方法
- (void)actionForChangeFrame:(UIScrollView *)scrollView
{
    
    //用于确定界面正在滑动
    self.isSlip = NO;
    
    if (scrollView.contentOffset.x >= kScreenWidth + kScreenWidth / 2.0 ) {
        
        self.changeMonth ++;
//        self.changeDay = 1;
        if (self.changeMonth > 12) {
            
            self.changeMonth = 1;
            self.changeYear++;
        }
        JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:1];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:model.date];
        if(self.changeDay>days.length){
            self.changeDay = (int)days.length;
        }
        [scrollView setContentOffset:CGPointMake(2 * kScreenWidth, 0) animated:YES];
        
        //延迟调用赋值数据
        [self performSelector:@selector(_actionForChangeSubView) withObject:nil afterDelay:0.3];
        
        
    }else if(scrollView.contentOffset.x <= kScreenWidth / 2.0){
        
        self.changeMonth --;
//        self.changeDay = 1;
        if (self.changeMonth <= 0) {
            
            self.changeMonth = 12;
            self.changeYear --;
        }
        JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:1];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:model.date];
        if(self.changeDay>days.length){
            self.changeDay = (int)days.length;
        }
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //延迟调用赋值数据
        [self performSelector:@selector(_actionForChangeSubView) withObject:nil afterDelay:0.3];
        
        
        
    }else{
        
        //没有滑动过指定的位置，位置还原
        [scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        self.isSlip = YES;
        
    }
    
    
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self actionForChangeFrame:scrollView];
    //NSLog(@"222");
    
}

//延迟调用，当纯拖动的时候调用该方法
- (void)_actionForChangeSubView
{
    
    NSDate *date123 = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:self.changeYear month:self.changeMonth];
    NSInteger weekNow123  = [JYToolForCalendar actionForNowWeekUTC:date123];
    self.weekForSelectMonth = (int)weekNow123;
    
    //赋值给全局变量
    [self.selectManager actionForChangeDateWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
    
    //重新加载当前显示的日历
    NSArray *arr = [JYToolForReturnAllArray actionForReturnArrayWithYear:self.changeYear month:self.changeMonth day:self.changeDay isNowArr:YES];
    
    self.changeArrForHidden = arr;
    [self.scrollView changeLabelTextAll:arr isShow:YES];
    
    //从新判断是否显示红点
    [self.scrollView changeLabelTextReload:arr];
    self.selectManager.viewForPoint = nil;
    self.selectManager.isHiddenPoint = NO;
    
    [self changeFrameNextisZeroVelocity:NO];
    [self changeFrameBeforeisZeroVelocity:NO];
    //当左右滑动的时候，如果切换日历改变选中状态
    [self changeSelectView];
    self.bgScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

//整个滑动界面的时候，调用从新赋值方法
- (void)changeSelectView
{
    if (self.weekForSelectMonth == 1) {
        self.weekForSelectMonth = 6;
    }else{
        self.weekForSelectMonth -= 2;
    }
    
    int tmp = self.changeDay+self.weekForSelectMonth;
    int row = (int)ceilf((float)tmp/7);
    int col = (tmp%7)>0?(tmp%7-1):6;
    
    self.x_Collection = col + 100*row;
    
    switch (row) {
        case 1:{
            self.scrollView.typeForLine = firstLine;
            self.lineSign = firstLine;
            self.calendarView = self.scrollView.calendar1;
        }
            break;
        case 2:{
            self.scrollView.typeForLine = secondLine;
            self.lineSign = secondLine;
            self.calendarView = self.scrollView.calendar2;
        }
            break;
        case 3:{
            self.scrollView.typeForLine = thirdLine;
            self.lineSign = thirdLine;
            self.calendarView = self.scrollView.calendar3;
        }
            break;
        case 4:{
            self.scrollView.typeForLine = fourthLine;
            self.lineSign = fourthLine;
            self.calendarView = self.scrollView.calendar4;
        }
            break;
        case 5:{
            self.scrollView.typeForLine = fifthLine;
            self.lineSign = fifthLine;
            self.calendarView = self.scrollView.calendar5;
        }
            break;
        case 6:{
            self.scrollView.typeForLine = sixthLine;
            self.lineSign = sixthLine;
            self.calendarView = self.scrollView.calendar6;
        }
            break;
        default:
            break;
    }
    
   
    
    UIButton *btn = [UIButton new];
    btn.tag = self.x_Collection;
    self.selectManager.isLoad = YES;
    
    [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
    
    
    self.btnForTitle.calendarTitle.text = [NSString stringWithFormat:@"%d年%d月",self.changeYear,self.changeMonth];
    
    self.jyWeatherView.calendarModel = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
    
//    self.jyWeatherView.solarCalendar.text = [NSString stringWithFormat:@"%d",self.changeDay];
//
//    self.jyWeatherView.weekDay.text = [Tool actionForEnglishWeekWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
//    self.jyWeatherView.lunarCalendar.text = [Tool actionForLunarWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
    
    
    BOOL isAwait = [self.jyRemindView.awaitTableView loadData:self.changeYear month:self.changeMonth day:self.changeDay isAwaysChange:NO];
    BOOL isOther = [self.jyRemindView.alreayTableView loadData:self.changeYear month:self.changeMonth day:self.changeDay isAwaysChange:NO];
    
    
    
    if (isAwait) {
        
        [self actionForHiddenNotRemindView:NO];
        
    }else if (isOther){
        
        
        [self actionForHiddenNotRemindView:NO];
        
    }else {
        
        [self actionForHiddenNotRemindView:YES];
    }
    
    if (self.changeDay != self.notChangeDay || self.changeMonth != self.notChangeMonth || self.changeYear != self.notChangeYear) {
        
        self.btnForToday.alpha = 1;
        
    }else {
        
        self.btnForToday.alpha = 0;
    }
    
    //顶部scrollView可能出现显示问题
    //self.scrollViewForUp.calendarView.isTop = YES;
    //改变topView的显示内容
    

    
    
    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[0] isShow:YES withTag:100];
    
    //是否有红点显示
    [self.scrollViewForUp.calendarView reloadDataForChangePoint:self.changeArrForHidden[0]];
    
    
}

#pragma mark 提前加载前后页面数据
- (void)changeFrameNextisZeroVelocity:(BOOL)isZero
{
    int nextMonth = self.changeMonth;
    int nextYear = self.changeYear;
    nextMonth++;
    if (nextMonth > 12) {
        
        nextMonth = 1;
        nextYear ++;
    }
    NSArray *arrNext = [JYToolForReturnAllArray actionForReturnArrayWithYear:nextYear month:nextMonth day:self.changeDay isNowArr:NO];
    [self.scrollView2 changeLabelTextAll:arrNext isShow:NO];
    
    if (isZero) {
        
        //_bgScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        
        
    }
    
    
    
    //数据添加完毕，可以滑动
    self.isSlip = YES;
}

- (void)changeFrameBeforeisZeroVelocity:(BOOL)isZero
{
    int beforeMonth = self.changeMonth;
    int beforeYear = self.changeYear;
    beforeMonth--;
    if (beforeMonth <= 0) {
        
        beforeMonth = 12;
        beforeYear --;
    }
    
    
    NSArray *beforeArr = [JYToolForReturnAllArray actionForReturnArrayWithYear:beforeYear month:beforeMonth day:self.changeDay isNowArr:NO];
    [self.scrollView1 changeLabelTextAll:beforeArr isShow:NO];
    
    if (isZero) {
        
        [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
        
    }
    
    
    //数据添加完毕，可以滑动
    self.isSlip = YES;
}


@end
