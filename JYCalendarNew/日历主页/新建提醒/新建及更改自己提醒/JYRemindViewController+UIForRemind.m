//
//  JYRemindViewController+UIForRemind.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindViewController+UIForRemind.h"
#import "JYRemindViewController+ActionForRemind.h"
//#import "ImageViewController.h"
//#import "LocationViewController.h"
#import "JYBatchSelectionVC.h"

#import "JYRemindCell.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "JYZhengdianTimes.h"
/*****************************时分************************/

#define pageForTbAndDatePicker 30 / 1334.0 * kScreenHeight
#define heightForDatePicker 273 / 1334.0 * kScreenHeight
#define heightForHour 20 / 1334.0 * kScreenHeight

#define heightForCc 88 / 1334.0 * kScreenHeight

//title
#define yForTitle 30 / 1334.0 * kScreenHeight
#define xForTitle 16 / 750.0 * kScreenWidth
#define heightForTitle 89 / 1334.0 * kScreenHeight

//friendView  title
#define pageForTitleAndFriend 22 / 1334.0 * kScreenHeight

//friendview  content
#define pageForContentAndFriend 14 / 1334.0 * kScreenHeight

//content
#define yForContent 172 / 1334.0 * kScreenHeight
//#define heightForContent 480 / 1334.0 * kScreenHeight
#define heightForContent (600 - 90) / 1334.0 * kScreenHeight

//#define heightForBgView 558 / 1334.0 * kScreenHeight
#define heightForBgView (678 - 90) / 1334.0 * kScreenHeight

//table
#define yForTable 426 / 1334.0 * kScreenHeight
#define heightForTable 448 / 1334.0 * kScreenHeight

//cell
#define heightForCell 89 / 1334.0 * kScreenHeight


#define heightForYearDatePicker 514 / 1334.0 * kScreenHeight

#define heightForHour 20 / 1334.0 * kScreenHeight

//****************************添加朋友View用到的frame******************//

#define xForAddFlabel 29 / 750.0 * kScreenWidth

#define xForAddImage 654 / 750.0 * kScreenWidth

#define sizeForImage 60 / 1334.0 * kScreenHeight

#define pageForImage 20 / 750.0 * kScreenWidth

/******************************年月日**********************/

//提醒日期label
#define xForTimeLabel 1037 / 750.0 * kScreenWidth
#define yForTimeLabel 33 / 1334.0 * kScreenHeight

//line
#define yForLine 98 / 1334.0 * kScreenHeight

//年月日label
#define yForDate 1160 / 1334.0 * kScreenHeight

//年
#define xForYear 243 / 750.0 * kScreenWidth
//月
#define xForMonth 390 / 750.0 * kScreenWidth
//日
#define xForDay 549 / 750.0 * kScreenWidth
//星期
#define yForWeek 1147 / 1334.0 * kScreenHeight
#define xForWeek 580 / 750.0 * kScreenWidth

//今天
#define xForToday 635 / 750.0 * kScreenWidth

//农历
#define yForLunar 930 / 1334.0 * kScreenHeight
#define xForLunar 30 / 750.0 * kScreenWidth

//农历Btn
#define xForLunarBtn 115 / 750.0 * kScreenWidth

//适配
#define CGFrameMake(x,y,width,height) CGRectMake(kScreenWidth*((float)(x)/750), kScreenHeight*((float)(y)/1334), kScreenWidth*((float)(width)/750), kScreenHeight*((float)(height)/1334))


#define kSpace 40/1334.0*kScreenHeight //上下间距
#define kHorSpace 20/750.0*kScreenWidth //左右间距
#define kContentSizeW self.contentView.size.width - 40 //滚动区域宽度


#define kTextViewHorMargin 10.f
#define kImageContainerViewHorMargin 10.f

#define kImageColumnCount 4   //图片列数
#define kImageVerMargin 20 / 750.0 * kScreenWidth    //图片上下间隔
#define kImageHorMargin 20 / 1334.0 * kScreenWidth   //图片水平间隔
#define kImageViewHeight (self.contentView.bounds.size.width-2*kImageContainerViewHorMargin-(kImageColumnCount-1)*kImageHorMargin)/kImageColumnCount         //图片宽、高
#define kImageRowHeight (kImageViewHeight+kImageVerMargin)//一行图片+间隔的高度

#define kAddImgViewHeight1 156/1334.0*kScreenHeight // 一行图片
#define kAddImgViewHeight2 332/1334.0*kScreenHeight // 二行图片
#define kContentViewW self.contentView.size.width // 一行图片

#define kTextFieldTag 30001
#define kMaxTextLength 18

static NSString *strForRemindCell = @"strForRemindCell";

@implementation JYRemindViewController (UIForRemind)


- (void)setUI
{
    

    
    //title
    [self _createTitleFiled];
    
    //content
    [self _createContentView];
    
    //friend
    [self _createViewForAddFriend];
    
    //tb
    [self _createTableView];
    
    [self _createDatePickerForYearAndMonth];
    
    [self _createRememberTB];
   
}

- (void)_createRememberTB
{
    self.rememberTB = [[JYRememberTB alloc] initWithFrame:CGRectMake(xForTitle, 300, kScreenWidth - 2 * xForTitle, heightForBgView) style:UITableViewStylePlain];
    [self.view addSubview:self.rememberTB];
    
    self.rememberTB.modelDelegate = self;
    
    self.rememberTB.backgroundColor = RGB_COLOR(244, 244, 244);
    [self.rememberTB setTableFooterView:[UIView new]];
}

//rememberDelegateAction
- (void)passModel:(RemindModel *)model{

    NSLog(@"%@",model);
    self.contentView.text = model.content;
    self.model.year = model.year;
    self.model.month = model.month;
    self.model.day = model.day;
    self.model.hour = model.hour;
    self.model.minute = model.minute;
    
    [self.remindTb reloadData];
    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth = [[Tool actionForNowMonth:nil] intValue];
    int nowDay = [[Tool actionForNowSingleDay:nil] intValue];
    
    self.rememberTB.hidden = YES;
    if (self.model.year == nowYear && self.model.month == nowMonth && self.model.day == nowDay) {
        
        [self actionForChangeTodayLabelColor:YES];
        
    }else{
        
        [self actionForChangeTodayLabelColor:NO];
    }
}


/**
 *  创建标题栏
 */
- (void)_createTitleFiled
{
    int pageHeight =  pageForTitleAndFriend;
    if (self.model.upData) {
        
        UILabel *labelForCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(xForTitle, 6, 300, 12)];
        NSString *nowYear = [Tool actionForNowYear:nil];
        NSString *createTime11 = self.model.createTime;
        NSString *year = [createTime11 substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [createTime11 substringWithRange:NSMakeRange(4, 2)];
       // 201601182316
        NSString *day = [createTime11 substringWithRange:NSMakeRange(6, 2)];
        NSString *hour = [createTime11 substringWithRange:NSMakeRange(8, 2)];
        NSString *minute = [createTime11 substringWithRange:NSMakeRange(10, 2)];
   
        NSString *createTime = @"";
        if ([nowYear isEqualToString:year]) {
            
           createTime = [NSString stringWithFormat:@"创建于%@月%@ %@:%@",month,day,hour,minute];
            
        }else{
         
            createTime = [NSString stringWithFormat:@"创建于%@年%@月%@日 %@:%@",year,month,day,hour,minute];
        }
        labelForCreateTime.textColor = [UIColor grayColor];
        labelForCreateTime.font = [UIFont systemFontOfSize:10];
        labelForCreateTime.text = createTime;
        [self.view addSubview:labelForCreateTime];
        pageHeight = 24;
        
        
    }
  /*去掉标题
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(xForTitle, pageHeight , kScreenWidth - xForTitle * 2.0, heightForTitle)];
    self.titleField.placeholder = @"事件标题，最多可输入18个字符";
    self.titleField.layer.cornerRadius = 3.0;
    self.titleField.layer.masksToBounds = YES;
    self.titleField.layer.borderColor = lineColor.CGColor;
    self.titleField.layer.borderWidth = 0.5;
    self.titleField.backgroundColor = [UIColor clearColor];
    //    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,15, 15)];
    self.titleField.leftView = tmpView;
    self.titleField.leftViewMode = UITextFieldViewModeAlways;
    self.titleField.delegate = self;
    self.titleField.tag = kTextFieldTag;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                name:UITextFieldTextDidChangeNotification   object:self.titleField];
    [self.view addSubview:self.titleField];
    
    self.titleField.text = self.model.title;
    
   */
//    __block JYRemindViewController *vc = self;
//    [self.titleField setChangeFrame:^void(BOOL isEditOk){
//    
//        if (isEditOk) {
//            
//            //JYLog(@"题目正在编辑");
//           [vc.contentView resignFirstResponder];
//            
//        }else{
//        
//            //JYLog(@"题目编辑完成");
//            //[vc actionForTitle:vc.titleField.text];
//            
//        }
//        
//    }];
    
}


