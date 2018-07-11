//
//  CalendarDetailViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/31.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import "WeatherCell.h"
#import "FestivalCell.h"
#import "TopBorderView.h"
#import "BottomBorderView.h"
#import "YiJiCell.h"
#import <CoreLocation/CoreLocation.h>
#import "WeatherViewController.h"
#import "FestivalDetailViewController.h"
#import "ChooseCityViewController.h"
#import "WeatherCache.h"
#import "JYCity.h"
#import "WeatherUtil.h"
#import "LunarHelper.h"

#define kTableViewWidth (kScreenWidth-40.f)
#define kBigDayLabelHeight (IS_BIG_THAN_IPHONE_6_SCREEN?260.f:(IS_SMALL_THAN_IPHONE_6_SCREEN?160.f:200.f))
#define kBigDayLabelFontSize (IS_SMALL_THAN_IPHONE_6_SCREEN?180:210)
#define kLocationHeight 20.f
#define kVerPadding (IS_SMALL_THAN_IPHONE_6_SCREEN?10.f:20.f)
#define kFontSizeForTianGan (IS_SMALL_THAN_IPHONE_6_SCREEN?11.f:12.f)
#define kFontSizeForLunar (IS_SMALL_THAN_IPHONE_6_SCREEN?20.f:22.f)

#define kTableViewFooterHeight 40
#define kShowWeatherCount 5

static NSString *kCellIdentifierYiJi = @"kCellIdentifierYiJi";
static NSString *kCellIdentifierWeather = @"kCellIdentifierWeather";


@interface CalendarDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *bigDayLabel;
@property (nonatomic,strong) UIButton *locationButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIView *tableFooterView;

@property (nonatomic,copy) NSString *yiString;
@property (nonatomic,copy) NSString *jiString;
@property (nonatomic,strong) UILabel *eraLabel;//原需求是显示天干地支，现变为大写年月
@property (nonatomic,strong) UILabel *weekENLabel;
@property (nonatomic,strong) UILabel *weekCNLabel;

@property (nonatomic,strong) NSMutableArray *festivals;
@property (nonatomic,assign) NSInteger foDayCount;
@property (nonatomic,assign) NSInteger sumRowCount;

@property (nonatomic,strong) JYCity *currentCity;
@property (nonatomic,assign) BOOL isQuerying;
@property (nonatomic,strong) NSMutableDictionary *weatherModelDict;

@end

@implementation CalendarDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImage *closeImage =[UIImage imageNamed:[NSString stringWithFormat:@"关闭_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    [closeBtn setImage:[closeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];

    [self.view addSubview:self.tableView];
    
    self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:self.weatherModel.city];//获取城市代码，防止天气数据没有请求回来
    [self refreshData];//刷新页面
    [self querySelectCityWeather];//请求定位城市天气数据，有缓存读缓存
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionForSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionForSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    
   
    
    
    //设置完UI在添加手势方法的view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseCity:) name:kChooseCityWeatherNotification object:nil];
    
    // 接收传入的当天的天气数组
    
    
}

- (void)actionForSwipe:(UISwipeGestureRecognizer *)gesture
{
    
    
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setYear:self.calendarModel.year];
    [com setMonth:self.calendarModel.month];
    [com setDay:self.calendarModel.day];
    
    NSCalendar *calendar = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:com];
    long long times = [date timeIntervalSince1970]*1;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
  
        times = times - 24 * 60 * 60;
        
    }else{
       
        times = times + 24 * 60 * 60;

    }
    
    NSDate *selectDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateComponents *selectCom = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selectDate];
    self.calendarModel = [[JYCalendarModel alloc] initWithYear:selectCom.year month:selectCom.month day:selectCom.day];
