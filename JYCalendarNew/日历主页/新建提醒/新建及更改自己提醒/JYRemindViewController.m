//
//  JYRemindViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindViewController.h"
#import "Tool.h"


//类目
#import "JYRemindViewController+ActionForRemind.h"
#import "JYRemindViewController+UIForRemind.h"
#import <CommonCrypto/CommonDigest.h>

@interface JYRemindViewController ()

@property (nonatomic,strong) MicrophoneView *recordView;
@property (nonatomic,assign) CGFloat contentTopInset;
@end

@implementation JYRemindViewController
{
    UIButton *collectionBtn;
    UIButton *_putKeyBoardBtn;
    
}
/**
 *  直接从组跳转过来
 */
- (void)addNotification:(NSNotification *)text
{
 

    _arrForFriend = text.userInfo[@"friend"];
    _arrForGroup  = text.userInfo[@"group"];
    
    [self actionForHidenOrAppearFriend];
    
    NSMutableString *fidStr = [NSMutableString string];
    NSMutableString *gidStr = [NSMutableString string];
    for (int i = 0; i < _arrForFriend.count; i++) {
        
        FriendModel *model = _arrForFriend[i];
        NSString *strFid = @"";
        if (i == _arrForFriend.count - 1) {
            
            strFid = [NSString stringWithFormat:@"%ld",(long)model.fid];
            
        }else{
         
            strFid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            
        }
        
        [fidStr appendString:strFid];
    }
    
    for (int i = 0; i < _arrForGroup.count; i++) {
        
        GroupModel *model = _arrForGroup[i];
        NSString *strGid = @"";
        if (i == _arrForGroup.count - 1) {
            
            strGid = [NSString stringWithFormat:@"%d",model.gid];
            
        }else{
         
            strGid = [NSString stringWithFormat:@"%d,",model.gid];
        }
        
        [gidStr appendString:strGid];
    }
    
    _model.fidStr = fidStr;
    _model.gidStr = gidStr;
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    if ((![gidStr isEqualToString:@""] || ![fidStr isEqualToString:@""]) && ![fidStr isEqualToString:userID]) {
        
        [self _createRightBtn:@"发送"];
        
    }else{
        
        [self _createRightBtn:@"完成"];
    }
    
    [_remindTb reloadData];
}

- (void)_createRightBtn:(NSString *)str
{
    ManagerForButton *manager1 = [ManagerForButton shareManagerBtn];
    manager1.leftAndRightPage = -10;
    
    /*
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(confirmActionForPop:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:str forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    */
    [self.navigationItem.rightBarButtonItem setTitle:str];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    
    if (_arrForFriend.count > 0 || _arrForGroup.count > 0) {
        
        [self _createRightBtn:@"发送"];
        
    }else{
        
        [self _createRightBtn:@"完成"];
    }
    
}

/// 数据上传成功之后的回调
-(void)actionForDeleteImage:(NSNotification *)notification
{
    // 1.发送成功之后删除保存的图片
    // 2.自己的提醒变为他人提醒 需要删除图片数据
    
    if ([notification.object isEqualToString:@"my"]) {
        
        [self deleteFolder:self.folderPath];
        NSLog(@"my---------------actionForDeleteImage==folderPath:%@",self.folderPath);

    }else{
        
        [self deleteFolder:self.model.headUrlStr];
        [self deleteFolder:self.folderPath];
        NSLog(@"my---------------actionForDeleteImage==folderPath:%@=====headUrlStr:%@",self.folderPath,self.model.headUrlStr);

        
    }
    
    
   
    
}
/// 删除文件夹
-(void)deleteFolder:(NSString *)folderPath
{
    if (![folderPath isEqualToString:@""] && ![folderPath isKindOfClass:[NSNull class]] && ![folderPath isEqualToString:@"(null)"] && ![folderPath isEqualToString:@"<null>"] && folderPath != nil){
        
        NSArray * tmpArr = [folderPath componentsSeparatedByString:@","];
        
        if (tmpArr.count != 0) {
            
            NSString * fileStr = tmpArr[0];
            
            if (![fileStr isEqualToString:@""]) {
                
                // 存放文件路径会变，要重新获取
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [paths objectAtIndex:0];
                path = [path stringByAppendingPathComponent:@"img"];
                NSArray *pathArray = [fileStr componentsSeparatedByString:@"/"];
                NSString *folderStr = [pathArray objectAtIndex:pathArray.count-2];
                NSString *imgPath = [NSString stringWithFormat:@"%@/%@",path,folderStr];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:imgPath] == YES) {
                    
                    [fileManager removeItemAtPath:imgPath error:NULL];
                    
                    
                } 
            }
        }
        
    }
}