- (void)actionForAddFriend:(UIButton *)sender
{
  
    [self remindPeopleAction];
}



/**
 *  创建添加的好友表
 */
- (void)_createViewForAddFriend
{
 
//    self.viewForSelectFriend = [[UIView alloc] initWithFrame:CGRectMake(xForTitle, self.titleField.bottom + pageForContentAndFriend, kScreenWidth - xForTitle * 2, heightForTitle)];
    self.viewForSelectFriend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
//    [self.remindTb addSubview:self.viewForSelectFriend];
    
//    self.viewForSelectFriend.layer.cornerRadius = 3.0;
//    self.viewForSelectFriend.layer.masksToBounds = YES;
//    self.viewForSelectFriend.layer.borderColor = lineColor.CGColor;
//    self.viewForSelectFriend.layer.borderWidth = 0.5;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.viewForSelectFriend.width, self.viewForSelectFriend.height)];
    [btn addTarget:self action:@selector(actionForAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewForSelectFriend addSubview:btn];
    
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, self.viewForSelectFriend.height)];
    labelForTitle.text = @"提醒对象";
    [self.viewForSelectFriend addSubview:labelForTitle];
    
    //1
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake(xForAddImage, (self.viewForSelectFriend.height - sizeForImage) / 2.0, sizeForImage, sizeForImage)];
    self.image1.image = [UIImage imageNamed:@"添加发送人.png"];
    [self.viewForSelectFriend addSubview:self.image1];
    
    //2
    self.image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.image1.left - pageForImage - sizeForImage, (self.viewForSelectFriend.height - sizeForImage) / 2.0, sizeForImage, sizeForImage)];
    self.image2.layer.cornerRadius = self.image2.width / 2.0;
    self.image2.layer.masksToBounds = YES;
    self.image2.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image2];
//    
    //3
    self.image3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.image2.left - pageForImage - sizeForImage, (self.viewForSelectFriend.height - sizeForImage) / 2.0, sizeForImage, sizeForImage)];
    self.image3.layer.cornerRadius = self.image3.width / 2.0;
    self.image3.layer.masksToBounds = YES;
    self.image3.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image3];
    
    //4
    self.image4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.image3.left - pageForImage - sizeForImage, (self.viewForSelectFriend.height - sizeForImage) / 2.0, sizeForImage, sizeForImage)];
    self.image4.layer.cornerRadius = self.image4.width / 2.0;
    self.image4.layer.masksToBounds = YES;
    self.image4.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image4];
    
    //5
    self.image5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.image4.left - pageForImage - sizeForImage, (self.viewForSelectFriend.height - sizeForImage) / 2.0, sizeForImage, sizeForImage)];
    self.image5.layer.cornerRadius = self.image5.width / 2.0;
    self.image5.layer.masksToBounds = YES;
    self.image5.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image5];
    
    
    [self actionForHidenOrAppearFriend];
   
    
}

/**
 *  显示或隐藏群组
 */
- (void)actionForHidenOrAppearFriend
{

    //先全部置为隐藏
    self.image2.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
    self.image5.hidden = YES;
    
    NSInteger showMany = self.arrForFriend.count + self.arrForGroup.count;
    
    if (showMany > 3) {
        
        self.image2.image = [UIImage imageNamed:@"dian.png"];
        self.image2.hidden = NO;
        int countNumber = 0;
        for (int i = 0; i < self.arrForFriend.count; i++) {
            
            if (countNumber >= 3) {
                
                break;
            }
            
            FriendModel *model = self.arrForFriend[i];
            int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            if (model.fid == uid) {
                model.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            }
            if (i == 0) {
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:model.head_url]  placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image3.hidden = NO;
                
            }else if(i == 1){
                
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:model.head_url]  placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image4.hidden = NO;
                
            }else if(i == 2){
                
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:model.head_url]  placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image5.hidden = NO;
            }
            
            countNumber ++;
            
        }
        for (int i = 0 ; i < self.arrForGroup.count; i++) {
            
            if (countNumber >= 3) {
                
                break;
            }
            
             GroupModel *gModel = self.arrForGroup[i];
            if (countNumber == 0) {
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image3.hidden = NO;
                
            }else if(countNumber == 1){
                
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image4.hidden = NO;
                
            }else if(countNumber == 2){
                
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image5.hidden = NO;
            }
            
            countNumber ++;
            
        }
        
    }else{
        
        int countNumber = 0;
        for (int i = 0; i < self.arrForFriend.count; i ++) {
            
            FriendModel *model = self.arrForFriend[i];
            
            int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            if (model.fid == uid) {
                model.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            }
            if (i == 0) {
                
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image2.hidden = NO;
                
            }else if(i == 1){
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image3.hidden = NO;
                
            }else{
             
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                self.image4.hidden = NO;
                
            }
            
            countNumber ++;
            
            if (countNumber == 3) {
                
                break;
            }
            
        }
        
       
        
        for (int i = 0; i < self.arrForGroup.count; i++) {
            GroupModel *gModel = self.arrForGroup[i];
            if (countNumber == 0) {
                
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image2.hidden = NO;
                
            }else if(countNumber == 1){
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image3.hidden = NO;
                
            }else if(countNumber == 2){
             
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image4.hidden = NO;
            }
            
            countNumber ++;
            
        }
        
    }
}

/**
 *  创建内容栏
 */
