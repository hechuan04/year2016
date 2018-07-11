//
//  JYMainViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//VC
#import "JYRemindViewController.h"
#import "JYSetUpViewController.h"
#import "JYPersonCentreViewController.h"
#import "JYScrollViewForCalendar.h"
#import "JYScrollViewForUp.h"

//View
#import "JYRemindView.h"
#import "JYTitleBtn.h"

//#import "JYWeatherView.h"
#import "JYCalendarView.h"

#import "JYYearAndMonthPicker.h"

#import "AddressBook.h"

#import "WeatherView.h"
#import "JYCalendarModel.h"
@interface JYMainViewController : BaseViewController<UIScrollViewDelegate,jyScrollViewForCalendarDelegate>

typedef NS_ENUM(int , selectForLine)
{
    
    firstLine = 0,
    secondLine ,
    thirdLine ,
    fourthLine ,
    fifthLine,
    sixthLine,
    seventhLine,
};

@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic ,strong)UIButton *rightBtn;


//记录日历状态
@property (nonatomic ,assign)BOOL canScroll;

//添加按钮(没有提醒的页面上)
@property (nonatomic ,strong)UIButton *btnForAddNotRemind;

@property (nonatomic ,strong)UIWindow *_sheetWindow;

//按钮管理类
@property (nonatomic ,strong)ManagerForButton *managerForBtn;


//今天按钮
@property (nonatomic ,strong)UIButton *btnForToday;
//添加新页面方法
@property (nonatomic ,strong)UIButton *btnForAdd;
//选择天数按钮
@property (nonatomic ,strong)JYTitleBtn *btnForTitle;
@property (nonatomic ,strong)UIButton *btnForSelectDay;
@property (nonatomic ,strong)UIButton *btnForBigSelectDay;
//大闹钟
@property (nonatomic ,strong)UIButton *btnForBigBtn;
@property (nonatomic,strong) UIButton *btnForMe;
//星期
@property (nonatomic ,strong)UIView   *weekView;
//日历
@property (nonatomic ,strong)UIButton *btnForLunar;

//天气
//@property (nonatomic ,strong)JYWeatherView  *jyWeatherView;
@property (nonatomic,strong) WeatherView  *jyWeatherView;
//天气与日期分割线
@property (nonatomic ,strong)UIView   *viewForLineT;
@property (nonatomic ,strong)UIView   *viewForLineT1;
@property (nonatomic ,strong)UIView   *viewForLineT2;

//提醒页面
@property (nonatomic ,strong)JYRemindView  *jyRemindView;
@property (nonatomic ,assign)BOOL    isSelectPass;

//没有提醒的时候显示的页面
@property (nonatomic ,strong)UIImageView *imageForNotRemind;
//补齐下边的空白
@property (nonatomic ,strong)UIView *viewForWhite;

@property (nonatomic ,assign)int weekForSelectMonth;
//选中日历的tag
@property (nonatomic ,assign)int x_Collection;


//字体适配
@property (nonatomic ,strong)UIFont   *weekFont;

//按钮高度
@property (nonatomic ,assign)int      heightForTitleBtn;
@property (nonatomic ,assign)int      heightForSelectBtn;
@property (nonatomic ,assign)int      widhtForSelectBtn;



//年
@property (nonatomic ,assign)int changeYear;   //一直改变的年
//月
@property (nonatomic ,assign)int changeMonth;  //一直改变的月
//日
@property (nonatomic ,assign)int changeDay;    //一直改变的日

//初始化今天日期
@property (nonatomic ,assign)int notChangeYear;
@property (nonatomic ,assign)int notChangeMonth;
@property (nonatomic ,assign)int notChangeDay;



//用于确定上移的系数
@property (nonatomic ,assign)int tapForUp;
@property (nonatomic ,assign)int tapLeftAndRight;//左右滑动的系数，确定这个月，不变
@property (nonatomic ,assign)BOOL isUp;  //确定是否上去了


//阴阳转换的方法
@property (nonatomic ,strong)LunarCalendar *lunarCalendar;


//适配今天和提醒列表按钮
@property (nonatomic ,assign)int yForRemindList;

@property (nonatomic,strong) UIButton *backButton;

//隐藏选择日期按钮
- (void)hiddenAction:(BOOL)isHidden;


//是否隐藏RemindView
- (void)actionForHiddenNotRemindView:(BOOL )isHiddenRemindView;


//****************************选择日期**********************//
@property (nonatomic ,strong)UIView *yearAndMinuteView;//年月日picker
@property (nonatomic ,strong)JYYearAndMonthPicker *jyYearAndMonth;
@property (nonatomic ,strong)UILabel *labelForLunar;//阴历
@property (nonatomic ,strong)UILabel *labelForToday;//今天label
@property (nonatomic ,strong)UILabel *labelForWeek;//星期
@property (nonatomic ,strong)UILabel *labelForY; //年
@property (nonatomic ,strong)UILabel *labelForM; //月
@property (nonatomic ,strong)UILabel *labelForD; //日
@property (nonatomic ,assign)int lunarMonth;
@property (nonatomic ,assign)int lunarDay;
@property (nonatomic ,assign)BOOL isSelectYearAndMonth;
@property (nonatomic ,assign)BOOL isLunar;

+ (JYMainViewController *)shareInstance;

//回今天改变topView
- (void)actionForBackTopView:(int )index
                      btnTag:(int )tag;

//加载数据
- (void)actionForReloadAllData;

//****************新更改页面*********************//
@property (nonatomic ,strong)JYSelectManager *selectManager;
@property (nonatomic ,strong)JYCalendarView *calendarView;
@property (nonatomic ,assign)int lineSign;  //选中行数的type

@property (nonatomic ,strong)UIScrollView *bgScrollView; //左右滑动
@property (nonatomic ,strong)JYScrollViewForCalendar *scrollView; //上下滑动，中间显示的日历
@property (nonatomic ,strong)JYScrollViewForCalendar *scrollView1; //左提前加载的日历
@property (nonatomic ,strong)JYScrollViewForCalendar *scrollView2;//右提前加载的日历


@property (nonatomic ,strong)JYScrollViewForUp *scrollViewForUp; //最上边单独的一行

@property (nonatomic ,strong)NSArray *changeArrForHidden;  //保存当前显示的labelarr，用于刷新隐藏的页面Label内容

//专用于判断上下拉动的时候，是否需要调用点击传值的方法

@property (nonatomic ,assign)int lunnarDay;
@property (nonatomic ,assign)int lunnarMonth;
@property (nonatomic ,assign)int lunnarYear;


@property (nonatomic ,assign)int selectTag;
@property (nonatomic ,assign)CGFloat width;
@property (nonatomic ,assign)BOOL isSlip;

//@property (nonatomic ,strong)UIView *viewForLine;

@property (nonatomic,strong) UIImageView *dragImageView;

//回今天方法
- (void)backToday:(UIButton *)sender;
@end
