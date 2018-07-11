//
//  JYRemindOtherVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/18.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRemindOtherVC.h"
#import "AddOtherCell.h"
#import "JYMusicViewController.h"
#import "UIButton+WebCache.h"
#import "VoiceBarView.h"
#import <AVFoundation/AVFoundation.h>

#import "PushFriendViewC.h"
#import "GroupModelVC.h"
#import "MapViewController.h"

static NSString *strForAddOther = @"strForAddOther";

//title
#define yForTitle 30 / 1334.0 * kScreenHeight
#define xForTitle 16 / 750.0 * kScreenWidth
#define heightForTitle 89 / 1334.0 * kScreenHeight

//提醒人
#define pageForView 16 / 1334.0 * kScreenHeight

#define oneHeight 89 / 1334.0 * kScreenHeight
#define twoHeight 186 / 1334.0 * kScreenHeight
#define threeHeight 268 / 1334.0 * kScreenHeight

#define bigPage  30 / 750.0 * kScreenWidth
#define smallPage 24 / 750.0 * kScreenWidth
#define yPage 22 / 1334.0 * kScreenHeight

//算图片宽度用
#define xForPage 46 / 750.0 * kScreenWidth

//content
#define yForContent 172 / 1334.0 * kScreenHeight
//#define heightForContent 450 / 1334.0 * kScreenHeight
#define heightForContent (630 - 90) / 1334.0 * kScreenHeight

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

@interface JYRemindOtherVC ()<VoiceBarDelegate,UIScrollViewDelegate>
{
    
    UIScrollView *_scrollViewForPeople;
    CGFloat _width;
    UIButton *collectionBtn;
    NSArray *_arrForFriendModel;
    NSMutableArray *_arrForGroupModel;
    NSArray *_titleArr;
    
}

@property (nonatomic ,strong)UIView * addImageView; // <! 存放图片的视图
@property (nonatomic ,strong)NSMutableArray *imagesArray; // <!用于记录添加和删除的照片
@property (nonatomic ,strong)UIView * localView;    // <! 定位完成显示的视图
@property (nonatomic ,strong)NSString *cityString;  // <! 当前定位地址
@property (nonatomic ,assign)CGRect textLineHeight; // <! 当前文本高度

@property (nonatomic ,strong)UIImage *scaleImg;     // <!点击放大的图片

@property (nonatomic,strong) NSMutableArray *voiceBars;

@property (nonatomic,assign) CGRect cityLabelRect;
@property (nonatomic,strong) UIImageView *localIconView;
@property (nonatomic,strong) UILabel *localLabelView;
@end

@implementation JYRemindOtherVC

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
    
    [RequestManager actionForChangeMusicName:_model];
    

    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:@""];
    
}