#pragma mark -----
#pragma mark 图片选择、展示、删除
- (void)_createContentView
{
    
    int pageHeight =  pageForTitleAndFriend;
    if (self.model.upData) {
        pageHeight = 24;
    }
    //换肤
    JYSkinManager *manager = [JYSkinManager shareSkinManager];
    
    // 底部背景的view
    
//    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(xForTitle, self.viewForSelectFriend.bottom + pageForContentAndFriend, kScreenWidth - xForTitle * 2,heightForBgView)];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(xForTitle, pageHeight, kScreenWidth - xForTitle * 2,heightForBgView)];
    self.bgView.layer.cornerRadius = 3.0;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = lineColor.CGColor;
    self.bgView.layer.borderWidth = 0.5;
    [self.view addSubview:self.bgView];
    
    // 文本输入view
    
    self.contentView = [[JYContentTextView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.frame.size.width,heightForContent)];
    self.contentView.font = [UIFont systemFontOfSize:19];
    self.contentView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentView.scrollEnabled = YES;
    self.contentView.showsVerticalScrollIndicator = YES;
    self.contentView.delegate = self;
    [self.bgView addSubview:self.contentView];

    
    
    
//   __weak JYRemindViewController *vc = self;
 /*   [self.contentView setChangeFrame:^void(BOOL isEditOk){
    
        if (isEditOk) {
            
            //JYLog(@"内容正在编辑");
            [vc.titleField resignFirstResponder];

        }else{
        
            //JYLog(@"内容编辑完成");
//            [vc actionForContent:vc.contentView.text];
            
        }
    
    }];
    
*/
//    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGFrameMake(11, 480, 695, 1)];
     UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGFrameMake(11, 600 - 90, 695, 1)];
    lineLabel.backgroundColor = [UIColor colorWithCGColor:lineColor.CGColor];
    [self.bgView addSubview:lineLabel];
    
    
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.voiceBtn.frame = CGFrameMake(387, 500, 39, 39);
    self.voiceBtn.frame = CGFrameMake(387, 625 - 90, 39, 39);
    [self.voiceBtn setImage:manager.voiceImage forState:(UIControlStateNormal)];
    [self.bgView addSubview:self.voiceBtn];
    
    
    self.takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.takePhotoBtn.frame = CGFrameMake(515, 500, 39, 39);
    self.takePhotoBtn.frame = CGFrameMake(515, 625 - 90, 39, 39);
    [self.takePhotoBtn setImage:manager.cameraImage forState:(UIControlStateNormal)];
    [self.takePhotoBtn addTarget:self action:@selector(takePhotoBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:self.takePhotoBtn];
    
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.frame = CGFrameMake(637, 625 - 90, 39, 39);
    [self.locationBtn setImage:manager.locationImage forState:(UIControlStateNormal)];
    [self.locationBtn addTarget:self action:@selector(locationBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:self.locationBtn];

    
    
    self.contentView.text = self.model.content;
    self.folderPath = self.model.headUrlStr;
    
//    NSLog(@"当前城市:%@",self.model.localInfo);
//    NSLog(@"当前headStr:%@",self.model.headUrlStr);

    
    if (![self.model.headUrlStr isEqualToString:@""] && ![self.model.headUrlStr isKindOfClass:[NSNull class]] && ![self.model.headUrlStr isEqualToString:@"(null)"] && ![self.model.headUrlStr isEqualToString:@"<null>"] && self.model.headUrlStr != nil){
        
        NSArray * tmpArr = [self.model.headUrlStr componentsSeparatedByString:@","];
//        NSLog(@"tmpArray:%@",tmpArr);

        // 从网络获取
        if (self.model.uid != 0) {
  
            for (int i = 0; i < tmpArr.count; i ++) {
                
                if (![tmpArr[i] isEqualToString:@""]) {
                    
                    NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tmpArr[i]]];
                    UIImage * img = [UIImage imageWithData:imgData];
                    [self.imagesArray addObject:img];
                }    
            }
//            NSLog(@"self.ImageArray:%@",self.imagesArray);
            
        }else{
            
            // 从本地读取 
            // 获得此程序的沙盒路径            
            
            for (int i = 0; i < tmpArr.count; i ++) {
                
                NSString * fileStr = tmpArr[i];
                
                if (![fileStr isEqualToString:@""]) {
                    
                    // 存放文件路径会变，要重新获取
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *path = [paths objectAtIndex:0];
                    path = [path stringByAppendingPathComponent:@"img"];
                    NSArray *pathArray = [tmpArr[i] componentsSeparatedByString:@"/"];
                    NSString *folderStr = [pathArray objectAtIndex:pathArray.count-2];
                    NSString *imgStr = [pathArray lastObject];
                    NSString *imgPath = [NSString stringWithFormat:@"%@/%@/%@",path,folderStr,imgStr]; 

                    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath] == YES) {
                        
                        NSData * imgData = [NSData dataWithContentsOfFile:imgPath];
                        UIImage * img = [UIImage imageWithData:imgData];
                        [self.imagesArray addObject:img];
                        
                        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:imgPath error:nil] fileSize];
                        NSLog(@"audioRecorderDidFinishRecording====%fkb",fileSize/1024.f);
                    } 
                }      
            }   
        }     
    }    
    
    // 获取文本高度
    CGRect textLineHeight = [self.contentView.text boundingRectWithSize:CGSizeMake(kContentSizeW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.contentView.font} context:nil];
    
    self.textLineHeight = textLineHeight;
    
    if (self.imagesArray.count > 0) {
        
        [self createIconImageView:self.imagesArray];   
    }
    
    if (![self.model.localInfo isEqualToString:@""] && ![self.model.localInfo isKindOfClass:[NSNull class]] && ![self.model.localInfo isEqualToString:@"(null)"] && ![self.model.localInfo isEqualToString:@"<null>"] && self.model.localInfo != nil) {
        
        self.cityString = self.model.localInfo;
        [self createLocalView:self.cityString];
        [self changeLocalViewFrame];
   
    }

    
    [self changContentSize];
    
    //布局录音视图
    NSArray *urls = [self.model.audioPathStr componentsSeparatedByString:@","];
    NSArray *durations = [self.model.audioDurationStr componentsSeparatedByString:@","];
    
    for(int i=0;i<[urls count];i++){
        NSString *url = urls[i];
        NSNumber *duration;
        if(i<[durations count]){
            duration = durations[i];
        }
        if([url length]>0){
            AudioModel *audio = [AudioModel new];
            if([url hasPrefix:@"http"]){
                audio.remoteUrlPath = url;
            }else{
                audio.relativePath = url;
            }
            audio.duration = duration;
            [self.audios addObject:audio];
            
            VoiceBarView *voiceBar = [[VoiceBarView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:voiceBar];
            voiceBar.delegate = self;
            voiceBar.canEdit = YES;
            voiceBar.audio = audio;
            [self.voiceBars addObject:voiceBar];
            
        }
    }
    [self layoutVoiceBars];

}


-(void)takePhotoBtnAction:(UIButton *)sender
{
    
    if (self.addImageView.subviews.count == 8) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"照片最多可添加8张" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:self.view];
    }
}

-(void)locationBtnAction:(UIButton *)sender
{
    [self locateCity];
}

-(void)localDeleteBtnAction:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    self.localView = nil;
    self.cityString = @"";
    self.model.localInfo = @"";
    self.latitudeStr = @"0.000000";
    self.longitudeStr = @"0.000000";
    [self changContentSize];
    [self changeLocalViewFrame];

}

-(void)handwritingBtnAction:(UIButton *)sender
{
    
}
-(void)deletePhotosAction:(UIButton *)sender
{
    
    //图片删掉
//    [self.imagesArray removeObject:[(UIButton *)sender.superview imageForState:UIControlStateNormal]];
    
    if([sender.superview isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *)sender.superview;
        if([self.imagesArray containsObject:imageView.image]){
            [self.imagesArray removeObject:((UIImageView*)sender.superview).image];
        }
    }
//    NSLog(@"删掉图片:%@",self.imagesArray);
    
    [sender.superview removeFromSuperview];

    [self createIconImageView:self.imagesArray];
    
    [self changeLocalViewFrame];
    [self changContentSize];
    
}

/// 对所有图片子控件进行布局
- (void)layoutImageViews
{
    NSInteger count = self.addImageView.subviews.count;
    CGFloat btnW = 156/750.0*kScreenWidth;
    CGFloat btnH = kAddImgViewHeight1;
    int maxColumn = 4 > self.addImageView.frame.size.width / btnW ? self.addImageView.frame.size.width / btnW : 4;
    CGFloat marginX = (self.addImageView.frame.size.width - maxColumn * btnW) / (count + 1);
    CGFloat marginY = marginX;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.addImageView.subviews[i];
        CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
        CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }

}
/// 修改定位视图位置
-(void)changeLocalViewFrame
{
    
    if (!self.localView) {
        
        CGRect rect1 = self.addImageView.frame;
        rect1.origin.y = self.textLineHeight.size.height + kSpace;
        self.addImageView.frame = rect1;
        
    }else{
        
        CGRect rect1 = self.addImageView.frame;
        rect1.origin.y = self.localView.bottom + kSpace;
        self.addImageView.frame = rect1;
    }

}
/// 修改文字内容滚动区域
-(void)changContentSize
{
    
    if ((self.localView && !self.addImageView)) {
        
        CGSize newSize = CGSizeMake(kContentSizeW, self.localView.bottom + kSpace);
        [self.contentView setContentSize:newSize];
        
    }else if((self.localView && self.addImageView) || (!self.localView && self.addImageView)){
        
        CGSize newSize = CGSizeMake(kContentSizeW, self.addImageView.bottom + kSpace);
        [self.contentView setContentSize:newSize];
    
    }else if (!self.localView && !self.addImageView){
        
        CGSize newSize = CGSizeMake(kContentSizeW, self.textLineHeight.size.height + kSpace);
        [self.contentView setContentSize:newSize];
        
    }

    
        
                    

}