;
    NSLog(@"%@",_weatherModel.weatherArray);
  
    [self refreshWeatherModel];
    [self refreshData];
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //navigationBar透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
#pragma mark - Private
- (void)refreshData
{
    NSAssert(self.calendarModel&&self.weatherModel, @"calendarModel/weatherModel 不能为空");
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月",self.calendarModel.year,self.calendarModel.month];
    _bigDayLabel.text = [NSString stringWithFormat:@"%ld",self.calendarModel.day];
    [_locationButton setTitle:self.currentCity.county forState:UIControlStateNormal];
    _eraLabel.text = [NSString stringWithFormat:@"(%@) %@ %@",self.calendarModel.zodia,self.calendarModel.lunarYear,self.calendarModel.lunarMonth];
    
    UILabel *label = [self.view viewWithTag:123];
    label.text = self.calendarModel.lunarDay;
    
    _weekENLabel.text = self.calendarModel.weekEnString;
    _weekCNLabel.text = self.calendarModel.weekCNString;
    
    
    NSArray *tmpArr = [self.calendarModel.festival componentsSeparatedByString:@" "];
    self.festivals = [NSMutableArray arrayWithCapacity:[tmpArr count]];
    for(int i=0; i<[tmpArr count]; i++){
        NSString *festival = tmpArr[i];
        if(![festival isEmpty]){
            [self.festivals addObject:festival];
        }
    }

    _foDayCount = self.calendarModel.foDay?1:0;
    if(_foDayCount==0&&[self.festivals count]==0){
        [self.festivals addObject:@"无"];
    }
    _sumRowCount = [self.festivals count]+_foDayCount+2;//节日+佛历+天气+宜忌
    
    [self calculateYiji];
}
- (void)closeView:(UIButton *)leftButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)calculateYiji
{
    self.yiString = self.calendarModel.niceToDo;
    self.jiString = self.calendarModel.badToDo;
    [self.tableView reloadData];
}
- (void)clickedYunChengBtn:(UIButton *)sender
{
    [self toLNYC];
}