- (void)actionForLeft:(UIButton *)sender
{
    for(VoiceBarView *tmpBar in self.voiceBars){
        [tmpBar stop];
    }
    [self.voiceBars removeAllObjects];
    
    [collectionBtn removeFromSuperview];
    collectionBtn = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:@""];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _width = (kScreenWidth - xForPage * 2 - 7 * smallPage) / 8.0;
    
    self.imagesArray = [[NSMutableArray alloc]initWithCapacity:10];
    _titleArr = @[@"提醒时间",@"重复",@"铃声选择",@"正点提醒",@"提醒"];
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.title = @"提醒事项";
    
    self.navigationItem.leftBarButtonItem = item;
    
 
    
    _ringID = _model.musicName;
    _isOn = _model.isOn;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _createTitleFiled];
    
    [self _createContentView];
    
    [self _createScrollViewForRemindPeople];
    
    [self _creatTableView];
    
    
    
    if (![self.model.headUrlStr isEqualToString:@""] && ![self.model.headUrlStr isKindOfClass:[NSNull class]] && ![self.model.headUrlStr isEqualToString:@"(null)"] && ![self.model.headUrlStr isEqualToString:@"<null>"] && self.model.headUrlStr != nil){
        
        NSArray * tmpArr = [self.model.headUrlStr componentsSeparatedByString:@","];
        self.imagesArray = [NSMutableArray arrayWithArray:tmpArr];
        NSLog(@"tmpArray:%@",tmpArr);
   
    }    
    
    // 获取文本高度
    CGRect textLineHeight = [self.contentView.text boundingRectWithSize:CGSizeMake(kContentSizeW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.contentView.font} context:nil];
    self.textLineHeight = textLineHeight;
    
    if (![self.model.localInfo isEqualToString:@""] && ![self.model.localInfo isKindOfClass:[NSNull class]] && ![self.model.localInfo isEqualToString:@"(null)"] && ![self.model.localInfo isEqualToString:@"<null>"] && self.model.localInfo != nil) {
        self.cityString = self.model.localInfo;
        [self createLocalView:self.cityString];
        
    }
    
    if (self.imagesArray.count > 0) {
        
        [self createIconImageView:self.imagesArray];   
    }

    [self changContentSize]; 
    
    NSMutableArray *arrForNavbtn = [NSMutableArray array];
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    
    collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(0, 0, 25, 25);
    
    [collectionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //_editBtn.backgroundColor = [UIColor blackColor];
    [collectionBtn addTarget:self action:@selector(actionForCollection) forControlEvents:UIControlEventTouchUpInside];
    
    if (_model.isSave != 0) {
        
         [collectionBtn setImage:[JYSkinManager shareSkinManager].collectionImageAlready forState:UIControlStateNormal];
    }else{
     
         [collectionBtn setImage:[[JYSkinManager shareSkinManager].collectionImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    collectionBtn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;

    [collectionBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, -7)];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:collectionBtn];
    
    [arrForNavbtn addObject:right];
    [arrForNavbtn addObject:rightBar];

    self.navigationItem.rightBarButtonItems = arrForNavbtn;

    [self layoutVoiceBars];
}

- (void)dealloc
{
    NSLog(@"====dealloc");
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
    }}

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
    [Tool actionForCollection:nil remindModel:_model];
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
        self.addImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.addImageView];
        
        
        NSInteger row,column;
        
        for (int i = 0; i < self.imagesArray.count; i ++) {
            
            if (![self.imagesArray[i] isEqualToString:@""] && ([self.imagesArray[i] rangeOfString:@"http"].location != NSNotFound)){
                
                
                row = i/kImageColumnCount;
                column = i%kImageColumnCount;
                
                NSURL * imgUrl = [NSURL URLWithString:self.imagesArray[i]];
//                UIButton * iconView = [[UIButton alloc]init];
                UIImageView *iconView = [UIImageView new];
                iconView.tag = kImageViewBaseTag+i;
                iconView.frame = CGRectMake((kImageViewHeight+kImageHorMargin)*column,row*kImageRowHeight,kImageViewHeight,kImageViewHeight);
                //            [iconView addTarget:self action:@selector(takePhotoAction:) forControlEvents:(UIControlEventTouchUpInside)];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotoAction:)];
                iconView.userInteractionEnabled = YES;
                [iconView addGestureRecognizer:tap];
                
                iconView.clipsToBounds = YES;
                iconView.contentMode = UIViewContentModeScaleAspectFill;
                [iconView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
                
//                [iconView addTarget:self action:@selector(takePhotoAction:) forControlEvents:(UIControlEventTouchUpInside)];
               
//                [iconView.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]]; 
//                iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//                iconView.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                [iconView sd_setImageWithURL:imgUrl forState:(UIControlStateNormal)placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
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
    
}
-(void)takePhotoAction:(UIButton *)sender
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
    
    CGRect rect = self.localView.frame;
    rect.size.width = locallLabel.right + 17/750.0*kScreenWidth;
    self.localView.frame = rect;
    
    
}
#pragma mark 点击定位label显示不全的显示全

- (void)localLabelTapped:(UITapGestureRecognizer *)tap
{
    
    MapViewController *map = [[MapViewController alloc]init];
    map.address = self.cityString;
    map.latitudeStr = self.model.latitudeStr;
    map.longitudeStr = self.model.longitudeStr;
    map.pageType = 2;
    [self presentViewController:map animated:YES completion:nil];
    
//    // 定位视图最大宽、高
//    CGFloat labelWidth = 560/750.0*kScreenWidth;
////    CGFloat labelWidth = self.contentView.contentSize.width-6*kHorSpace;
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
    
    CGFloat tbHeight = heightForCc*3+_scrollViewForPeople.height;
    tbHeight = kScreenHeight - (_contentView.bottom + pageForView + 5)-64;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _contentView.bottom + pageForView + 5, kScreenWidth, tbHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _scrollViewForPeople;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    CGSize size =  _tableView.contentSize;
//    size.height += _scrollViewForPeople.height;
//    _tableView.contentSize = size;
    [_tableView registerNib:[UINib nibWithNibName:@"AddOtherCell" bundle:nil] forCellReuseIdentifier:strForAddOther];
    
    NSString *strForFid = [NSString stringWithFormat:@",%@,",_model.fidStr];
    
    NSString *xiaomi = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *xiaomiID = [NSString stringWithFormat:@",%@,",xiaomi];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollViewForPeople.height, kScreenWidth, 0.5)];
    lineView.backgroundColor = lineColor;
    [_tableView addSubview:lineView];

    
    [Tool actionForHiddenMuchTable:_tableView];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _titleArr.count;
    
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
        cell.titleLabel.text = _titleArr[indexPath.row];
        
        NSString *hour = [Tool actionForTenOrSingleWithNumber:_model.hour];
        NSString *minute = [Tool actionForTenOrSingleWithNumber:_model.minute];
        NSString *month = [Tool actionForTenOrSingleWithNumber:_model.month];
        NSString *day = [Tool actionForTenOrSingleWithNumber:_model.day];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%d.%@.%@  %@:%@",_model.year,month,day,hour,minute];
        
        cell.timeLabel.hidden = NO;
        cell.arrowHead.hidden = YES;
        