/// 添加图片视图
-(void)createIconImageView:(id)obj
{
    
    if (self.addImageView) {
        [self.addImageView removeFromSuperview];
        self.addImageView = nil;   
    }

    if ([obj isKindOfClass:[NSArray class]]) {
        
        if (self.imagesArray.count == 0) {
            return;
        }
        
        // 创建存放照片的数据
        self.addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, kContentViewW, kAddImgViewHeight1)];
        
        // 添加到定位视图下面
        if (self.localView) {
            
            CGRect rect = self.addImageView.frame;
            rect.origin.y = self.localView.bottom + kSpace;
            self.addImageView.frame = rect;
            
        }
        self.addImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.addImageView];
        
        
        NSInteger row,column;

        for (int i = 0; i < self.imagesArray.count; i ++) {
            
            row = i/kImageColumnCount;
            column = i%kImageColumnCount;
            
            UIImage * image = self.imagesArray[i];
            UIImageView * iconView = [[UIImageView alloc]init];
            iconView.frame = CGRectMake((kImageViewHeight+kImageHorMargin)*column,row*kImageRowHeight,kImageViewHeight,kImageViewHeight);
           iconView.tag = kImageViewBaseTag+i;
//            [iconView.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//            iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//            iconView.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;  
//            [iconView setImage:image forState:(UIControlStateNormal)];
            [self.addImageView addSubview:iconView];
            
            iconView.clipsToBounds = YES;
            iconView.contentMode = UIViewContentModeScaleAspectFill;
//            [iconView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
            iconView.image = image;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotoAction:)];
            iconView.userInteractionEnabled = YES;
            [iconView addGestureRecognizer:tap];
            
            // 删除按钮
            UIButton * deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            deleteBtn.frame = CGRectMake(iconView.size.width - 35/750.0*kScreenWidth, 0, 35/750.0*kScreenWidth, 35/1334.0*kScreenHeight);
            [deleteBtn addTarget:self action:@selector(deletePhotosAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [deleteBtn setImage:[UIImage imageNamed:@"deletePhoto"] forState:(UIControlStateNormal)];
            [iconView addSubview:deleteBtn];

            [self.addImageView insertSubview:iconView atIndex:self.addImageView.subviews.count - 1];
            
            // 添加第二排时需要改变addImageView的大小
            if (self.addImageView.subviews.count > 4) {
                
                CGRect rect = self.addImageView.frame;
                rect.size.height = kAddImgViewHeight2;
                self.addImageView.frame = rect;
                
            }
            
        }
        
    }
}

/// 创建定位视图
-(void)createLocalView:(NSString *)cityString
{
    // 定位视图最大宽、高
    CGFloat labelWidth = 560/750.0*kScreenWidth;
//    CGFloat labelWidth = self.contentView.contentSize.width-6*kHorSpace;
//    CGFloat labelHeight = 30/1334.0*kScreenHeight;
    CGFloat labelHeight = 25.f;
    
    // 计算定位城市文本高度
    CGRect cityLabelHeight = [cityString boundingRectWithSize:CGSizeMake(MAXFLOAT,labelHeight) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    self.cityLabelRect = cityLabelHeight;
    
    if (self.localView) {
        [self.localView removeFromSuperview];
    }
    
    self.localView = [[UIView alloc]init];
    self.localView.frame = CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, 550/750.0*kScreenWidth, 50/1334.0*kScreenHeight);
    
//    if (self.addImageView) {
//        
//        CGRect rect = self.localView.frame;
//        rect.origin.y = self.addImageView.bottom + kSpace;
//        self.localView.frame = rect;
//        
//    }
    [self.contentView addSubview:self.localView];
    self.localView.layer.masksToBounds = YES;
    self.localView.layer.cornerRadius = self.localView.size.height/2.0;
    self.localView.layer.borderColor = lineColor.CGColor;
    self.localView.layer.borderWidth = 1;    
    
    
    CGFloat space = 11/750.0*kScreenWidth;// 间隔宽度
//    CGFloat curY = 11/1334.0*kScreenHeight;// 距离上部高度
//    CGFloat curH = 30.0/1334.0*kScreenHeight;// label的frame高度
    
    UIImageView * iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(space, 13/1334.0*kScreenHeight, 20/750.0*kScreenWidth, 26/1334.0*kScreenHeight);
    iconView.image = [UIImage imageNamed:@"findLocal"];
    [self.localView addSubview:iconView];
    self.localIconView = iconView;
    
    UILabel * locallLabel = [[UILabel alloc]init];
    if (cityLabelHeight.size.width >= labelWidth) {
        // 如果当前长度大于 最大定位地址长度
        locallLabel.frame = CGRectMake(iconView.right + space, (self.localView.height-labelHeight)/2, labelWidth, labelHeight);
    }else{
        locallLabel.frame = CGRectMake(iconView.right + space, (self.localView.height-labelHeight)/2, cityLabelHeight.size.width, labelHeight);
    }
    locallLabel.numberOfLines = 0;
    locallLabel.text = cityString;
    locallLabel.font = [UIFont systemFontOfSize:14];
    locallLabel.textColor = [UIColor colorWithRed:91.0/255.0 green:133.0/255.0 blue:179.0/255.0 alpha:1];
//    locallLabel.textAlignment = NSTextAlignmentCenter;
    [self.localView addSubview:locallLabel];
    self.localLabelView = locallLabel;
    
    locallLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(localLabelTapped:)];
    [locallLabel addGestureRecognizer:tap];
    
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(locallLabel.right + 17/750.0*kScreenWidth, 0, 2/750.0*kScreenWidth, self.localView.size.height);
    lineLabel.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [self.localView addSubview:lineLabel];
    self.localVerLineView = lineLabel;
    
    UIButton * delBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    delBtn.frame = CGRectMake(lineLabel.right + 10/750.0*kScreenWidth, 18/1334.0*kScreenHeight, 18/750.0*kScreenWidth, 18/1334.0*kScreenHeight);
    [delBtn setImage:[UIImage imageNamed:@"deleteLocation"] forState:(UIControlStateNormal)];
    [delBtn addTarget:self action:@selector(localDeleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.localView addSubview:delBtn];
    self.localDeleteBtn = delBtn;
    
    CGRect rect = self.localView.frame;
    rect.size.width = delBtn.right + 17/750.0*kScreenWidth;
    self.localView.frame = rect;
    
    NSLog(@"定位视图的宽度：%.f",delBtn.right);
    
    NSLog(@"定位城市:%@",cityString);
}

/**
 * 版本 4.1.1 修改为点击进入地图展示页面 change by zhangjing
 */
#pragma mark 点击定位label 进入地图展示页面
- (void)localLabelTapped:(UITapGestureRecognizer *)tap
{
    
    MapViewController *map = [[MapViewController alloc]init];
    map.address = self.cityString;
    map.latitudeStr = self.latitudeStr;
    map.longitudeStr = self.longitudeStr;
    
    [self presentViewController:map animated:YES completion:nil];
    
    // 获取定位城市
    __weak JYRemindViewController *weakSelf = self;
    [map setActionForGetLocationString:^(NSString *cityString, CLLocationCoordinate2D remindLoc) {
        
        if (![cityString isEqualToString:@""]) {
            weakSelf.cityString = cityString;
            [weakSelf createLocalView:cityString];
            [weakSelf changeLocalViewFrame];
            [weakSelf changContentSize];
            weakSelf.latitudeStr = [NSString stringWithFormat:@"%f",remindLoc.latitude];
            weakSelf.longitudeStr = [NSString stringWithFormat:@"%f",remindLoc.longitude];
            
        }
        NSLog(@"经度%.f 纬度%.f",remindLoc.latitude,remindLoc.longitude);
        
    }];


}
#pragma mark 点击定位label显示不全的显示全
/*
- (void)localLabelTapped:(UITapGestureRecognizer *)tap
{
    // 定位视图最大宽、高
    CGFloat labelWidth = 560/750.0*kScreenWidth;
//    CGFloat labelWidth = self.contentView.contentSize.width-6*kHorSpace;
    CGFloat labelHeight = 40/1334.0*kScreenHeight;
    
    if(self.cityLabelRect.size.width>labelWidth){
        //重新layout定位视图 frame计算copy自上面
        
        CGFloat newHeight =  ceilf(self.cityLabelRect.size.width / labelWidth) * labelHeight;
        self.localView.frame = CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, 550/750.0*kScreenWidth, 50/1334.0*kScreenHeight+newHeight-labelHeight);
        
        self.localView.layer.masksToBounds = YES;
        self.localView.layer.cornerRadius = self.localView.size.height/2.0;
        self.localView.layer.borderColor = lineColor.CGColor;
        self.localView.layer.borderWidth = 1;
        CGFloat space = 11/750.0*kScreenWidth;// 间隔宽度
        self.localLabelView.frame = CGRectMake(self.localIconView.right + space, (self.localView.frame.size.height -newHeight)/2, labelWidth, newHeight);
        CGFloat iconHeight = 26/1334.0*kScreenHeight;
        self.localIconView.frame = CGRectMake(space, (self.localView.size.height-iconHeight)/2, 20/750.0*kScreenWidth, iconHeight);
        self.localVerLineView.frame = CGRectMake(self.localLabelView.right + 17/750.0*kScreenWidth, 0, 2/750.0*kScreenWidth, self.localView.size.height);
        CGFloat delBtnHeight = 18/1334.0*kScreenHeight;
        self.localDeleteBtn.frame =  CGRectMake(self.localVerLineView.right + 10/750.0*kScreenWidth, (self.localView.size.height-delBtnHeight)/2.f, 18/750.0*kScreenWidth, delBtnHeight);
        CGRect rect = self.localView.frame;
        rect.size.width = self.localDeleteBtn.right + 17/750.0*kScreenWidth;
        self.localView.frame = rect;
        
        self.localLabelView.text = self.cityString;
        [self.localLabelView setNeedsDisplay];
        
        rect = self.addImageView.frame;
        rect.origin.y = self.localView.bottom + kSpace;
        self.addImageView.frame = rect;

        [self changContentSize];
    }
}
*/
#pragma mark ---