// 先把照片写到本地
-(NSString *)creatImagePath:(UIImage *)image pathName:(NSString *)pathName imageName:(NSString *)imageStr
{
    
    NSData * newImageData =  UIImageJPEGRepresentation(image, 0.5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"img"];
    path = [path stringByAppendingPathComponent:pathName];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imageName = [NSString stringWithFormat:@"%@/%@",path,imageStr];
//    [UIImagePNGRepresentation([UIImage imageWithData:newImageData])writeToFile: imageName atomically:YES];
    [UIImageJPEGRepresentation([UIImage imageWithData:newImageData],0.6) writeToFile: imageName atomically:YES];
    NSLog(@"写入沙盒路径：%@",imageName);
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:imageName error:nil] fileSize];
    NSLog(@"audioRecorderDidFinishRecording====%fkb",fileSize/1024.f);
    
    return imageName;
}

//收藏方法
- (void)actionForCollection
{
 
    NSLog(@"收藏了");
    
    if (_model.isSave != 0) {
        
//        __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"请勿重复收藏" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
//            
//            //Window隐藏，并置为nil，释放内存 不能少
//            __sheetWindow.hidden = YES;
//            __sheetWindow = nil;
//            
//        }];

        [Tool showAlter:self title:@"该条已收藏"];

        return;
    }
  
    _model.isSave = 1;
    [collectionBtn setImage:[JYSkinManager shareSkinManager].collectionImageAlready forState:UIControlStateNormal];
    _model.files = self.imagesArray;
    [Tool actionForCollection:nil remindModel:_model];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

  
    //监测新建提醒
    [RequestManager actionForHttp:@"new_alert"];
    
    //判断时候更新或直接修改
    if (_model.upData) {
        _model_year = _model.year;
        _model_month = _model.month;
        _model_day = _model.day;
        _model_hour = _model.hour;
        _model_minute = _model.minute;
    }
  
    
    
    NSMutableArray *arrForBtn = [NSMutableArray array];
    if (!self.isCreate) {
       
        collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame = CGRectMake(0, 0, 25, 25);
        
       
        [collectionBtn addTarget:self action:@selector(actionForCollection) forControlEvents:UIControlEventTouchUpInside];
        
        if (_model.isSave != 0) {
            [collectionBtn setImage:[JYSkinManager shareSkinManager].collectionImageAlready forState:UIControlStateNormal];
        }else{
            [collectionBtn setImage:[[JYSkinManager shareSkinManager].collectionImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

        }
        
        [collectionBtn setTintColor:[JYSkinManager shareSkinManager].colorForDateBg];
  
        [collectionBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, -7)];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:collectionBtn];
        [arrForBtn addObject:right];        

    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotification:) name:kNotificationForGroupPassRemind object:@""];
    
    // 删除自己的提醒的照片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForDeleteImage:) name:kNotificationDeleteImage object:@"my"];
    // 删除给别人的提醒的照片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForDeleteImage:) name:kNotificationDeleteImage object:@""];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    self.title = @"设置提醒";
    
    self.imagesArray = [[NSMutableArray alloc]initWithCapacity:30];
    if (!_model.upData) {
        self.latitudeStr = @"0.000000";
        self.longitudeStr = @"0.000000";
    }
    


    