//        cell.timeLabel.origin = CGPointMake(cell.arrowHead.left - 15 - 200+ 21, 19.5);
        
    }else if(indexPath.row == 1){
    
        cell.arrowHead.hidden = YES;
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = _titleArr[indexPath.row];
                
        NSString * repeatStr = [Tool actionForReturnRepeatStr:_model];
        
        if ([repeatStr isEqualToString:@""]) {
            cell.timeLabel.text = @"永不";
        }else{
            cell.timeLabel.text = repeatStr;
        }
        
        cell.arrowHead.hidden = YES;
        cell.timeLabel.hidden = NO;

//        cell.timeLabel.origin = CGPointMake(cell.arrowHead.left - 15 - 200, 19.5);
    
    }else if(indexPath.row == 2){
        
        cell.arrowHead.hidden = NO;
        
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = _titleArr[indexPath.row];
        
        RemindModel *model = [[RemindModel alloc] init];
        model.musicName = _ringID;
        
        cell.timeLabel.text = [Tool actionForReturnMusicWithModel:model];
        
        cell.timeLabel.hidden = NO;
        
//        cell.timeLabel.origin = CGPointMake(cell.arrowHead.left - 15 - 200, 19.5);
        
    }else if(indexPath.row == 3){
        cell.arrowHead.hidden = YES;
        cell.timeLabel.hidden = NO;
        cell.switchBtn.hidden = YES;
        cell.titleLabel.text = _titleArr[indexPath.row];
        
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
        

        
//        cell.timeLabel.origin = CGPointMake(cell.arrowHead.left - 15 - 200, 19.5);
    }else{
        cell.arrowHead.hidden = YES;
        
        cell.switchBtn.hidden = NO;
        cell.titleLabel.text = _titleArr[indexPath.row];
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
    self.titleField.userInteractionEnabled = NO;
    self.titleField.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:self.titleField];
    
    self.titleField.text = self.model.title;
    
    
    __weak JYRemindOtherVC *vc = self;
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