- (void)textFieldDidChange:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField.tag == kTextFieldTag) {
        
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > kMaxTextLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxTextLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:kMaxTextLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxTextLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

#pragma mark textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.titleField){
        [textField resignFirstResponder];
        [self.contentView becomeFirstResponder];
    }
    return NO;
}
#pragma mark textView代理方法

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    // 取消换行符
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
//        self.contentView.changeFrame(NO);
        return NO;
    }

    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    // 获取文本高度
    CGRect textLineHeight = [textView.text boundingRectWithSize:CGSizeMake(kContentSizeW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.contentView.font} context:nil];
    self.textLineHeight = textLineHeight;

    // 重新修改位置
    CGRect rect = self.localView.frame;
    rect.origin.y = textLineHeight.size.height + kSpace;
    self.localView.frame = rect;
    
    // 修改定位视图位置
    [self changeLocalViewFrame]; 
    [self changContentSize];
    
    LocalListManager *manager = [LocalListManager shareLocalListManager];
    self.rememberTB.modelArr =  [manager searchDateWithContentStr:textView.text];
    self.rememberTB.frame = CGRectMake(xForTitle + 1,rect.origin.y + 20, kScreenWidth - xForTitle * 2 - 2, heightForBgView - rect.origin.y - 39 / 1334.0 * kScreenHeight - 20 - 1);
    [self.rememberTB reloadData];

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"end");
    self.rememberTB.hidden = YES;
    self.rememberTB.modelArr = nil;
   
}

#pragma mark列表代理方法

/**
 *  创建选择表格
 */
- (void)_createTableView
{
    self.remindTb = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bgView.bottom + 10, kScreenWidth, kScreenHeight - (self.bgView.bottom + 10 + 20 + 44)) style:UITableViewStylePlain];
    self.remindTb.delegate = self;
    self.remindTb.dataSource = self;
    self.remindTb.rowHeight = 44;
    self.remindTb.tableHeaderView = self.viewForSelectFriend;
    self.remindTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:self.remindTb atIndex:100];
    [self.remindTb registerClass:[JYRemindCell class] forCellReuseIdentifier:strForRemindCell];
    [Tool actionForHiddenMuchTable:self.remindTb];

    UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    viewForLine.backgroundColor = lineColor;
    [self.remindTb addSubview:viewForLine];
//
    UIView *viewForLine1 = [[UIView alloc] initWithFrame:CGRectMake(0,44-0.5, kScreenWidth, 0.5)];
    viewForLine1.backgroundColor = lineColor;
    [self.remindTb addSubview:viewForLine1];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (IS_IPHONE_4_SCREEN) {
//        if (indexPath.row < 3) {
//            return heightForCc;
//        }else{
//            return heightForCc + 5;
//        }
//    }else{
//        return heightForCc;
//    }
    
    return 44;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JYRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:strForRemindCell];

    if (!cell) {
        cell = [[JYRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForRemindCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 4) {
        
        cell.switchBtn.hidden = NO;
        cell.nextLabel.hidden = YES;
        cell.arrowHead.hidden = YES;

        if (self.model.isOn) {
            cell.titleLabel.text = @"提醒";
            cell.switchBtn.on = YES;
        }else{
            cell.titleLabel.text = @"关闭";
            cell.switchBtn.on = NO;
        }

    }else{
      
        cell.switchBtn.hidden = YES;
        cell.nextLabel.hidden = NO;
        cell.arrowHead.hidden = NO;

        if (indexPath.row == 0) {

            NSString *yearStr = [NSString stringWithFormat:@"%d",self.model.year];
            NSString *nowYear = [yearStr substringWithRange:NSMakeRange(2, 2)];
            NSString *nowHour = [Tool actionForTenOrSingleWithNumber:self.model.hour];
            NSString *nowMinute = [Tool actionForTenOrSingleWithNumber:self.model.minute];
            
            NSString *nowWeek = [Tool actionForWeekWithYear:self.model.year month:self.model.month day:self.model.day];
            
            cell.nextLabel.text = [NSString stringWithFormat:@"%@/%d/%d（%@）%@:%@",nowYear,self.model.month,self.model.day,nowWeek,nowHour,nowMinute];
            
            cell.titleLabel.text = self.strForTitle;
            
   
        }else if(indexPath.row == 1){
        
            cell.titleLabel.text = @"重复";
            if (self.model.randomType) {
    
                cell.nextLabel.text = self.model.strForRepeat;                
                
            }else{
                
                cell.nextLabel.text = @"永不";
            }
            
        }else if(indexPath.row == 2){
        
            cell.titleLabel.text = @"铃声选择";

            if (self.model.musicName == 0) {
                
                cell.nextLabel.text = @"铃声关闭";
                
            }else{
                
                cell.nextLabel.text = self.musicArr[self.model.musicName - 1];
                
            }
            
        }else if(indexPath.row == 3){
        
            cell.titleLabel.text = @"正点提醒";
            NSString *nextLabeltext;
            if (self.model.offsetMinute <= 30) {
                nextLabeltext = [NSString stringWithFormat:@"%ld分钟前",self.model.offsetMinute];
            }else{
                nextLabeltext = [NSString stringWithFormat:@"%ld小时前",self.model.offsetMinute / 60];
            }
            
            if (self.model.offsetMinute == 0) {
                cell.nextLabel.text = @"";
            }else{
                cell.nextLabel.text = nextLabeltext;
            }
            
        }
    }
    
    //判断开启或关闭提醒的按钮
    __weak typeof(self) ws = self;
    [cell setSwitchAction:^void(UISwitch *btn){
    
        [ws openAction:btn];
    
    }];
    
    return cell;
}

-(void)tapPhotoAction:(UIButton *)sender
{
    //    _scaleImg = [(UIButton *)sender imageForState:UIControlStateNormal];
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.hideSaveButton = YES;
    browser.sourceImagesContainerView = self.addImageView;
    browser.imageCount = [self.imagesArray count];
    browser.currentImageIndex = gesture.view.tag-kImageViewBaseTag;
    browser.delegate = self;
    [browser show];
}
#pragma mark - SDPhotoBrowserDelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imgView = [self.addImageView viewWithTag:index+kImageViewBaseTag];
    if([imgView isKindOfClass:[UIImageView class]]){
        UIImage *image = imgView.image;
        return image;
    }else{
        return [UIImage imageNamed:@"相册默认图片"];
    }
}

#pragma mark tabelDataAction
/////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 0) {
        
        //JYLog(@"日期选择");
        [self calendarAction];
        
    }else if(indexPath.row == 1){

    
        //JYLog(@"是否重复");
        [self repeatAction];

    }else if(indexPath.row == 2){
    
        //JYLog(@"铃声选择");
        [self musicAction];
        
    }else if(indexPath.row == 3){
    
        NSLog(@"正点提醒");
        [self _createZhengdianTB];
    }
 
}

- (void)_createZhengdianTB
{
    
    JYZhengdianTimes *zdVC = [JYZhengdianTimes new];
    zdVC.model = self.model;
    
    [self.navigationController pushViewController:zdVC animated:YES];
    
    __weak typeof(self) weekSelf = self;
    [zdVC setPopBlock:^{
        [weekSelf.remindTb reloadData];
    }];
}


- (void)actionForCancel:(UIButton *)sender
{
    
    [self calendarAction];
}

/**
 *  创建年、月、日datepicker
 */
