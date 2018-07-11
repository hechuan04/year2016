//
//  JYRemindNoPassPeopleVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/13.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRemindNoPassPeopleVC.h"
#import "AddOtherCell.h"
#import "JYMusicViewController.h"
#import "UIButton+WebCache.h"
#import "VoiceBarView.h"
#import <AVFoundation/AVFoundation.h>

static NSString *strForAddOther = @"strForAddOther";

//title
#define yForTitle 30 / 1334.0 * kScreenHeight
#define xForTitle 16 / 750.0 * kScreenWidth
#define heightForTitle 89 / 1334.0 * kScreenHeight

//content
#define yForContent 172 / 1334.0 * kScreenHeight
//#define heightForContent 450 / 1334.0 * kScreenHeight
#define heightForContent (660 - 90) / 1334.0 * kScreenHeight

#define pageForView 16 / 1334.0 * kScreenHeight

//颜色cg
#define lineCGColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 /255.0 alpha:1].CGColor

#define yForTable 426 / 1334.0 * kScreenHeight

#define heightForCc 88 / 1334.0 * kScreenHeight


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

#define kImageViewBaseTag 1000

@interface JYRemindNoPassPeopleVC ()<VoiceBarDelegate>

@property (nonatomic ,strong)UIView * addImageView; // <! 存放图片的视图
@property (nonatomic ,strong)NSMutableArray *imagesArray; // <!用于记录添加和删除的照片
@property (nonatomic ,strong)UIView * localView;    // <! 定位完成显示的视图
@property (nonatomic ,strong)NSString *cityString;  // <! 当前定位地址
@property (nonatomic ,assign)CGRect textLineHeight; // <! 当前文本高度

@property (nonatomic ,strong)UIImage *scaleImg;     // <!点击放大的图片

@property (nonatomic,strong) NSMutableArray *voiceBars;

@property (nonatomic,assign) CGRect cityLabelRect;
@property (nonatomic,strong) UIImageView *localIconView;
@property (nonatomic,strong) UIView *localVerLineView;
@property (nonatomic,strong) UILabel *localLabelView;
@property (nonatomic,strong) UIButton *localDeleteBtn;
@end