-(void)toLNYC {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/2016liu-nian-yun-cheng/id1050885664?l=en&mt=8"]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"======frame%@===:contentSize:%@",[NSValue valueWithCGRect:scrollView.frame],[NSValue valueWithCGSize:scrollView.contentSize]);
}
#pragma mark - Protocol
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if([[UIDevice currentDevice].systemVersion floatValue]<8.0){
        CGFloat rowHeight = 0.f;
    if(IS_BIG_THAN_IPHONE_6_SCREEN){
        if(indexPath.row==self.sumRowCount-1){//宜忌
            rowHeight = 80.f;
        }else if(indexPath.row==self.sumRowCount-2){//天气
            rowHeight = 60.f;
        }else{
            if(self.sumRowCount>3){//节日1个以上
                rowHeight = 42.f;
            }else{
                rowHeight = 60.f;
            }
        }
    }else{
        if(indexPath.row==self.sumRowCount-1){//宜忌
            rowHeight = 76.f;
        }else if(indexPath.row==self.sumRowCount-2){//天气
            rowHeight = 50.f;
        }else{
            if(self.sumRowCount>3){//节日1个以上
                rowHeight = 42.f;
            }else{
                rowHeight = 50.f;
            }
        }
    }
        return rowHeight;
//    }else{
//        return UITableViewAutomaticDimension;
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sumRowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==self.sumRowCount-1){//宜忌
        
        YiJiCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierYiJi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.yiContentLabel.text = self.yiString;
        cell.jiContentLabel.text = self.jiString;
        return cell;
        
    }else if(indexPath.row==self.sumRowCount-2){//天气
        
        WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWeather];
        
        if(self.weatherModel){
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.aqiLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",self.weatherModel.aqiInfo,self.weatherModel.aqi];
            cell.contentLabel.text = [[NSString alloc] initWithFormat:@"%@ %@°C",self.weatherModel.currentWeather,self.weatherModel.currentTemperature];
            cell.iconView.image = self.weatherModel.weatherImage;

        }else{
            

        }
        return cell;
        
    }else{
        FestivalCell *cell;
        if(self.sumRowCount>3){//不止一个节日
            if(indexPath.row==0){//第一个节日
                cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierFestivalTop];
            }else if(indexPath.row==[self.festivals count]+self.foDayCount-1){//最后一个节日或佛历
                cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierFestivalBottom];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierFestival];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierFestival];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row<[self.festivals count]){//节日
            NSString *festival = self.festivals[indexPath.row];
            cell.contentLabel.text = festival;
            cell.detailBtn.hidden = [festival isEqualToString:@"无"];
            cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"节_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
            [cell.detailBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
            
        }else{//佛历
            cell.contentLabel.text = self.calendarModel.foDay;
            cell.iconView.image = [UIImage imageNamed:@"佛字"];
            [cell.detailBtn setTitleColor:UIColorFromRGB(0xAE7B06) forState:UIControlStateNormal];
        }
        return cell;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row==(self.sumRowCount -2)){//倒数第二行，天气
        
        WeatherViewController *weatherVC = [[WeatherViewController alloc]init];
        weatherVC.cityString = _locationButton.titleLabel.text;
        [self.navigationController pushViewController:weatherVC animated:YES];
        
    }else if(indexPath.row<(self.sumRowCount-2)){
        if(indexPath.row<[self.festivals count]){//节日，展示详情
            
            NSString *festival = self.festivals[indexPath.row];
            if(![festival isEqualToString:@"无"]){
                FestivalDetailViewController *detailVC = [[FestivalDetailViewController alloc]initWithFestivalType:FestivalTypeNormal name:festival];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }else {//佛历展示详情
            FestivalDetailViewController *detailVC = [[FestivalDetailViewController alloc]initWithFestivalType:FestivalTypeFoLi name:self.calendarModel.foDay];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
//    if(indexPath.row==1){        
//        if ([CLLocationManager locationServicesEnabled]) {
//            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//                if(![[NSUserDefaults standardUserDefaults]boolForKey:kHasAlertLocationSettingKey]){
//                    //提示用户无法进行定位操作
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alertView show];
//                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kHasAlertLocationSettingKey];
//                }
//            }else{
//                
//            }
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查您的设备是否开启了定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
    
}
#pragma mark - Custom Accessors

- (UILabel *)bigDayLabel{
    if(!_bigDayLabel){
        _bigDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kVerPadding,kTableViewWidth,kBigDayLabelHeight)];
        _bigDayLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:kBigDayLabelFontSize];
        _bigDayLabel.textAlignment = NSTextAlignmentCenter;
        _bigDayLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    }
    return _bigDayLabel;
}
- (UIButton *)locationButton{
    if(!_locationButton){
        _locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.bigDayLabel.frame), kTableViewWidth, kLocationHeight)];
        [_locationButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"天气_定位_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]] forState:UIControlStateNormal];
        _locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _locationButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_locationButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _locationButton.adjustsImageWhenHighlighted = NO;
        [_locationButton addTarget:self action:@selector(actionForSelectCity:) forControlEvents:(UIControlEventTouchUpInside)];
        [_locationButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _locationButton;
}
- (UITableView *)tableView{
    
    if(!_tableView){
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake((kScreenWidth-kTableViewWidth)/2,0,kTableViewWidth,kScreenHeight-64)];
        if([[UIDevice currentDevice].systemVersion floatValue]>8.0){
            _tableView.estimatedRowHeight = 40.f;
        }
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[FestivalCell class] forCellReuseIdentifier:kCellIdentifierFestival];
        //最上面一个节日cell内容靠下一些
        [_tableView registerClass:[FestivalCell class] forCellReuseIdentifier:kCellIdentifierFestivalTop];
        //最下面一个节日内容靠上一些
        [_tableView registerClass:[FestivalCell class] forCellReuseIdentifier:kCellIdentifierFestivalBottom];
        [_tableView registerClass:[YiJiCell class] forCellReuseIdentifier:kCellIdentifierYiJi];
        [_tableView registerClass:[WeatherCell class] forCellReuseIdentifier:kCellIdentifierWeather];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = self.tableFooterView;
        
    }
    return _tableView;
}

/*
    包含大阳历，定位，农历星期部分。
 */