- (void)_createDatePickerForYearAndMonth
{
   
    CGFloat heightForTopView = 100;
    CGFloat yForTopView = 300;
    
    CGFloat pageForLabel = 0;
    
    CGFloat xForColon = 0;
    CGFloat yForColon = 0;
    
    if (IS_IPHONE_4_SCREEN) {
        
    
        
        heightForTopView = 50;
        yForTopView = 245;
        
        xForColon = 266;
        yForColon = 348;
        
        pageForLabel = 10;
        
    }else if(IS_IPHONE_5_SCREEN){
     
        
       NSString *strFord = [JYFontManager  getCurrentDeviceModel];
        NSInteger Type = [JYFontManager returnType:strFord];
        
        if (Type == Type_iPhone5) {
           
        
            
            heightForTopView = 50;
            yForTopView = 310;
            
            pageForLabel = 10;
            
            xForColon = 266;
            yForColon = 427;
            
        }else{
         
    
            
            heightForTopView = 50;
            yForTopView = 300;
            
            pageForLabel = 0;
            
            xForColon = 266;
            yForColon = 424;
        }
        
       
        
    }else if(IS_IPHONE_6_SCREEN){
     
       

        
        heightForTopView = 50;
        yForTopView = 396;
        
        xForColon = 310;
        yForColon = 519;
        
    }else if(IS_IPHONE_6P_SCREEN){
     
        
        
        heightForTopView = 50;
        yForTopView = 483;
        
        xForColon = 338;
        yForColon = 596;
    }
    
    
    AppDelegate *delet = [UIApplication  sharedApplication].delegate;
    
    self.yearAndMinuteView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, kScreenHeight)];
    self.yearAndMinuteView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [delet.window addSubview:self.yearAndMinuteView];
 
   
    
    self.jyAllPicker = [[JYPickerViewForRemind alloc] initWithFrame:CGRectMake(0, 0 , kScreenWidth, 300)];
    
    self.jyAllPicker.backgroundColor = [UIColor whiteColor];
    
   
    
    [self.yearAndMinuteView addSubview:self.jyAllPicker];
    
    //加大取消按钮点击区域
    UIButton *btnForCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.jyAllPicker.height - heightForCc)];
    //btnForCancel.backgroundColor = [UIColor orangeColor];
    [btnForCancel addTarget:self action:@selector(actionForCancelNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.yearAndMinuteView addSubview:btnForCancel];
    
    self.jyAllPicker.year = self.model.year;
    self.jyAllPicker.month = self.model.month;
    self.jyAllPicker.day = self.model.day;
    self.jyAllPicker.hour = self.model.hour;
    self.jyAllPicker.minute = self.model.minute;
    
    [self.jyAllPicker reloadAllComponents];
    
    //初始化一下datepicker数据
    [self.jyAllPicker selectRow:self.model.year  - 2015 inComponent:0 animated:YES];
    [self.jyAllPicker selectRow:(self.model.month  - 1) * 13 inComponent:1 animated:YES];
    [self.jyAllPicker selectRow:self.model.day - 1 inComponent:2 animated:YES];
    [self.jyAllPicker selectRow:self.model.hour   inComponent:3 animated:YES];
    [self.jyAllPicker selectRow:self.model.minute  inComponent:4 animated:YES];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:topView];
    
    self.labelForLunar = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 200, 20)];
    self.labelForLunar.text = @"农历";
    self.labelForLunar.textColor = [UIColor grayColor];
    self.labelForLunar.userInteractionEnabled = YES;
    //self.labelForLunar.font = [UIFont systemFontOfSize:15];
    [topView addSubview:self.labelForLunar];
    
    self.btnForLunar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnForLunar addTarget:self action:@selector(actionForLunar:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnForLunar setImage:[UIImage imageNamed:@"农选中.png"] forState:UIControlStateSelected];
    [self.btnForLunar setImage:[UIImage imageNamed:@"农未选中.png"] forState:UIControlStateNormal];
    self.btnForLunar.frame = CGRectMake(60, 21, 15.5, 15.5);
    [topView addSubview:self.btnForLunar];
    
    UIButton *btnForBigLunar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.labelForLunar.width, 20)];
    [btnForBigLunar addTarget:self action:@selector(actionForLunar:) forControlEvents:UIControlEventTouchUpInside];
    [self.labelForLunar addSubview:btnForBigLunar];
    
    self.btnForTodayRemind = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - 40, 18, 40, 20)];
    self.btnForTodayRemind.backgroundColor = [UIColor whiteColor];
    [self.btnForTodayRemind addTarget:self action:@selector(actionForBackToday:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.btnForTodayRemind];
    
    //加大今天点击面积
    UIButton *btnForToday = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 100, yForTopView, 100, 50)];
    //btnForToday.backgroundColor = [UIColor orangeColor];
    [btnForToday addTarget:self action:@selector(actionForBackToday:) forControlEvents:UIControlEventTouchUpInside];
    [self.yearAndMinuteView addSubview:btnForToday];
    

    
    self.labelFotTodayRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.labelFotTodayRemind.textColor = [UIColor grayColor];
    self.labelFotTodayRemind.textAlignment = NSTextAlignmentCenter;
    self.labelFotTodayRemind.text = @"今";
    self.labelFotTodayRemind.textAlignment = NSTextAlignmentRight;
    //self.labelFotTodayRemind.backgroundColor = [UIColor orangeColor];
    [topView addSubview:self.labelFotTodayRemind];
    
    [btnForToday mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50.f);
        make.width.mas_equalTo(100.f);
        make.top.equalTo(topView.mas_top);
        make.right.equalTo(topView.mas_right);
        
    }];
    
    [self.labelFotTodayRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).offset(15.f);
        make.right.equalTo(topView.mas_right).offset(-20.f);
        
    }];
    
    [self.btnForTodayRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).offset(15.f);
        make.right.equalTo(topView.mas_right).offset(-20.f);
        
    }];
    
    [self.labelForLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).offset(15.f);
        make.left.equalTo(topView.mas_left).offset(20.f);
        
        
    }];
    
    [self.btnForLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).offset(18.f);
        make.left.equalTo(self.labelForLunar.mas_right).offset(3.f);
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
        
    }];
    
  
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50.f);
        make.bottom.equalTo(self.jyAllPicker.mas_top);
        make.left.equalTo(self.jyAllPicker.mas_left);
        make.right.equalTo(self.jyAllPicker.mas_right);
        
    }];
    
    
    
    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth = [[Tool actionForNowMonth:nil] intValue];
    int nowDay = [[Tool actionForNowSingleDay:nil] intValue];
    
   
    

    
    //传值方法
    [self actionForPassYear_Month_day_hour_minute];
    
    //确认取消按钮
    [self createConfirmBtn];
    
    
    UILabel *maohao = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    maohao.text = @":";
    [self.jyAllPicker addSubview:maohao];
    CGFloat _nowWidth = kScreenWidth / 5.0;
     [maohao mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.right.equalTo(self.jyAllPicker.mas_right).offset(-_nowWidth * (3 / 4.0) - 5);
         make.top.equalTo(self.jyAllPicker.mas_centerY).offset(-11.f);
         
     }];
    
    if (nowDay == self.model.day && nowMonth == self.model.month && nowYear == self.model.year) {
        
        self.labelFotTodayRemind.textColor = [UIColor redColor];
        
    }else{
     
        self.labelFotTodayRemind.textColor = [UIColor grayColor];
    }
}

//改变今天Label的颜色
- (void)actionForChangeTodayLabelColor:(BOOL)isRed
{
 
    if (isRed) {
        
        self.labelFotTodayRemind.textColor = [UIColor redColor];
        
    }else{
     
        self.labelFotTodayRemind.textColor = [UIColor grayColor];

    }

}

- (void)actionForIsNowDay
{
 
    if (self.jyAllPicker.isLunar) {
        
        //转换，在对等
        [self actionForLunarToSolar];

    }

    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth = [[Tool actionForNowMonth:nil] intValue];
    int nowDay = [[Tool actionForNowSingleDay:nil] intValue];
    
    if (self.jyAllPicker.year == nowYear && self.jyAllPicker.month == nowMonth && self.jyAllPicker.day == nowDay) {
        
        [self actionForChangeTodayLabelColor:YES];
        
    }else{
     
        [self actionForChangeTodayLabelColor:NO];
    }
    
    [self confirmAction];
    
}