//#warning 这段应该加在多线程里边
    if (!self.isCreate) {
    
            
            //组和朋友ID
            NSArray *arrForFid = [_model.fidStr componentsSeparatedByString:@","];
            NSArray *arrForGid = [_model.gidStr componentsSeparatedByString:@","];
            
            
            NSMutableArray *arrForFriendModel = [NSMutableArray array];
            NSMutableArray *arrForGroupModel = [NSMutableArray array];
            
            FriendListManager *fManger = [FriendListManager shareFriend];
            GroupListManager  *gManger = [GroupListManager shareGroup];
            
            
            for (int i = 0; i < arrForFid.count; i++) {
                
                NSInteger fid = [arrForFid[i] integerValue];
                
                if (fid == 0) {
                    
                    break;
                }
                
                FriendModel *model = [fManger selectDataWithFid:fid];
                
                if (model) {
                    [arrForFriendModel addObject:model];
                }
                
            }
            
            
            for (int i = 0; i < arrForGid.count; i ++) {
                
                NSInteger gid = [arrForGid[i] integerValue];
                
                if (gid == 0) {
                    
                    break;
                }
                
                GroupModel *model = [gManger selectDataWithGid:gid];
                
                if (model) {
                    [arrForGroupModel addObject:model];
                }
                
            }
        
        if (_model.isOther == 0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            FriendModel *model = [[FriendModel alloc] init];
            //[fManger selectDataWithFid:[[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]intValue]];
            model.head_url = [userDefaults objectForKey:kUserHead];
            model.fid      = [[userDefaults objectForKey:kUserXiaomiID]intValue];
            model.friend_name = [userDefaults objectForKey:kUserName];

            [arrForFriendModel addObject:model];
        }
        
        if (arrForFriendModel.count > 0) {
            
            self.arrForFriend = arrForFriendModel;

        }
        
        if (arrForGroupModel.count > 0) {
            
            self.arrForGroup = arrForGroupModel;
        }
        
    
    }


    _strForTitle = @"提醒日期";
    
    