- (UIView *)tableHeaderView{
    if(!_tableHeaderView){
        
        CGFloat headerWidth = kTableViewWidth;
        CGFloat topBorderViewHeight = 10.f;
        CGFloat weekENHeight = 20.f;
        CGFloat weekCNHeight = 40.f;
        CGFloat verMargin = 20.f;
        CGFloat headerHeight = kVerPadding+kBigDayLabelHeight+kLocationHeight+verMargin+topBorderViewHeight+weekENHeight+weekCNHeight;
        CGFloat horMargin = 5.f;
        CGFloat lineWidth = 1.f;
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerWidth,headerHeight)];
        
        //大日期
        [_tableHeaderView addSubview:self.bigDayLabel];
        //地址
        [_tableHeaderView addSubview:self.locationButton];
        
        TopBorderView *topBorderView = [[TopBorderView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.locationButton.frame)+verMargin,headerWidth,topBorderViewHeight)];
        [_tableHeaderView addSubview:topBorderView];
        
        //天干地支
        _eraLabel = [[UILabel alloc]initWithFrame:CGRectMake(horMargin,CGRectGetMaxY(topBorderView.frame),(headerWidth-lineWidth)/2.f-horMargin*2,weekENHeight)];
        _eraLabel.font = [UIFont systemFontOfSize:kFontSizeForTianGan];
        _eraLabel.text = @"(猴) 丙申年 辛末月 丁酉日";
        _eraLabel.textAlignment = NSTextAlignmentCenter;
        _eraLabel.numberOfLines = 0;
        [_tableHeaderView addSubview:_eraLabel];
        
        //农历
        UILabel *lunarLabel = [[UILabel alloc]initWithFrame:CGRectMake(horMargin,CGRectGetMaxY(_eraLabel.frame),CGRectGetWidth(_eraLabel.frame),weekCNHeight)];
        lunarLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
        lunarLabel.font = [UIFont boldSystemFontOfSize:kFontSizeForLunar];
        lunarLabel.text = self.calendarModel.lunarDay;
        lunarLabel.textAlignment = NSTextAlignmentCenter;
        lunarLabel.tag = 123;
        [_tableHeaderView addSubview:lunarLabel];
        
        //竖线-左
        UIView *lineViewLeft = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topBorderView.frame),lineWidth,weekENHeight+weekCNHeight)];
        lineViewLeft.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_tableHeaderView addSubview:lineViewLeft];

        //竖线-中
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lunarLabel.frame),CGRectGetMinY(topBorderView.frame),lineWidth,topBorderViewHeight+weekENHeight+weekCNHeight)];
        lineView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_tableHeaderView addSubview:lineView];
        
        //竖线-右
        UIView *lineViewRight = [[UIView alloc]initWithFrame:CGRectMake(headerWidth-lineWidth,CGRectGetMaxY(topBorderView.frame),lineWidth,weekENHeight+weekCNHeight)];
        lineViewRight.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_tableHeaderView addSubview:lineViewRight];

        //竖线-下
        UIView *lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lunarLabel.frame),kTableViewWidth,lineWidth)];
        lineViewBottom.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_tableHeaderView addSubview:lineViewBottom];
        
        //星期英文
        _weekENLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+horMargin,CGRectGetMaxY(topBorderView.frame),(headerWidth-lineWidth)/2.f-horMargin*2,weekENHeight)];
        _weekENLabel.font = [UIFont systemFontOfSize:kFontSizeForTianGan];
        _weekENLabel.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_weekENLabel];
        
        //星期中文
        _weekCNLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+horMargin,CGRectGetMaxY(_weekENLabel.frame),CGRectGetWidth(_eraLabel.frame),weekCNHeight)];
        _weekCNLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _weekCNLabel.font = [UIFont boldSystemFontOfSize:kFontSizeForLunar];
        _weekCNLabel.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_weekCNLabel];
        
    }
    return _tableHeaderView;
}
- (UIView *)tableFooterView{
    
    if(!_tableFooterView){
        
        CGFloat footerWidth = kTableViewWidth;
        CGFloat footerHeight = kTableViewFooterHeight;
        CGFloat bottomBorderViewHeight = 10.f;
//        CGFloat yunchengHeight = 30.f;
//        CGFloat lineWidth = 1.f;
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, footerWidth,footerHeight)];
        BottomBorderView *footerView = [[BottomBorderView alloc]initWithFrame:CGRectMake(0, 0, footerWidth, bottomBorderViewHeight)];
        [_tableFooterView addSubview:footerView];
        