//返回今天
- (void)actionForBackToday:(UIButton *)sender
{
    
    self.labelFotTodayRemind.textColor = [UIColor redColor];
    
        int nowYear = [[Tool actionForNowYear:nil] intValue];
        int nowMonth = [[Tool actionForNowMonth:nil] intValue];
        int nowDay = [[Tool actionForNowSingleDay:nil] intValue];
//        int nowHour = [[Tool actionforNowHour] intValue];
//        int nowMinute = [[Tool actionforNowMinute] intValue];
    
        self.jyAllPicker.year = nowYear;
        self.jyAllPicker.month = nowMonth;
        self.jyAllPicker.day = nowDay;
//        self.jyAllPicker.hour = nowHour;
//        self.jyAllPicker.minute = nowMinute;
    
    [self actionForSolarToLunar];
    
    if (self.isLunar) {
        
        self.labelForLunar.textColor = [UIColor redColor];
        
        [self actionForSolarToLunar];
        
        self.jyAllPicker.isLunar = YES;
        
        [self.jyAllPicker reloadAllComponents];
        
        NSArray *arrForMonthName = [LunarModel arrForLunarMonth:self.jyAllPicker.lunarYear];
        int indexForRun = 0;
        //闰月情况特殊
        if (arrForMonthName.count == 13) {
            
            for (int i = 0;  i< 13; i ++) {
                
                NSString *monthStr = arrForMonthName[i];
                NSString *runStr = [monthStr substringWithRange:NSMakeRange(0, 1)];
                
                if ([runStr isEqualToString:@"闰"]) {
                    
                    indexForRun = i;
                    break;
                }
            }
            
            if (self.jyAllPicker.lunarMonth > indexForRun) {
                
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
                
            }else if(self.jyAllPicker.lunarMonth == indexForRun && self.jyAllPicker.isLeap == YES){
                
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
                
            }else{
                
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
            }
            
        }else{
            
            [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
        }
        
        
        [self.jyAllPicker selectRow:self.jyAllPicker.lunarYear - 2015  inComponent:0 animated:NO];
        
        [self.jyAllPicker selectRow:self.jyAllPicker.lunarDay - 1 inComponent:2 animated:NO];
        

        
    }else{
     
        self.labelFotTodayRemind.textColor = [UIColor redColor];
        [self.jyAllPicker selectRow:nowYear  - 2015 inComponent:0 animated:NO];
        [self.jyAllPicker selectRow:(nowMonth  - 1) * 13 inComponent:1 animated:NO];
        [self.jyAllPicker selectRow:nowDay - 1 inComponent:2 animated:NO];
//        [self.jyAllPicker selectRow:nowHour   inComponent:3 animated:NO];
//        [self.jyAllPicker selectRow:nowMinute  inComponent:4 animated:NO];
    }
    
    [self.jyAllPicker reloadAllComponents];
        
 
    
}

//阳历转换成阴历
- (void)actionForSolarToLunar
{
 
    Solar *solar = [[Solar alloc] init];
    
    solar.solarYear = self.jyAllPicker.year;
    solar.solarMonth = self.jyAllPicker.month;
    solar.solarDay = self.jyAllPicker.day;
    
    Lunar *lunar = [LunarSolarConverter solarToLunar:solar];
    
    self.jyAllPicker.lunarYear = lunar.lunarYear;
    self.jyAllPicker.lunarMonth = lunar.lunarMonth;
    self.jyAllPicker.lunarDay = lunar.lunarDay;
    
    //是否是闰月
    self.jyAllPicker.isLeap = lunar.isleap;
    
    
}

//阴历转换成阳历
- (void)actionForLunarToSolar
{
 
    Lunar *lunar = [[Lunar alloc] init];
    
    lunar.lunarYear = self.jyAllPicker.lunarYear;
    lunar.lunarMonth = self.jyAllPicker.lunarMonth;
    lunar.lunarDay = self.jyAllPicker.lunarDay;
    lunar.isleap = self.jyAllPicker.isLeap;
    
    Solar *solar = [LunarSolarConverter lunarToSolar:lunar];
    
    self.jyAllPicker.year = solar.solarYear;
    self.jyAllPicker.month = solar.solarMonth;
    self.jyAllPicker.day = solar.solarDay;
    
    
}

//阴阳历转换方法
- (void)actionForLunar:(UIButton *)sender
{
 
    self.btnForLunar.selected = !self.btnForLunar.selected;
    
    self.isLunar = !self.isLunar;
    
    if (self.isLunar) {
        
        self.labelForLunar.textColor = [UIColor redColor];
        
        [self actionForSolarToLunar];
        
        self.jyAllPicker.isLunar = YES;
        
        [self.jyAllPicker reloadAllComponents];
        
        NSArray *arrForMonthName = [LunarModel arrForLunarMonth:self.jyAllPicker.lunarYear];
        int indexForRun = 0;
        //闰月情况特殊
        if (arrForMonthName.count == 13) {
            
            for (int i = 0;  i< 13; i ++) {
                
                NSString *monthStr = arrForMonthName[i];
                NSString *runStr = [monthStr substringWithRange:NSMakeRange(0, 1)];
                
                if ([runStr isEqualToString:@"闰"]) {
                    
                    indexForRun = i;
                    break;
                }
            }
            
            if (self.jyAllPicker.lunarMonth > indexForRun) {
                
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
                
            }else if(self.jyAllPicker.lunarMonth == indexForRun && self.jyAllPicker.isLeap == YES){
            
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
                
            }else{
             
                    [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
            }
            
        }else{
         
                [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
        }
        
        
        [self.jyAllPicker selectRow:self.jyAllPicker.lunarYear - 2015  inComponent:0 animated:NO];
      
        [self.jyAllPicker selectRow:self.jyAllPicker.lunarDay - 1 inComponent:2 animated:NO];
        
    }else{
     
        self.labelForLunar.textColor = [UIColor grayColor];

        [self actionForLunarToSolar];
        
        self.jyAllPicker.isLunar = NO;
        
        [self.jyAllPicker reloadAllComponents];
        
        [self.jyAllPicker selectRow:self.jyAllPicker.year - 2015  inComponent:0 animated:NO];
        [self.jyAllPicker selectRow:self.jyAllPicker.month - 1 inComponent:1 animated:NO];
        [self.jyAllPicker selectRow:self.jyAllPicker.day - 1 inComponent:2 animated:NO];

    }
    
}

- (void)createConfirmBtn
{
 
    
    CGFloat nowHeight = 50;
    if (IS_IPHONE_6P_SCREEN) {
        
        nowHeight = 50;
    }
    
    UIButton *btnForCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - nowHeight, kScreenWidth / 2.0 - 0.25, nowHeight)];
    [btnForCancel addTarget:self action:@selector(actionForCancelNow:) forControlEvents:UIControlEventTouchUpInside];
    btnForCancel.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:btnForCancel];
    
    UILabel *labelForCancel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnForCancel.width, btnForCancel.height)];
    labelForCancel.text = @"取消";
    labelForCancel.textAlignment = NSTextAlignmentCenter;
    labelForCancel.textColor = grayTextColor;
    [btnForCancel addSubview:labelForCancel];
    
    
  
    

    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 0.25, btnForCancel.top, 0.5, nowHeight)];
    centerView.backgroundColor = lineColor;
    [self.yearAndMinuteView addSubview:centerView];
    
    UIButton *btnForConfirm = [[UIButton alloc] initWithFrame:CGRectMake(centerView.right, kScreenHeight - nowHeight, kScreenWidth / 2.0 - 0.25, nowHeight)];
    [btnForConfirm addTarget:self action:@selector(actionForConfirmNow:) forControlEvents:UIControlEventTouchUpInside];
    btnForConfirm.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:btnForConfirm];
   
    UILabel *labelForConfirm = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnForConfirm.width, btnForConfirm.height)];
    labelForConfirm.text = @"完成";
    labelForConfirm.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    labelForConfirm.textAlignment = NSTextAlignmentCenter;
    [btnForConfirm addSubview:labelForConfirm];
    
    [self.jyAllPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(btnForConfirm.mas_top);
        make.right.equalTo(btnForConfirm.mas_right);
        make.left.equalTo(btnForCancel.mas_left);
    }];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, btnForCancel.top, kScreenWidth, 0.5)];
    topView.backgroundColor = lineColor;
    [self.yearAndMinuteView addSubview:topView];
    
    

    
}

- (void)confirmAction{
    
    
    if (self.confirm) {
        if (self.jyAllPicker.isLunar) {
            
            //转换，在对等
            [self actionForLunarToSolar];
            
            self.model.year = self.jyAllPicker.year;
            self.model.month = self.jyAllPicker.month;
            self.model.day = self.jyAllPicker.day;
            self.model.hour = self.jyAllPicker.hour;
            self.model.minute = self.jyAllPicker.minute;
            
        }else{
            
            self.model.year = self.jyAllPicker.year;
            self.model.month = self.jyAllPicker.month;
            self.model.day = self.jyAllPicker.day;
            self.model.hour = self.jyAllPicker.hour;
            self.model.minute = self.jyAllPicker.minute;
        }
        
        //刷新
        [self.remindTb reloadData];
        self.confirm = NO;
    }else{
    
    }

}