//    _musicArr = @[@"幻觉",@"科技",@"蓝调",@"女声",@"月光",@"别动",@"喂哎",@"无声"];
    _musicArr = @[@"科技",@"月光",@"电动",@"古筝",@"铃铛",@"小号",@"洋琴",@"无声"];
    //接收是否打开防扰模式的通知
    
    _isDisturb = [[[NSUserDefaults standardUserDefaults] objectForKey:kisDistrubation] boolValue];
    
    
     _dayNameArray = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一"];
    
    _isOpen = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    
    
    [self.voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    
    
    ManagerForButton *manager1 = [ManagerForButton shareManagerBtn];
    manager1.leftAndRightPage = -10;
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(confirmActionForPop:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    
    JYSkinManager * manager = [JYSkinManager shareSkinManager];
    [btnView setTitleColor:manager.colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    [arrForBtn insertObject:right atIndex:0];
    self.navigationItem.rightBarButtonItems = arrForBtn;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;

    
    //取消改动(改动这个model的值会影响传入进来的值)
    _NotChange_fidStr = _model.fidStr;
    _NotChange_gidStr = _model.gidStr;
    
   [GuideView showGuideWithImageName:@"新手引导页2"];
    
    
    //取消键盘弹出按钮
    _putKeyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _putKeyBoardBtn.frame = CGRectMake( kScreenWidth - 42 - 35 / 2.0 ,kScreenHeight, 42, 42);
    [_putKeyBoardBtn setImage:[JYSkinManager shareSkinManager].putKeyBoardImage forState:UIControlStateNormal];
    [_putKeyBoardBtn addTarget:self action:@selector(cancelKeyBoardPut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_putKeyBoardBtn];
    //UIKeyboardWillShowNotification

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardHidden:(NSNotification *)notification
{
    CGFloat duration = [[[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:duration animations:^{
        _putKeyBoardBtn.origin = CGPointMake(kScreenWidth - 42 - 35 / 2.0, kScreenHeight);
    }];    
}

- (void)keyBoardAppear:(NSNotification *)notification
{
    NSValue *keyboardRectAsObject=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    CGFloat curkeyBoardHeight = keyboardRect.size.height;

    
    UIFont *newFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *ctfFont = newFont.fontDescriptor;
    NSNumber *fontString = [ctfFont objectForKey:@"NSFontSizeAttribute"];

    [UIView animateWithDuration:duration animations:^{
        _putKeyBoardBtn.origin = CGPointMake(kScreenWidth - 42 - 35 / 2.0,kScreenHeight - curkeyBoardHeight - [fontString integerValue] * 2 * 2 - 42 - 10);
    }];
}

//取消键盘弹出方法
- (void)cancelKeyBoardPut:(UIButton *)sender
{
    [self.titleField resignFirstResponder];
    [self.contentView resignFirstResponder];
}

- (void)dealloc
{
    [_yearAndMinuteView removeFromSuperview];
    _yearAndMinuteView = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"JYRemindViewController-----dealloc");
}
- (void)actionForLeft:(UIButton *)sender
{
    [collectionBtn removeFromSuperview];
    collectionBtn = nil;
    self.jyAllPicker = nil;
    _model.fidStr = _NotChange_fidStr;
    _model.gidStr = _NotChange_gidStr;
    for(VoiceBarView *tmpBar in self.voiceBars){
        [tmpBar stop];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

//*******************************回传方法*******************************//
//完成按钮方法
- (void)confirmActionForPop:(UIButton *)sender
{

    [self.view endEditing:YES];
    [collectionBtn removeFromSuperview];
    collectionBtn = nil;
    
    NSString *txt = self.contentView.text.trimWhitespace;
    
    
 
    
    if(txt.length==0&&self.audios.count==0&&self.imagesArray.count==0&&[self.model.headUrlStr length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒内容不能为空" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
        
    }

    
    //标题处理
    if(txt.length==0){
        self.model.title = @"提醒";
    }else if(txt.length<7){
        self.model.title = txt;
    }else{
        self.model.title = [txt subEmojiStringToIndex:7];
    }
    
    
    //如果为NO,说明选中时间比当前时间早，提醒无意义
//    BOOL isBeforeTime = [Tool isAlreadyNowYear:_model.year month:_model.month day:_model.day hour:_model.hour minute:_model.minute];
//    
//    if((self.model.upData&&self.model.randomType>0)){
//        //更新重复提醒可以通过校验
//    }else{
//        
//        if (!isBeforeTime) {
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您选择的提醒时间不能早于当前时间" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            
//            return;
//        }
//        
//    }
    
    
    
    
    // 配置要存到本地的照片地址
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSMutableArray * array = [NSMutableArray array];

    for (int i = 0; i < self.imagesArray.count; i ++) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,i];
        UIImage * image = self.imagesArray[i];
        NSString * pinStr = [self creatImagePath:image pathName:str imageName:fileName];
        [array addObject:pinStr];
    }
    NSString *string = [array componentsJoinedByString:@","];
    NSLog(@"新的拼接用逗号:%@",string);

//    self.model.title = _titleField.text;
    self.model.content = _contentView.text;
    self.model.localInfo = _cityString;
    self.model.files = self.imagesArray;
    self.model.headUrlStr = string;
    //地图 经纬度
    self.model.latitudeStr = self.latitudeStr;
    self.model.longitudeStr = self.longitudeStr;
    
    RemindModel *model = [[RemindModel alloc] init];
    model.isTop = @"0";
    model = self.model;
    
    
    //音频处理
    if(model.upData){
        
        NSString *remoteStr = @"";
        NSString *localPathStr = @"";
        NSMutableString *remoteDuration = [NSMutableString new];
        NSMutableString *localDurationStr = [NSMutableString new];
        for(int i=0; i<[self.audios count]; i++){
            AudioModel *audio = self.audios[i];
            NSLog(@"%@---%@----%f",audio.relativePath,audio.remoteUrlPath,[audio.duration floatValue]);
            if(audio.remoteUrlPath.length>0){//远程音频拼串
                remoteStr = [NSString stringWithFormat:@"%@,",[remoteStr stringByAppendingString:audio.remoteUrlPath]];
                [remoteDuration appendFormat:@"%f,",[audio.duration floatValue]];
            }else if(audio.relativePath.length>0){//本地路径拼串
                localPathStr = [NSString stringWithFormat:@"%@,",[localPathStr stringByAppendingString:audio.relativePath]];
                [localDurationStr appendFormat:@"%f,",[audio.duration floatValue]];
            }
        }
        
        if(remoteStr.length>0){
            remoteStr = [remoteStr substringToIndex:remoteStr.length-1];
        }
        if(remoteDuration.length>0){
            [remoteDuration deleteCharactersInRange:NSMakeRange(remoteDuration.length-1, 1)];
        }
        if(localDurationStr.length>0){
            [localDurationStr deleteCharactersInRange:NSMakeRange(localDurationStr.length-1, 1)];
        }
        if(remoteDuration.length>0&&localDurationStr.length>0){
            model.audioDurationStr = [NSString stringWithFormat:@"%@,%@",remoteDuration,localDurationStr];
        }else if(remoteDuration.length>0){
            model.audioDurationStr = remoteDuration;
        }else if(localDurationStr.length>0){
            model.audioDurationStr = localDurationStr;
        }
        NSLog(@"%@",remoteStr);
        model.audioRemoteStr = remoteStr;
        model.audioPathStr = localPathStr;
        //音频时长先远程后本地
//        self.model.audioDurationStr = [[self.audios valueForKey:@"duration"] componentsJoinedByString:@","];
    }else{//新建
        //音频
        self.model.audioPathStr = [[self.audios valueForKey:@"relativePath"] componentsJoinedByString:@","];
        self.model.audioDurationStr = [[self.audios valueForKey:@"duration"] componentsJoinedByString:@","];
        model.audioRemoteStr = @"";
    }
    
    if (model.upData) {
        NSString *changeTime = [NSString stringWithFormat:@"%d%d%d%d%d",model.year,model.month,model.day,model.hour,model.minute];
        NSString *entranceTime = [NSString stringWithFormat:@"%d%d%d%d%d",_model_year,_model_month,_model_day,_model_hour,_model_minute];
        if (![changeTime isEqualToString:entranceTime]) {
            model.upData = NO;
        }
        
    }
  
   
    
    //UTC时间基准
    [Tool actionForChangeModelAbsoluteTime:model];
    
    NSString *timeMonth = [Tool actionForTenOrSingleWithNumber:model.month];
    NSString *timeDay = [Tool actionForTenOrSingleWithNumber:model.day];
    
    NSString *timeHour = [Tool actionForTenOrSingleWithNumber:model.hour];
    
    NSString *timeMinut = [Tool actionForTenOrSingleWithNumber:model.minute];
    
    model.timeorder = [NSString stringWithFormat:@"%d%@%@%@%@",model.year,timeMonth,timeDay,timeHour,timeMinut];

    
    if (!model.upData) {
        NSString *nowYear = [Tool actionForNowYear:nil];
        int nowMonth1 = [[Tool actionForNowMonth:nil] intValue];
        int nowDay1 = [[Tool actionForNowSingleDay:nil] intValue];
        int nowHour1 = [[Tool actionforNowHour] intValue];
        int nowMinute1 = [[Tool actionforNowMinute] intValue];
      
        RemindModel *model222 = [[RemindModel alloc] init];
        model222.year = [nowYear intValue];
        model222.month = nowMonth1;
        model222.day  = nowDay1;
        model222.hour = nowHour1;
        model222.minute = nowMinute1;
        
        [Tool actionForChangeModelAbsoluteTime:model222];

        
        NSString *nowMonth = [Tool actionForTenOrSingleWithNumber:model222.month];
        NSString *nowDay = [Tool actionForTenOrSingleWithNumber:model222.day];
        NSString *nowHour = [Tool actionForTenOrSingleWithNumber:model222.hour];
        NSString *nowMinute = [Tool actionForTenOrSingleWithNumber:model222.minute];
        
        NSString *createTimeStr = [NSString stringWithFormat:@"%d%@%@%@%@",model222.year,nowMonth,nowDay,nowHour,nowMinute];
        
        model.createTime = createTimeStr;
        
    }else{
     
        model.createTime = self.model.createTime;
    }
    
    
    if (model.gidStr == nil) {
        
        model.gidStr = @"";
    }
    
    if (model.fidStr == nil) {
        
        model.fidStr = @"";
    }


    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isOn = [defaults objectForKey:kisDistrubation];
    
    //打扰模式
    if (isOn) {
        
        if (model.hour >= 23 || model.hour <= 6) {
            model.isOn = 0;
        }
        
    }

    if ([self.delegate respondsToSelector:@selector(passModel:remindOther:)]) {
    
        if ([model.fidStr isEqualToString:@""] && [model.gidStr isEqualToString:@""]) {
            model.fidStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]];
        }
        
        [self.delegate passModel:model remindOther:YES];
        [self.navigationController popViewControllerAnimated:YES];

    }else{
    
        /*
        //通过好友列表跳转只能用通知传值
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:model forKey:@"model"];
        [dic setObject:@(isOther) forKey:@"isOther"];
        
        NSNotification *notification = [[NSNotification alloc] initWithName:kNotificationForGoRootVC object:@"" userInfo:dic];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        */
    }

}


/**
 设置识别参数
 ****/
//-(void)initRecognizer
//{
//    NSLog(@"%s",__func__);
//    
//    if ([IATConfig sharedInstance].haveView == NO) {//无界面
//        
//        //单例模式，无UI的实例
//        if (_iFlySpeechRecognizer == nil) {
//            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
//            
//            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//            
//            //设置听写模式
//            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//        }
//        _iFlySpeechRecognizer.delegate = self;
//        
//        if (_iFlySpeechRecognizer != nil) {
//            IATConfig *instance = [IATConfig sharedInstance];
//            
//            //设置最长录音时间
//            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//            //设置后端点
//            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
//            //设置前端点
//            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
//            //网络等待时间
//            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//            
//            //设置采样率，推荐使用16K
//            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
//            
//            if ([instance.language isEqualToString:[IATConfig chinese]]) {
//                //设置语言
//                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//                //设置方言
//                [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
//            }else if ([instance.language isEqualToString:[IATConfig english]]) {
//                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//            }
//            //设置是否返回标点符号
//            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
//            
//        }
//    }else  {//有界面
//        
//        //单例模式，UI的实例
//        if (_iflyRecognizerView == nil) {
//            //UI显示剧中
//            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
//            
//            [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//            
//            //设置听写模式
//            [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//            
//        }
//        _iflyRecognizerView.delegate = self;
//        
//        if (_iflyRecognizerView != nil) {
//            IATConfig *instance = [IATConfig sharedInstance];
//            //设置最长录音时间
//            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//            //设置后端点
//            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
//            //设置前端点
//            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
//            //网络等待时间
//            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//            
//            //设置采样率，推荐使用16K
//            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
//            if ([instance.language isEqualToString:[IATConfig chinese]]) {
//                //设置语言
//                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//                //设置方言
//                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
//            }else if ([instance.language isEqualToString:[IATConfig english]]) {
//                //设置语言
//                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//            }
//            //设置是否返回标点符号
//            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
//            
//        }
//    }
//}
//#pragma mark - IFlySpeechRecognizerDelegate
//
//
///**
// 开始识别回调
// ****/
//- (void) onBeginOfSpeech
//{
//    NSLog(@"onBeginOfSpeech");
//    
//}
//
///**
// 停止录音回调
// ****/
//- (void) onEndOfSpeech
//{
//    
//    
//    
//    NSLog(@"onEndOfSpeech");
//    
//}
//
//
///**
// 听写结束回调（注：无论听写是否正确都会回调）
// error.errorCode =
// 0     听写正确
// other 听写出错
// ****/
//- (void) onError:(IFlySpeechError *) error
//{
//    NSLog(@"%s",__func__);
//    
//    if ([IATConfig sharedInstance].haveView == NO ) {
//        NSString *text ;
//        
//        if (error.errorCode == 0 ) {
//            
//        }else {
//            text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
//            NSLog(@"%@",text);
//        }
//        
//    }else {
//        NSLog(@"errorCode:%d",[error errorCode]);
//    }
//    
//    
//    
//}
//
///**
// 无界面，听写结果回调
// results：听写结果
// isLast：表示最后一次
// ****/
//- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
//{
//    
//    NSMutableString *resultString = [[NSMutableString alloc] init];
//    NSDictionary *dic = results[0];
//    for (NSString *key in dic) {
//        [resultString appendFormat:@"%@",key];
//    }
//    
//    NSLog(@"resultString:%@",resultString);
//    
//}
//
///**
// 有界面，听写结果回调
// resultArray：听写结果
// isLast：表示最后一次
// ****/
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
//{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    NSDictionary *dic = [resultArray objectAtIndex:0];
//    
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    NSLog(@"result:%@",result);
//    
//    
//    // 获得光标所在的位置
//    NSInteger location = self.contentView.selectedRange.location;
//    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
//    NSString *content = self.contentView.text;
//    NSString *resultString = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],result,[content substringFromIndex:location]];
//    // 将调整后的字符串添加到UITextView上面
//    self.contentView.text = resultString;
//    [self textViewDidChange:self.contentView];
//
//    
//    
//}
//#pragma mark  - 声音地址
//
//- (void)soundPath{
//    //demo录音文件保存路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
//}
//

#pragma mark ---
#pragma mark 录音
-(void)voiceBtnAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    __weak typeof(self) ws = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //最多可以录制3条
                            if([ws.voiceBars count]>=3){
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录音失败" message:@"已达录音条数上限（3条）" delegate:ws cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [alertView show];
                            }else{
                                if(!ws.recordView.superview){
//                                    ws.recordView.voiceLimitCount = 3-[self.voiceBars count];
                                    [ws.navigationController.view addSubview:ws.recordView];
                                }
                            }
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 可以显示一个提示框告诉用户这个app没有得到允许？
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请打开系统设置中\"隐私->麦克风\",允许\"小秘\"使用您的麦克风" message:@"" delegate:ws cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alertView show];
                        });
                    }
    }];
    
}