@implementation JYRemindNoPassPeopleVC
{
 
    UIButton *collectionBtn;
}
//保存
- (void)rightAction
{
    [collectionBtn removeFromSuperview];
    collectionBtn = nil;
    _model.musicName = _ringID;
    _model.isOn = _isOn;
    
    MusicListManager *listManager = [MusicListManager   shareMusicListManager];
    if (_model.isShare == 1) {
        _model.uid = _model.sid;
    }
    
    [listManager deleteDataWithModel:_model];
    [listManager insertDataWithModel:_model musicName:_ringID];
    

    //改铃声
    [RequestManager actionForChangeMusicName:_model];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)actionForLeft:(UIButton *)sender
{
    
    for(VoiceBarView *tmpBar in self.voiceBars){
        [tmpBar stop];
    }
    [self.voiceBars removeAllObjects];
    //[RequestManager actionForChangeMusicName:_model];
    
    [collectionBtn removeFromSuperview];
    collectionBtn = nil;
//    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;
    
    NSMutableArray *arrForNavBtn = [NSMutableArray array];
    //table异步创建，在ios8中会有问题（该cell是xib的，awakeFromNib不调用）
    [self _creatTableView];
    
    if(self.mid){//有mid 跳转自收藏列表。网络请求数据
        self.navigationItem.title = @"提醒事项";
        if(kSystemVersion>=10){//ios10从搜索结果跳转过来导航少条线
            UIView *navLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,0.5)];
            navLineView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:navLineView];
        }
        [self loadDataFromServer];
    }else{
        if(self.model.isOther){
            NSInteger fid = self.model.isOther;
            FriendModel *friend = [[FriendListManager shareFriend] selectDataWithFid:fid];
            if(friend){
                if([friend.remarkName length]>0){
                    self.navigationItem.title = friend.remarkName;
                }else if(friend.friend_name){
                    self.navigationItem.title = friend.friend_name;
                }
            }else{
                self.navigationItem.title = @"已删除该好友";
            }
        }else if(self.model.friendName&&[self.model.friendName length]>0){
            self.navigationItem.title = self.model.friendName;
        }else{
            self.navigationItem.title = @"提醒事项";
        }
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        btnView.frame = CGRectMake(0, 0, 50, 50);
        [btnView setTitle:@"完成" forState:UIControlStateNormal];
        [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
        
        [arrForNavBtn addObject:right];
        
        collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame = CGRectMake(0, 0, 25, 25);
        [collectionBtn addTarget:self action:@selector(actionForCollection) forControlEvents:UIControlEventTouchUpInside];
     
        
        UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:collectionBtn];
        //        [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        if (_model.isSave != 0) {
            
            [collectionBtn setImage:[JYSkinManager shareSkinManager].collectionImageAlready forState:UIControlStateNormal];
        }else{
            
            [collectionBtn setImage:[[JYSkinManager shareSkinManager].collectionImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

        }
        
        [collectionBtn setTintColor:[JYSkinManager shareSkinManager].colorForDateBg];
        
        
        [collectionBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, -7)];
        [arrForNavBtn addObject:right2];
        self.navigationItem.rightBarButtonItems = arrForNavBtn;
        [self loadSubView];
    }
}
- (void)dealloc
{
    NSLog(@"====dealloc");
}
- (void)loadDataFromServer{
    __weak typeof(self) weakSelf = self;

    [RequestManager requestCollectionDetailDataWithId:self.mid isOhter:self.isFromOther completedBlock:^(id data, NSError *error) {
//        NSLog(@"%@",data);
        if(data&&[data isKindOfClass:[NSDictionary class]]){
            RemindModel *model = [[RemindModel alloc]init];
            model.title = data[@"title"];
            model.content = data[@"message"];
            model.year = [data[@"year"] intValue];
            model.month = [data[@"month"] intValue];
            model.day = [data[@"day"] intValue];
            model.hour = [data[@"hour"] intValue];
            model.minute = [data[@"min"] intValue];
            if(![data[@"offsetMinute"] isKindOfClass:[NSNull class]]){
                model.offsetMinute = [data[@"offsetMinute"] integerValue];
            }else{
                model.offsetMinute = 0;
            }
            NSString *createTime = data[@"createTime"];
            //转换为当地时间
            [model setSystemTime];
            
            if(createTime&&![createTime isKindOfClass:[NSNull class]]){
                //原逻辑中createTime 为时间戳格式：201612111180903,接口给的"2016-03-31 18:37:42.0";
                model.createTime = [[[createTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
            }
            //                model.uid = [data[@"sendUid"] intValue];
            model.uid = (int)self.mid;
            NSString *ringId = data[@"ringId"];
            if(ringId&&![ringId isKindOfClass:[NSNull class]]&&![ringId isEqualToString:@"<null>"]){
                model.musicName = [ringId intValue];
            }
            model.countNumber = [data[@"countNumber"] intValue];
            
            NSString *localInfo = data[@"localInfo"];
            if(localInfo&&![localInfo isKindOfClass:[NSNull class]]&&![localInfo isEqualToString:@"<null>"]){
                model.localInfo = localInfo;
            }
            NSString *latitudeStr = data[@"latitudeStr"];
            if(latitudeStr&&![latitudeStr isKindOfClass:[NSNull class]]&&![latitudeStr isEqualToString:@"<null>"]){
                model.latitudeStr = latitudeStr;
            }
            NSString *longitudeStr = data[@"longitudeStr"];
            if(longitudeStr&&![longitudeStr isKindOfClass:[NSNull class]]&&![longitudeStr isEqualToString:@"<null>"]){
                model.longitudeStr = longitudeStr;
            }
            model.randomType = [data[@"randomType"] intValue];
            NSString *weekStr = data[@"weekStr"];
            if(weekStr&&![weekStr isKindOfClass:[NSNull class]]&&![weekStr isEqualToString:@"<null>"]){
                model.weekStr = weekStr;
            }else{
                model.weekStr = @"";
            }
            
            NSString *urlString = data[@"headUrlStr"];
            if(urlString&&![urlString isKindOfClass:[NSNull class]]){
                model.headUrlStr = urlString;
            }
            NSString *audioStr = data[@"audioStr"];
            if(audioStr&&![audioStr isKindOfClass:[NSNull class]]){
                model.audioPathStr = audioStr;
            }
            NSString *audioDurationStr = data[@"audioDurationStr"];
            if(audioDurationStr&&![audioDurationStr isKindOfClass:[NSNull class]]){
                model.audioDurationStr = audioDurationStr;
            }
            
          
            
            weakSelf.model = model;
            weakSelf.ringID = [ringId intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadSubView];
//                weakSelf.titleField.userInteractionEnabled = NO;
                weakSelf.contentView.editable = NO;
                weakSelf.tableView.editing = NO;
                [ProgressHUD dismiss];
            });
        }else{
            [ProgressHUD dismiss];
        }
    }];
}
//收藏方法
- (void)actionForCollection
{
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
    [RequestManager actionForHttp:@"new_save"];
    _model.isSave = 1;
    [collectionBtn setImage:[JYSkinManager shareSkinManager].collectionImageAlready forState:UIControlStateNormal];
    NSLog(@"收藏了");
    [Tool actionForCollection:nil remindModel:_model];
    
}


- (void)loadSubView{
    _ringID = _model.musicName;
    _isOn = _model.isOn;
    
    [self _createTitleFiled];
    
    [self _createContentView];
    
//    [self _creatTableView];
    //将table创建提前，此时只把frame调整正确，reloaddata
    self.tableView.frame = CGRectMake(0, self.contentView.bottom + pageForView + 5, kScreenWidth, kScreenHeight);
    _tableView.hidden = NO;
    [self.tableView reloadData];
        
    self.imagesArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    if (![self.model.headUrlStr isEqualToString:@""] && ![self.model.headUrlStr isKindOfClass:[NSNull class]] && ![self.model.headUrlStr isEqualToString:@"(null)"] && ![self.model.headUrlStr isEqualToString:@"<null>"] && self.model.headUrlStr != nil){
        
        NSArray * tmpArr = [self.model.headUrlStr componentsSeparatedByString:@","];
        self.imagesArray = [NSMutableArray arrayWithArray:tmpArr];
        NSLog(@"tmpArray:%@",tmpArr);   
        
    }
    
    // 获取文本高度
    CGRect textLineHeight = [self.contentView.text boundingRectWithSize:CGSizeMake(kContentSizeW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.contentView.font} context:nil];
    self.textLineHeight = textLineHeight;
    
    
    if (self.model.localInfo&&![self.model.localInfo isEqualToString:@""] && ![self.model.localInfo isKindOfClass:[NSNull class]] && ![self.model.localInfo isEqualToString:@"(null)"]&&![self.model.localInfo isEqualToString:@"<null>"] && self.model.localInfo != nil) {
        
        self.cityString = self.model.localInfo;
        [self createLocalView:self.cityString];
    }
    
    if (self.imagesArray.count > 0) {
        
        [self createIconImageView:self.imagesArray];
    }
    
    [self changContentSize];
    
    [self layoutVoiceBars];
}

- (void)layoutVoiceBars
{
    if(!_voiceBars){_voiceBars = [NSMutableArray array];}
    
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
            audio.remoteUrlPath = url;
            audio.duration = duration;

            VoiceBarView *voiceBar = [[VoiceBarView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:voiceBar];
            voiceBar.delegate = self;
            voiceBar.canEdit = NO;
            voiceBar.audio = audio;
            [self.voiceBars addObject:voiceBar];
        }
    }
    
    CGFloat barHeight = 30.f;
    CGFloat verMargin = 5.f;
    CGFloat topPadding = 5.f;
    CGFloat contentTopInset = topPadding+[self.voiceBars count]*(barHeight+verMargin);
    
    for(int i=0;i<[self.voiceBars count];i++){
        CGRect rect = CGRectMake(10, -(contentTopInset-topPadding)+(barHeight+verMargin)*i, 260.f,barHeight);
        VoiceBarView *voiceBar = self.voiceBars[i];
        voiceBar.serialString = [NSString stringWithFormat:@"%d/3",i+1];
        voiceBar.frame = rect;
    }
    self.contentView.contentInset = UIEdgeInsetsMake(contentTopInset, 0, 0, 0);
    if([self.voiceBars count]>0){
        [self.contentView scrollRectToVisible:CGRectMake(0, 0, 100, 10) animated:YES];
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
- (void)voiceBarEndPlay:(VoiceBarView *)bar{
    
}
- (void)voiceBarDeleteButtonClicked:(VoiceBarView *)bar{
}

/// 修改文字内容滚动区域
-(void)changContentSize
{
        
    if (self.localView && !self.addImageView) {
        
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
    
        
    if ([obj isKindOfClass:[NSArray class]]) {
        
        if (self.imagesArray.count == 0) {
            return;
        }
        
        // 创建存放照片的数据
        self.addImageView = [[UIView alloc]initWithFrame:CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, kContentViewW, kAddImgViewHeight1)];
        
        // 添加到定位视图下面
        if (self.localView) {
            
            CGRect rect = self.addImageView.frame;
            rect.origin.y = self.localView.bottom + kSpace;
            self.addImageView.frame = rect;
            
        }
        self.addImageView.backgroundColor = [UIColor clearColor];
        self.addImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.addImageView];
        
        
        NSInteger row,column;
        
        for (int i = 0; i < self.imagesArray.count; i ++) {
            
            row = i/kImageColumnCount;
            column = i%kImageColumnCount;
            
            NSURL * imgUrl = [NSURL URLWithString:self.imagesArray[i]];
//            UIButton * iconView = [[UIButton alloc]init];
            UIImageView *iconView = [UIImageView new];
            iconView.tag = kImageViewBaseTag+i;
            iconView.frame = CGRectMake((kImageViewHeight+kImageHorMargin)*column,row*kImageRowHeight,kImageViewHeight,kImageViewHeight);
//            [iconView addTarget:self action:@selector(takePhotoAction:) forControlEvents:(UIControlEventTouchUpInside)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotoAction:)];
            iconView.userInteractionEnabled = YES;
            [iconView addGestureRecognizer:tap];
            
            iconView.clipsToBounds = YES;
            iconView.contentMode = UIViewContentModeScaleAspectFill;
//            [iconView.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]]; 
//            iconView.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            [iconView sd_setImageWithURL:imgUrl forState:(UIControlStateNormal)placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
            [iconView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
            [self.addImageView addSubview:iconView];
            
            // 添加第二排时需要改变addImageView的大小
            if (self.addImageView.subviews.count > 4) {
                
                CGRect rect = self.addImageView.frame;
                rect.size.height = kAddImgViewHeight2;
                self.addImageView.frame = rect;
                
            }
            
        }
        
    }
    
}
-(void)takePhotoAction:(id )sender
{
//    _scaleImg = [(UIButton *)sender imageForState:UIControlStateNormal];
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
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
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:self.imagesArray[index]];
    return url;
}


/// 创建定位视图
-(void)createLocalView:(NSString *)cityString
{
    
    
    CGFloat labelWidth = 560/750.0*kScreenWidth;
//    CGFloat labelWidth = self.contentView.contentSize.width-6*kHorSpace;
//    CGFloat labelHeight = 30/1334.0*kScreenHeight;
    CGFloat labelHeight = 25.f;
    
    CGRect cityLabelHeight = [cityString boundingRectWithSize:CGSizeMake(MAXFLOAT,labelHeight) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    self.cityLabelRect = cityLabelHeight;
    
    if (self.localView) {
        [self.localView removeFromSuperview];
    }
    
    self.localView = [[UIView alloc]init];
    self.localView.frame = CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, 550/750.0*kScreenWidth, 50/1334.0*kScreenHeight);
    
    if (self.addImageView) {
        
        CGRect rect = self.localView.frame;
        rect.origin.y = self.addImageView.bottom + kSpace;
        self.localView.frame = rect;
        
    }
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

    CGRect rect = self.localView.frame;
    rect.size.width = locallLabel.right + 17/750.0*kScreenWidth;
    self.localView.frame = rect;
    
    
}

- (void)localLabelTapped:(UITapGestureRecognizer *)tap
{
    
    MapViewController *map = [[MapViewController alloc]init];
    map.address = self.cityString;
    map.latitudeStr = self.model.latitudeStr;
    map.longitudeStr = self.model.longitudeStr;
    map.pageType = 2;
    [self presentViewController:map animated:YES completion:nil];
    
//    // 定位视图最大宽、高
//    
//    CGFloat labelWidth = 560/750.0*kScreenWidth;
//    CGFloat labelHeight = 40/1334.0*kScreenHeight;
//    
//    if(self.cityLabelRect.size.width>labelWidth){
//        //重新layout定位视图 frame计算copy自上面
//        
//        CGFloat newHeight =  ceilf(self.cityLabelRect.size.width / labelWidth) * labelHeight;
//        self.localView.frame = CGRectMake(kHorSpace, self.textLineHeight.size.height + kSpace, 550/750.0*kScreenWidth, 50/1334.0*kScreenHeight+newHeight-labelHeight);
//        
//        self.localView.layer.masksToBounds = YES;
//        self.localView.layer.cornerRadius = self.localView.size.height/2.0;
//        self.localView.layer.borderColor = lineColor.CGColor;
//        self.localView.layer.borderWidth = 1;
//        CGFloat space = 11/750.0*kScreenWidth;// 间隔宽度
//        self.localLabelView.frame = CGRectMake(self.localIconView.right + space, (self.localView.frame.size.height -newHeight)/2, labelWidth, newHeight);
//        CGFloat iconHeight = 26/1334.0*kScreenHeight;
//        self.localIconView.frame = CGRectMake(space, (self.localView.size.height-iconHeight)/2, 20/750.0*kScreenWidth, iconHeight);
//        CGRect rect = self.localView.frame;
//        rect.size.width = self.localLabelView.right + 17/750.0*kScreenWidth;
//        self.localView.frame = rect;
//        
//        self.localLabelView.text = self.cityString;
//        [self.localLabelView setNeedsDisplay];
//        
//        rect = self.addImageView.frame;
//        rect.origin.y = self.localView.bottom + kSpace;
//        self.addImageView.frame = rect;
//
//        [self changContentSize];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_creatTableView
{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.contentView.bottom + pageForView + 5, kScreenWidth, kScreenHeight - (self.contentView.bottom + pageForView + 5 + 20 + 44))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    int lineNum = 5;
    if(self.mid){//从收藏列表跳过来
        lineNum = 4;
    }
    for (int i = 0; i < 1; i++) {
        
        int yForCell = i * heightForCc;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, yForCell, kScreenWidth, 0.5)];
        lineView.backgroundColor = lineColor;
        [_tableView addSubview:lineView];
        
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddOtherCell" bundle:nil] forCellReuseIdentifier:strForAddOther];
    
    NSString *strForFid = [NSString stringWithFormat:@",%@,",_model.fidStr];
    
    NSString *xiaomi = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *xiaomiID = [NSString stringWithFormat:@",%@,",xiaomi];
    
    
    
    if (_model.isOther == 0 && [strForFid rangeOfString:xiaomiID].location == NSNotFound) {
        
        _tableView.userInteractionEnabled = NO;
        
    }
    
    [Tool actionForHiddenMuchTable:_tableView];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if(self.mid){//从收藏列表调过来，隐藏掉提醒开关
        return 4;
    }
    return 5;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:strForAddOther];
    
    if (!cell) {
        
        cell = [[AddOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForAddOther];
    }
    
    cell.switchBtn.on = _isOn;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = @"提醒时间";
        
        cell.arrowHead.hidden = YES;
        
        NSString *hour = [Tool actionForTenOrSingleWithNumber:_model.hour];
        NSString *minute = [Tool actionForTenOrSingleWithNumber:_model.minute];
        NSString *month = [Tool actionForTenOrSingleWithNumber:_model.month];
        NSString *day = [Tool actionForTenOrSingleWithNumber:_model.day];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%d.%@.%@ %@:%@",_model.year,month,day,hour,minute];
        
        cell.timeLabel.hidden = NO;
  
        
    }else if(indexPath.row == 1){
        
        cell.arrowHead.hidden = YES;
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = @"重复";
        
        NSString * repeatStr = [Tool actionForReturnRepeatStr:_model];
        
        if ([repeatStr isEqualToString:@""]) {
            cell.timeLabel.text = @"永不";
        }else{
            cell.timeLabel.text = repeatStr;
        }
        
        cell.timeLabel.hidden = NO;
        cell.arrowHead.hidden = YES;
//        cell.timeLabel.origin = CGPointMake(cell.arrowHead.left - 15 - 200, 19.5);
        
        
    }else if(indexPath.row == 2){
        
        cell.arrowHead.hidden = NO;
        
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = @"铃声选择";
        
        RemindModel *model = [[RemindModel alloc] init];
        model.musicName = _ringID;
        
        cell.timeLabel.text = [Tool actionForReturnMusicWithModel:model];
        
        cell.timeLabel.hidden = NO;

        
    }else if(indexPath.row == 3){
        
        cell.arrowHead.hidden = YES;
        cell.timeLabel.hidden = NO;
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = @"正点提醒";
        
        NSString *nextLabeltext;
        if (self.model.offsetMinute <= 30) {
            nextLabeltext = [NSString stringWithFormat:@"%ld分钟前",self.model.offsetMinute];
        }else{
            nextLabeltext = [NSString stringWithFormat:@"%ld小时前",self.model.offsetMinute / 60];
        }
        
        if (self.model.offsetMinute == 0) {
            cell.timeLabel.text = @"";
        }else{
            cell.timeLabel.text = nextLabeltext;
        }
        
    }else{
        cell.arrowHead.hidden = YES;
        
        cell.switchBtn.hidden = NO;
        cell.titleLabel.text = @"提醒";
        cell.timeLabel.hidden = YES;
    }
    
    __weak typeof(self) ws = self;
    [cell setActionForPassOpenOrClose:^(int isOn) {
        
        if (isOn) {
            
            ws.isOn = 1;
            [ws.tableView reloadData];
            
        }else{
            
            ws.isOn = 0;
            [ws.tableView reloadData];
        }
        
    }];
    
    
    return cell;
}