- (void)actionForConfirmNow:(UIButton *)sender
{
    self.confirm = YES;
    
    if (self.jyAllPicker.isLunar) {
        
        //转换，在对等
        [self actionForLunarToSolar];
        
        self.model.year = self.jyAllPicker.year;
        self.model.month = self.jyAllPicker.month;
        self.model.day = self.jyAllPicker.day;
        self.model.hour = self.jyAllPicker.hour;
        self.model.minute = self.jyAllPicker.minute;
        
    }else{
        
        self.model.year = self.jyAllPicker.year;
        self.model.month = self.jyAllPicker.month;
        self.model.day = self.jyAllPicker.day;
        self.model.hour = self.jyAllPicker.hour;
        self.model.minute = self.jyAllPicker.minute;
    }
    
    
    
    //收回面板
    [self calendarAction];
    
    //刷新
    [self.remindTb reloadData];
}

- (void)actionForCancelNow:(UIButton *)sender
{
 
    //只收回面板不刷新
    [self calendarAction];

}

//传值
- (void)actionForPassYear_Month_day_hour_minute
{
 
    __weak JYRemindViewController *jyVC = self;
    [self.jyAllPicker setActionForYear:^(int year) {
        

        [jyVC actionForIsNowDay];
        
    }];
    
    [self.jyAllPicker setActionForMonth:^(int month) {
        
        [jyVC actionForIsNowDay];
        
        
        //[jyVC.jyAllPicker reloadAllComponents];
        
        [jyVC.jyAllPicker selectRow:jyVC.jyAllPicker.year - 2015  inComponent:0 animated:NO];
        [jyVC.jyAllPicker selectRow:jyVC.jyAllPicker.month - 1 inComponent:1 animated:NO];
        [jyVC.jyAllPicker selectRow:jyVC.jyAllPicker.day - 1 inComponent:2 animated:NO];

    }];
    
    [self.jyAllPicker setActionForDay:^(int day) {
        
        [jyVC actionForIsNowDay];

    }];
    
    
    [self.jyAllPicker setActionForHour:^(int hour) {
        
        [jyVC actionForIsNowDay];

        
    }];
    
    
    [self.jyAllPicker setActionForMinute:^(int minute) {
       

    }];
    
    [self.jyAllPicker setActionForLunarYear:^(int lunarYear) {
        

        [jyVC changeAction];
        
        [jyVC actionForIsNowDay];

    }];
    
    [self.jyAllPicker setActionForLunarMonth:^(int lunarMonth) {
        
        
        //[jyVC.jyAllPicker selectRow:jyVC.jyAllPicker.lunarDay inComponent:2 animated:NO];
        
        [jyVC actionForIsNowDay];

    }];
    
    [self.jyAllPicker setActionForLunarDay:^(int lunarDay) {
        
        [jyVC actionForIsNowDay];
        
    }];
    
}

- (void)changeAction
{
 
    NSArray *arrForMonthName = [LunarModel arrForLunarMonth:self.jyAllPicker.lunarYear];
    int indexForRun = 0;
    //闰月情况特殊
    if (arrForMonthName.count == 13) {
        
        for (int i = 0;  i< 13; i ++) {
            
            NSString *monthStr = arrForMonthName[i];
            NSString *runStr = [monthStr substringWithRange:NSMakeRange(0, 1)];
            
            if ([runStr isEqualToString:@"闰"]) {
                
                indexForRun = i;
                break;
            }
        }
        
        if (self.jyAllPicker.lunarMonth > indexForRun) {
            
            [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
            
        }else if(self.jyAllPicker.lunarMonth == indexForRun && self.jyAllPicker.isLeap == YES){
            
            [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth inComponent:1 animated:NO];
            
        }else{
            
            [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
        }
        
    }else{
        
        [self.jyAllPicker selectRow:self.jyAllPicker.lunarMonth - 1 inComponent:1 animated:NO];
    }
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        // 拍照
        __weak typeof(self) ws = self;
        [[CamerManager shareInstance] showCameraWithBlock:^{
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = ws;
            [ws presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }];
        
    }else if(buttonIndex==1){
        
        __weak typeof(self) ws = self;
        [[CamerManager shareInstance] showPhotoLibraryWithBlock:^{
     
            JYBatchSelectionVC *imageVC = [[JYBatchSelectionVC alloc] init];
            imageVC.limitCount = 8-[self.imagesArray count];
            imageVC.imageCount = ws.imagesArray.count;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
            
            // 将当前已有图片的数量传入
            [imageVC setActionBatchSelection:^(NSArray *arr) {
                [ws.imagesArray addObjectsFromArray:arr];
                //            NSLog(@"选择的图片数组%@",self.imagesArray);
                
                [ws createIconImageView:self.imagesArray];
                [ws changeLocalViewFrame];
                [ws changContentSize];
            }];
            
            [ws presentViewController:nav animated:YES completion:^{
            }];
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) ws = self;
    [picker dismissViewControllerAnimated:NO completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [portraitImg fixOrientation];
        portraitImg = [portraitImg scaledToMaxSize:CGSizeMake(1920,1080)];
        [ws.imagesArray addObject:portraitImg];
        [ws createIconImageView:ws.imagesArray];
        [ws changeLocalViewFrame];
        [ws changContentSize];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 定位
- (void)locateCity
{
//    if ([CLLocationManager locationServicesEnabled]) {
//        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//            //提示用户无法进行定位操作
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
//        }else{
//            [self getLocation];
//        }
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查您的设备是否开启了定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    
    // 直接跳转页面
    MapViewController *map = [[MapViewController alloc]init];
    map.pageType = 1;
    [self presentViewController:map animated:YES completion:nil];
    // 获取定位城市
    __weak JYRemindViewController *weakSelf = self;
    [map setActionForGetLocationString:^(NSString *cityString, CLLocationCoordinate2D remindLoc) {
        
        if (![cityString isEqualToString:@""]) {
            weakSelf.cityString = cityString;
            [weakSelf createLocalView:cityString];
            [weakSelf changeLocalViewFrame];
            [weakSelf changContentSize];
            weakSelf.latitudeStr = [NSString stringWithFormat:@"%f",remindLoc.latitude];
            weakSelf.longitudeStr = [NSString stringWithFormat:@"%f",remindLoc.longitude];
        }
        
        NSLog(@"经度%.f 纬度%.f",remindLoc.latitude,remindLoc.longitude);
        
    }];
    
    
}
/*
- (void)getLocation
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        //开始定位，不断调用其代理方法
        [self.locationManager startUpdatingLocation];
        NSLog(@"start gps");
    }
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusDenied){
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    //    CLLocationCoordinate2D coordinate = location.coordinate;
    //    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 获取当前所在的城市名
    NSLog(@"111");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *country = placemark.country;
             // 如果定位国外，地图功能暂不可用
             if (![country isEqualToString:@"中国"]) {
                 
                 UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"暂不支持使用该功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [errorAlert show];
                 
             }else{
                 
                 // 如果定位中国，跳转页面
                 MapViewController *map = [[MapViewController alloc]init];
                 map.pageType = 1;
                 [self presentViewController:map animated:YES completion:nil];
                 // 获取定位城市
                 __weak JYRemindViewController *weakSelf = self;
                 [map setActionForGetLocationString:^(NSString *cityString, CLLocationCoordinate2D remindLoc) {
                     
                     if (![cityString isEqualToString:@""]) {
                         weakSelf.cityString = cityString;
                         [weakSelf createLocalView:cityString];
                         [weakSelf changeLocalViewFrame];
                         [weakSelf changContentSize];
                         weakSelf.latitudeStr = [NSString stringWithFormat:@"%f",remindLoc.latitude];
                         weakSelf.longitudeStr = [NSString stringWithFormat:@"%f",remindLoc.longitude];
                     }
                     
                     NSLog(@"经度%.f 纬度%.f",remindLoc.latitude,remindLoc.longitude);
                     
                 }];
                 
             }
             
         }else if (error == nil && [array count] == 0){
             NSLog(@"No results were returned.");
             
             UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [errorAlert show];
             
         }else if (error != nil){
             NSLog(@"An error occurred = %@", error);
             
             UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [errorAlert show];
         }
     }];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"error:%@",error.localizedDescription);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [errorAlert show];
        
    }
}
*/
@end