//        TopBorderView *border1 = [[TopBorderView alloc]initWithFrame:CGRectMake(0, bottomBorderViewHeight+10, footerWidth, bottomBorderViewHeight)];
//        [_tableFooterView addSubview:border1];
        
//        //竖线-左
//        UIView *lineViewLeft = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(border1.frame),lineWidth,yunchengHeight)];
//        lineViewLeft.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
//        [_tableFooterView addSubview:lineViewLeft];
//        
//        //竖线-右
//        UIView *lineViewRight = [[UIView alloc]initWithFrame:CGRectMake(kTableViewWidth-lineWidth,CGRectGetMaxY(border1.frame),lineWidth,yunchengHeight)];
//        lineViewRight.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
//        [_tableFooterView addSubview:lineViewRight];
//        
//        UIButton *yunchengBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(border1.frame),footerWidth, yunchengHeight)];
//        yunchengBtn.titleLabel.font = [UIFont systemFontOfSize:22.f];
//        [yunchengBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
//        [yunchengBtn setTitle:@"2016年流年运程" forState:UIControlStateNormal];
//        [yunchengBtn addTarget:self action:@selector(clickedYunChengBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_tableFooterView addSubview:yunchengBtn];
//        
//        BottomBorderView *border2 = [[BottomBorderView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(yunchengBtn.frame), footerWidth, bottomBorderViewHeight)];
//        [_tableFooterView addSubview:border2];
    }
    return _tableFooterView;
}
- (NSMutableDictionary *)weatherModelDict
{
    if(!_weatherModelDict){
        _weatherModelDict = [NSMutableDictionary dictionary];
    }
    return _weatherModelDict;
}
#pragma mark - Action
- (void)actionForSelectCity:(UIButton *)sender{
    
    ChooseCityViewController * chooseCity = [[ChooseCityViewController alloc]init];
    [self presentViewController:chooseCity animated:YES completion:nil];
    
}
- (void)chooseCity:(NSNotification *)notification
{
    JYCity *city = notification.userInfo[kChooseCityKey];
    [_locationButton setTitle:city.county forState:UIControlStateNormal];
    self.currentCity = city;
    [self querySelectCityWeather];
    NSLog(@"selectcity%@",city);
    
}
#pragma mark - 更新天气数据
//查询当前定位城市天气
- (void)querySelectCityWeather
{
        //网络加载
        if(self.currentCity&&!self.isQuerying){
            __weak typeof(self) ws = self;
            self.isQuerying = YES;
            [RequestManager queryWeatherDataWithCity:self.currentCity completed:^(id data, NSError *error) {
                if([data isKindOfClass:[NSDictionary class]]){
                    WeatherViewModel *model = [[WeatherViewModel alloc] initWithDictionary:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(ws.currentCity.cityType==JYCityTypeInland){
                            // 保存当天的天气信息 左右滑动是需要用到
                            [ws.weatherModelDict setObject:model.currentWeather forKey:@"currentWeather"];
                            [ws.weatherModelDict setObject:model.currentTemperature forKey:@"currentTemperature"];
                            [ws.weatherModelDict setObject:model.aqi forKey:@"aqi"];
                        }else{
                            [ws.weatherModelDict setObject:model forKey:self.currentCity.cityNameEN];
                        }
                        ws.weatherModel = model;
                        [ws refreshWeatherModel];
                        [ws.tableView reloadData];
                        NSLog(@"weatherModelDict\n%@",ws.weatherModelDict);
                    });
                }
            }];
        }
}