- (void)_createScrollViewForRemindPeople
{
    NSString *fidStrNow = _model.fidStr;
    
    NSString *lastFidStr = [fidStrNow substringWithRange:NSMakeRange(fidStrNow.length - 1, 1)];
    if ([lastFidStr isEqualToString:@","]) {
        
        fidStrNow = [fidStrNow substringWithRange:NSMakeRange(0, fidStrNow.length - 1)];
    }
    
    NSString *gidStrNow = _model.gidStr;
    
    NSString *lastGidStr = [gidStrNow substringWithRange:NSMakeRange(gidStrNow.length - 1, 1)];
    if ([lastGidStr isEqualToString:@","]) {
        
        gidStrNow = [gidStrNow substringWithRange:NSMakeRange(0, gidStrNow.length - 1)];
    }
 
    NSArray *arrForFriend = [fidStrNow componentsSeparatedByString:@","];
    NSArray *arrForGroup = [gidStrNow componentsSeparatedByString:@","];
    
    if (arrForGroup.count == 1 && [arrForGroup[0] isEqualToString:@""]) {
        
        arrForGroup = nil;
    }
    
    if (arrForFriend.count == 1 && [arrForFriend[0] isEqualToString:@""]) {
        
        arrForFriend = nil;
    }
    
    NSMutableArray *arrForFriendModel = [NSMutableArray array];
  
    //之前的好友遍历，单独判断fid=uid的情况
    /*
    //判断本地提醒收藏以后不显示头像问题
    if (arrForFriend.count == 1 && [arrForFriend[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]]) {
        FriendModel *model = [[FriendModel alloc] init];
        model.head_url = [[NSUserDefaults standardUserDefaults]objectForKey:kUserHead];
        model.friend_name = [[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
        model.fid = [[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]integerValue];
        [arrForFriendModel addObject:model];
    }else{
        //循环遍历朋友
        for (int i = 0; i < arrForFriend.count; i++) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            FriendModel *model = nil;
            if ([arrForFriend[i] isEqualToString:[userDefaults objectForKey:kUserXiaomiID]]) {
                model = [[FriendModel alloc] init];
                model.head_url = [userDefaults objectForKey:kUserHead];
                model.fid      = [[userDefaults objectForKey:kUserXiaomiID]intValue];
                model.friend_name = [userDefaults objectForKey:kUserName];
                
            }else{
             
                
                FriendListManager *manager = [FriendListManager shareFriend];
                
                model = [manager selectDataWithFid:[arrForFriend[i] integerValue]];
            }
         
            if (model.head_url != nil) {
                
                [arrForFriendModel addObject:model];
                
            }
            
        }
    }
    */
    
    //现在遍历不需要判断，好友列表里包含uid
    FriendListManager *manager = [FriendListManager shareFriend];
    for (int i = 0; i < arrForFriend.count; i++) {

        FriendModel *model = [manager selectDataWithFid:[arrForFriend[i] integerValue]];
        
        if (model.head_url != nil) {
            [arrForFriendModel addObject:model];
        }
    }
    
    
    NSMutableArray *arrForAllPic = [NSMutableArray arrayWithArray:arrForFriendModel];
    _arrForFriendModel = arrForAllPic; //存储Model
    _arrForGroupModel = [NSMutableArray array];
    
    int allArrCount = (int )arrForAllPic.count + (int )arrForGroup.count;
    
    CGFloat heightForScroll = oneHeight;
    CGFloat scrollDistance = 0;
    CGFloat heightForDistance = 0;
    CGFloat yForPage = (oneHeight - _width) / 2.0;
    
    
    //测试
//    allArrCount = 40;
    //根据arr的数量判断是否需要增加
    if (allArrCount > 8 && allArrCount <= 16) {
        
        
        heightForScroll = _width + _width + 3 * yForPage;

    }else if(allArrCount > 16){
     
        
        heightForScroll = _width + _width + _width + 4 * yForPage;
        
    }
    
    if (allArrCount > 24) {
        
        scrollDistance = allArrCount / 8;
      
        heightForDistance = _width * scrollDistance + (scrollDistance + 1)*yForPage;
     }
    
    //滑动
//    _scrollViewForPeople = [[UIScrollView alloc] initWithFrame:CGRectMake(xForTitle, _titleField.bottom + pageForView, kScreenWidth - xForTitle * 2.0, heightForScroll)];
    _scrollViewForPeople = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,heightForScroll)];
//    _scrollViewForPeople.layer.cornerRadius = 3.0;
//    _scrollViewForPeople.layer.masksToBounds = YES;
//    _scrollViewForPeople.layer.borderColor = lineCGColor;
//    _scrollViewForPeople.layer.borderWidth = 0.5;
    _scrollViewForPeople.contentSize = CGSizeMake(0,heightForDistance);