/**
 *  创建标题栏
 */
- (void)_createTitleFiled
{
   
    int pageHeight =  yForTitle;
    
    
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
    
  /*
    self.titleField = [[JYContentTexgFiled alloc] initWithFrame:CGRectMake(xForTitle, pageHeight, kScreenWidth - xForTitle * 2.0, heightForTitle)];
    self.titleField.text = @"事件标题";
    self.titleField.layer.cornerRadius = 3.0;
    self.titleField.layer.masksToBounds = YES;
    self.titleField.layer.borderColor = lineCGColor;
    self.titleField.layer.borderWidth = 0.5;
    self.titleField.font = [UIFont systemFontOfSize:19];
    self.titleField.textAlignment = NSTextAlignmentJustified;
    self.titleField.userInteractionEnabled = NO;
    [self.view addSubview:self.titleField];
    
    self.titleField.text = self.model.title;
    
    __weak JYRemindNoPassPeopleVC *vc = self;
    [self.titleField setChangeFrame:^void(BOOL isEditOk){
        
        if (isEditOk) {
            
            //JYLog(@"题目正在编辑");
            [vc.contentView resignFirstResponder];
            
        }else{
            
            //JYLog(@"题目编辑完成");
            //[vc actionForTitle:vc.titleField.text];
            
        }
        
    }];
   */
    
}