- (void)refreshWeatherModel{
    
    JYDateOrder order = self.calendarModel.dateOrder;
    UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    if(order==JYDateOrderAfterToday){
        NSDate *today = [NSDate date];
        NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:today];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        today = [cal dateFromComponents:components];//今日0点时间
        NSDateComponents *diffComp = [cal components:NSCalendarUnitDay fromDate:today toDate:self.calendarModel.date options:0];
        _weatherModel.currentTemperature = @"";
        _weatherModel.currentWeather = @"Weather";
        _weatherModel.weatherImage = weatherImage;
        
        if(diffComp.day<kShowWeatherCount){//未来6日天气
            WeatherModel *wmodel = _weatherModel.weatherArray[diffComp.day];
            if(wmodel){
                _weatherModel.currentWeather = [[NSString alloc] initWithFormat:@"%@", wmodel.weatherStr];
                _weatherModel.currentTemperature = [NSString stringWithFormat:@"%ld/%ld",wmodel.minTemp,wmodel.maxTemp];
                _weatherModel.weatherImage = [UIImage imageNamed:wmodel.weatherIconName];
                
            }
        }
        _weatherModel.aqiInfo = @"数据未更新";
        _weatherModel.aqi = @"";
        
    }else if(order==JYDateOrderEqualToday){
        
        [self resetWeatherModel:_weatherModel];
        
    }else if(order==JYDateOrderBeforeToday){
        
        _weatherModel.aqiInfo = @"数据已过期";
        _weatherModel.aqi = @"";
        _weatherModel.currentTemperature = @"";
        _weatherModel.currentWeather = @"Weather";
        _weatherModel.weatherImage = weatherImage;
        
    }
}

- (void)resetWeatherModel:(WeatherViewModel *)model
{
    // 重新获取当天的天气信息
    _weatherModel.currentWeather = [self.weatherModelDict objectForKey:@"currentWeather"];
    _weatherModel.currentTemperature = [self.weatherModelDict objectForKey:@"currentTemperature"];
    _weatherModel.aqi = [self.weatherModelDict objectForKey:@"aqi"];

    
    if(model&&self.calendarModel.dateOrder==JYDateOrderEqualToday){
        
        //天气图片
        if([model.currentWeather isEqual: @"晴"]){
            _weatherModel.weatherImage = [UIImage imageNamed:@"晴.png"];
        }else if([model.currentWeather isEqual: @"阴"]){
            _weatherModel.weatherImage = [UIImage imageNamed:@"阴.png"];
        }else if([model.currentWeather isEqual: @"雾"]||[model.currentWeather isEqual: @"霾"]){
            _weatherModel.weatherImage = [UIImage imageNamed:@"雾.png"];
        }else if([model.currentWeather isEqual: @"雨夹雪"]){
            _weatherModel.weatherImage = [UIImage imageNamed:@"雨夹雪.png"];
        }else if([model.currentWeather rangeOfString:@"冰雹"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"冰雹.png"];
        }else if([model.currentWeather rangeOfString:@"风"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"暴风.png"];
        }else if([model.currentWeather rangeOfString:@"雪"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"暴雪.png"];
        }else if([model.currentWeather rangeOfString:@"雨"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"小雨.png"];
        }else if([model.currentWeather rangeOfString:@"云"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"多云.png"];
        }else if([model.currentWeather rangeOfString:@"沙"].location != NSNotFound || [model.currentWeather rangeOfString:@"尘"].location != NSNotFound){
            _weatherModel.weatherImage = [UIImage imageNamed:@"沙尘暴.png"];
        }else{
            _weatherModel.weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        }
        
        //空气质量信息取前两位
        if([model.aqi integerValue]<50){
            _weatherModel.aqiInfo = @"优";
        }else if([model.aqi integerValue]<100){
            _weatherModel.aqiInfo = @"良";
        }else if([model.aqi integerValue]<200){
            _weatherModel.aqiInfo = @"轻度";
        }else if([model.aqi integerValue]<300){
            _weatherModel.aqiInfo = @"中度";
        }else{
            _weatherModel.aqiInfo = @"重度";
        }        
    }
}
@end