#pragma mark -  录音相关
- (NSMutableArray *)voiceBars
{
    if(!_voiceBars){
        _voiceBars = [NSMutableArray arrayWithCapacity:3];
    }
    return _voiceBars;
}
- (NSMutableArray *)audios
{
    if(!_audios){
        _audios = [NSMutableArray arrayWithCapacity:3];//最多三段录音
    }
    return _audios;
}
- (MicrophoneView *)recordView
{
    if(!_recordView){
        _recordView = [[MicrophoneView alloc]initWithFrame:self.navigationController.view.bounds];
        _recordView.center = self.navigationController.view.center;
        _recordView.contentMode = UIViewContentModeCenter;
        _recordView.userInteractionEnabled = YES;
//        _recordView.voiceLimitCount = 3-[self.voiceBars count];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (void)layoutVoiceBars
{
    CGFloat barHeight = 30.f;
    CGFloat verMargin = 5.f;
    CGFloat topPadding = 5.f;
    self.contentTopInset = topPadding+[self.voiceBars count]*(barHeight+verMargin);

    for(int i=0;i<[self.voiceBars count];i++){
        CGRect rect = CGRectMake(10, -(self.contentTopInset-topPadding)+(barHeight+verMargin)*i,self.contentView.bounds.size.width-20.f,barHeight);
        VoiceBarView *voiceBar = self.voiceBars[i];
        voiceBar.serialString = [NSString stringWithFormat:@"%d/3",i+1];
        voiceBar.frame = rect;
    }
    self.contentView.contentInset = UIEdgeInsetsMake(self.contentTopInset, 0, 0, 0);
    if([self.voiceBars count]>0){
        [self.contentView scrollRectToVisible:CGRectMake(0, 0, 100, 10) animated:YES];
    }
}
#pragma mark MicrophoneViewDelegate
- (void)microphoneViewDidFinishRecording:(MicrophoneView *)microponeView audioPath:(NSString *)path duration:(CGFloat)duration
{
    if(path){
        NSRange range = [path rangeOfString:@"audio"];
        if(range.location!=NSNotFound){
            NSString *relativePath = [path substringFromIndex:range.location];
            AudioModel *audio = [AudioModel new];
            audio.absolutePath = path;
            audio.relativePath = relativePath;
            audio.duration = @(duration);
            [self.audios addObject:audio];
            
            VoiceBarView *voiceBar = [[VoiceBarView alloc]initWithFrame:CGRectZero];
            voiceBar.delegate = self;
            voiceBar.audio = audio;
            voiceBar.canEdit = YES;
            [self.contentView addSubview:voiceBar];
            [self.voiceBars addObject:voiceBar];
            
            [self layoutVoiceBars];

        }
        
    }
}
#pragma mark - VoiceBarDelegate
- (void)voiceBarBeginPlay:(VoiceBarView *)bar
{
    for(VoiceBarView *tmpBar in self.voiceBars){
        if(tmpBar!=bar){
            [tmpBar stop];
        }
    }
}
- (void)voiceBarEndPlay:(VoiceBarView *)bar
{
    NSLog(@"voice play end!");
}
- (void)voiceBarDeleteButtonClicked:(VoiceBarView *)bar
{
    for(VoiceBarView *tmpBar in self.voiceBars){
        if(tmpBar==bar){
            [bar stop];
            [self.voiceBars removeObject:tmpBar];
            [tmpBar removeFromSuperview];
            __weak typeof(self) ws = self;
//            [self.audioFilePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSString *path = obj;
//                if([path isEqualToString:bar.audioUrlStr]){
//                    [ws.audioFilePaths removeObject:path];
//                }
//            }];
            [self.audios enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AudioModel *audio = obj;
                if([audio.relativePath isEqualToString:bar.audio.relativePath]){
                    [ws.audios removeObject:audio];
                }else if([audio.remoteUrlPath isEqualToString:bar.audio.remoteUrlPath]){
                    [ws.audios removeObject:audio];
                }
            }];
            [self layoutVoiceBars];
            break;
        }
    }
}

#pragma mark - Keyboard NSNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    if([self.contentView isFirstResponder]){
        CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        if(height>0){
            self.contentView.contentInset = UIEdgeInsetsMake(self.contentTopInset, 0,40, 0);
        }
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([self.contentView isFirstResponder]){
        self.contentView.contentInset = UIEdgeInsetsMake(self.contentTopInset,0,0,0);
    }
}
@end
