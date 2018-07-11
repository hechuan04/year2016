//
//  JYRemindViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYHourDatePicker.h"
#import "JYYearAndMonthPicker.h"
#import "JYContentTexgFiled.h"
#import "JYContentTextView.h"
#import "JYPickerViewForRemind.h"
#import "ClockModel.h"
#import "VoiceBarView.h"
#import "MicrophoneView.h"
#import "SDPhotoBrowser.h"
#import "AudioModel.h"
#import <CoreLocation/CoreLocation.h>
#import "JYRememberTB.h"

#define kImageViewBaseTag 1000

@class JYRemindViewController;
@protocol JYRemindViewControllerDelegate <NSObject>

- (void)passModel:(RemindModel *)model
      remindOther:(BOOL )isOther;

@end


@interface JYRemindViewController : UIViewController<UIAlertViewDelegate,VoiceBarDelegate,SDPhotoBrowserDelegate,MicrophoneViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

//进入时的年月日
@property (nonatomic ,assign)int model_year;
@property (nonatomic ,assign)int model_month;
@property (nonatomic ,assign)int model_day;
@property (nonatomic ,assign)int model_hour;
@property (nonatomic ,assign)int model_minute;



@property (nonatomic ,weak)id<JYRemindViewControllerDelegate>delegate;

//@property (nonatomic ,strong)JYContentTexgFiled *titleField; //Remindtitle
@property (nonatomic ,strong)UITextField *titleField;

@property (strong, nonatomic)JYContentTextView *contentView;  //remindContent

@property (nonatomic ,strong)UIView *viewForSelectFriend;    //选中的推送对象

@property (nonatomic ,strong)UIView *bgView;         // <! 内容背景框
@property (nonatomic ,strong)UIView * localView;    // <! 定位完成显示的视图
@property (nonatomic ,strong)UIView * addImageView; // <! 存放图片的视图


@property (nonatomic ,strong)UIButton *voiceBtn;     // <! 语音
@property (nonatomic ,strong)UIButton *takePhotoBtn; // <! 选择照片
@property (nonatomic ,strong)UIButton *locationBtn;  // <! 定位
@property (nonatomic ,strong)UIButton *handwritingBtn;// <! 手写输入

@property (nonatomic ,strong)NSMutableArray *imagesArray; // <!用于记录添加和删除的照片
@property (nonatomic ,strong)NSString *cityString;  // <! 当前定位地址
@property (nonatomic ,strong)NSString *latitudeStr;  // <! 纬度
@property (nonatomic ,strong)NSString *longitudeStr; // <! 经度
@property (nonatomic ,assign)CGRect textLineHeight; // <! 当前文本高度
@property (nonatomic ,assign)NSInteger lineNumber; // <! 当前文本高度
@property (nonatomic ,strong)NSString * folderPath;// <! 组图片存放文件夹
//@property (nonatomic,strong) CLLocationManager* locationManager;// 定位

@property (nonatomic ,strong)UITableView *remindTb;
@property (nonatomic ,strong)JYRememberTB *rememberTB;

@property (nonatomic ,strong)UIView *viewForBg;

@property (nonatomic ,strong)NSArray     *arrForText;
@property (nonatomic ,strong)NSArray     *dayNameArray;

@property (nonatomic ,strong)UILabel *labelForLunar;//阴历
@property (nonatomic ,strong)UILabel *labelForToday;//今天label



@property (nonatomic ,strong)UIButton *btnForLunar; //选择阳历按钮
@property (nonatomic ,strong)UIButton *btnForTodayRemind; //选择今天按钮
@property (nonatomic ,strong)UILabel  *labelFotTodayRemind; //今天Label

@property (nonatomic ,strong)UIView *yearAndMinuteView;//年月日picker
@property (nonatomic ,assign)BOOL isSelectYearAndMonth;

@property (nonatomic ,copy)NSString *strForRepeat;
@property (nonatomic ,copy)NSString *strForMusic;

//直接从数组跳过来不改变model
@property (nonatomic ,strong)RemindModel *model;
@property (nonatomic ,copy)NSString *NotChange_gidStr;
@property (nonatomic ,copy)NSString *NotChange_fidStr;

@property (nonatomic ,strong)JYYearAndMonthPicker *jyYearAndMonth;
@property (nonatomic ,strong)JYHourDatePicker *hourDatePicker;
@property (nonatomic ,strong)JYPickerViewForRemind *jyAllPicker;


@property (nonatomic ,assign)BOOL isOpen;
@property (nonatomic ,assign)BOOL isLunar;

@property (nonatomic ,assign)BOOL isDisturb;

@property (nonatomic ,strong)NSArray *musicArr;
@property (nonatomic ,strong)NSArray *arrForFriend; //传进来的好友
@property (nonatomic ,strong)NSArray *arrForGroup;  //传进来的组

//上传拼串ID
@property (nonatomic ,strong)NSString *gidStr;
@property (nonatomic ,strong)NSString *fidStr;

@property (nonatomic ,assign)BOOL confirm; //选择时间的时候，点击完成按钮

//判断时候是新创建还是点击cell进入
@property (nonatomic ,assign)BOOL isCreate;


//*********************添加好友View上的Image*****************//

@property (nonatomic ,strong)UIImageView *image1;
@property (nonatomic ,strong)UIImageView *image2;
@property (nonatomic ,strong)UIImageView *image3;
@property (nonatomic ,strong)UIImageView *image4;
@property (nonatomic ,strong)UIImageView *image5;

//涉及重复的变更
@property (nonatomic ,strong)NSString *strForTitle;


//@property (nonatomic,strong) NSMutableArray *audioFilePaths;//录音文件路径数组
@property (nonatomic,strong) NSMutableArray *audios;//录音数组
@property (nonatomic,strong) NSMutableArray *voiceBars;

@property (nonatomic,assign) CGRect cityLabelRect;
@property (nonatomic,strong) UIImageView *localIconView;
@property (nonatomic,strong) UIView *localVerLineView;
@property (nonatomic,strong) UILabel *localLabelView;
@property (nonatomic,strong) UIButton *localDeleteBtn;
/**
 *  隐藏或显示群组、朋友
 */
- (void)actionForHidenOrAppearFriend;


- (void)confirmActionForPop:(UIButton *)sender;

- (void)layoutVoiceBars;
@end