//    [self.view addSubview:_scrollViewForPeople];
    
    
    //所有图片的数量
    for (int i = 0 ; i < allArrCount; i++) {
        
        CGFloat xForPic = bigPage + (i % 8) * (_width + smallPage);
        CGFloat yForPic = (i / 8) * (_width + yForPage) + yForPage;
                
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(xForPic, yForPic, _width, _width)];
        
        imageV.layer.cornerRadius = _width / 2.0;
        imageV.layer.masksToBounds = YES;
        
        NSInteger tag = 0;
        
        //判断是组还是朋友
        if (i >= arrForFriend.count) {
            //            imageV.image = [UIImage imageNamed:@"默认群组头像.png"];
            NSInteger gid = [arrForGroup[i-[arrForFriend count]] integerValue];
            GroupModel *model = [[GroupListManager shareGroup] selectDataWithGid:gid];
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
            tag = 1000 + i - [arrForFriend count];
            [_arrForGroupModel addObject:model];
            
        }else{
         
            FriendModel *model = arrForAllPic[i];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
            tag = i;
        }
        //imageV.backgroundColor = [UIColor orangeColor];
        
        UIButton *imageBtn = [UIButton new];
        imageBtn.frame = CGRectMake(0, 0, imageV.width, imageV.height);
        [imageBtn addTarget:self action:@selector(pushFriendOrGroup:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:imageBtn];
        imageV.userInteractionEnabled = YES;
        imageBtn.tag = tag;
        [_scrollViewForPeople addSubview:imageV];
        
    }
    if(allArrCount==0){
        CGFloat xForPic = bigPage;
        CGFloat yForPic = yForPage;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(xForPic, yForPic, _width, _width)];
        [imageV setImage:[UIImage imageNamed:@"默认用户头像"]];
//        imageV.layer.cornerRadius = _width / 2.0;
//        imageV.layer.masksToBounds = YES;
        [_scrollViewForPeople addSubview:imageV];
    }

}

- (void)pushFriendOrGroup:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    
    if (sender.tag >= 1000) {
        
        GroupModel *model = _arrForGroupModel[sender.tag - 1000];
        
        //朋友关系表
        FriendForGroupListManager *manager = [FriendForGroupListManager shareFriendGroup];
        
        //朋友表
        FriendListManager *fList = [FriendListManager shareFriend];
        NSArray *arrForFriend = [manager selectDataWithGid:model.gid];
        
        NSMutableArray *arrForFmodel = [NSMutableArray array];
        
        for (int i = 0; i < arrForFriend.count; i ++) {
            
            int fid = [arrForFriend[i] intValue];
            
            FriendModel *modelF = [fList selectDataWithFid:fid];
            [arrForFmodel addObject:modelF];
            
        }
        
        //监测点击组
        
        GroupModelVC *group = [[GroupModelVC alloc] init];
        //group.view.backgroundColor = [UIColor whiteColor];
        group.arrForAllFriend = arrForFmodel;
        group.groupName = model.group_name;
        group.gid = model.gid;
        group.groupHeaderUrl = model.groupHeaderUrl;
        
        group.onlyInspect = YES;
        
        [self.navigationController pushViewController:group animated:YES];
        

        
    }else{
        
        FriendModel *model = _arrForFriendModel[sender.tag];
        //好友
        PushFriendViewC *friendVC = [[PushFriendViewC alloc] init];
        
        friendVC.model = model;
        friendVC.view.backgroundColor = [UIColor whiteColor];
        
        if (model.fid != [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]integerValue]) {
            friendVC.showRemarkView = YES;
        }
        friendVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:friendVC animated:YES];
        friendVC.onlyInspect = YES;
        
    }
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
    
    __weak JYRemindOtherVC *vc = self;
    [self.contentView setChangeFrame:^void(BOOL isEditOk){
        
        if (isEditOk) {
            
            //JYLog(@"内容正在编辑");
//            [vc.titleField resignFirstResponder];
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
        
        __weak JYRemindOtherVC *vc = self;
        [musicVC setActionForMusicName:^(int musicName) {
            
            vc.ringID = musicName;
            [vc.tableView reloadData];
            
        }];
        
        [self.navigationController pushViewController:musicVC animated:YES];
        

    }
    
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (scrollView == _scrollViewForPeople) {
        [scrollView resignFirstResponder];
    }
}

@end