/**
 *  创建内容栏
 */
- (void)_createContentView
{
    int pageHeight = 24;
    self.contentView = [[JYContentTextView alloc] initWithFrame:CGRectMake(xForTitle, pageHeight, kScreenWidth - xForTitle * 2,heightForContent)];
    self.contentView.layer.cornerRadius = 3.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = lineCGColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.selectedRange = NSMakeRange(15, 5);
    self.contentView.font = [UIFont systemFontOfSize:19];
    self.contentView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentView.userInteractionEnabled = YES;
    self.contentView.editable = NO;

    [self.view addSubview:self.contentView];
    
    self.contentView.text = self.model.content;
    
    __weak JYRemindNoPassPeopleVC *vc = self;
    [self.contentView setChangeFrame:^void(BOOL isEditOk){
        
        if (isEditOk) {
            
            //JYLog(@"内容正在编辑");
            [vc.titleField resignFirstResponder];
            //
        }else{
            
            //JYLog(@"内容编辑完成");
            //            [vc actionForContent:vc.contentView.text];
            
        }
        
    }];
    
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_IPHONE_4_SCREEN) {
        
        if (indexPath.row < 3) {
            
            return heightForCc;
            
        }else{
            
            return heightForCc + 5;
            
        }
        
        
    }else{
        
        return heightForCc;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 2) {
        
        JYMusicViewController *musicVC = [[JYMusicViewController alloc] init];
        musicVC.model = [[RemindModel alloc] init];
        musicVC.model.musicName = _ringID;
        
        __weak JYRemindNoPassPeopleVC *vc = self;
        [musicVC setActionForMusicName:^(int musicName) {
            
            vc.ringID = musicName;
            [vc.tableView reloadData];
            
        }];
        
        [self.navigationController pushViewController:musicVC animated:YES];
        
        
    }
    
}

@end
