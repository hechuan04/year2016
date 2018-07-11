//
//  PhotoEditorViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/24.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "PhotoEditorViewController.h"
#import "Masonry.h"
#import "ScanUtil.h"
#import "UIImage+Common.h"
#import "UIImageView+WebCache.h"
#import "PhotoEditorTitleView.h"
#import "PhotoSizeTableView.h"
#import "DirectorySelectionView.h"
#import "DXPopover.h"
#import "DirectorySelectionView.h"
#import "TextViewController.h"
#import "ClipMaskView.h"
#import "CameraNavigationController.h"


#define kToolBarHeight 80.f
#define kViewWidth self.view.bounds.size.width
#define kViewHeight self.view.bounds.size.height
#define kSizeTableHorMargin 10.f
#define kSizeTableHeight (kViewHeight-kToolBarHeight-44)

#define kBtnTagRotation 10001
#define kBtnTagClip 10002
#define kBtnTagText 10003
#define kBtnTagFolder 10004
#define kBtnTagCancel 10005

#define kDefaultPixelPerMMWith300DPI 11.8f
#define kDefaultPixelPerMMWith150DPI 5.9f

#define kDefaultFileName @"新文档"
#define kAlertTagNewName 10001
#define kTextFieldTagNewName 10002
#define kMaxTextLength 15
@interface PhotoEditorViewController ()<UIScrollViewDelegate,PhotoEditorTitleViewDelegate,ClipMaskViewDelegate,PhotoSizeTableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *toolBarView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) UIImage *originalImage;
@property (nonatomic,strong) ScanFile *originalFile;

@property (nonatomic,strong) UIImage *editedImage;
@property (nonatomic,strong) ScanFile *editedImageFile;

@property (nonatomic,strong) UIButton *rotationButton;
@property (nonatomic,strong) PhotoEditorTitleView *titleView;
@property (nonatomic,strong) PhotoSizeTableView *sizeTable;
@property (nonatomic,strong) DirectorySelectionView *dirSelectionView;
@property (nonatomic,strong) DXPopover *popover;
@property (nonatomic,strong) ClipMaskView *clipView;
@property (nonatomic,assign) BOOL isClipping;
@property (nonatomic,strong) NSArray *existDirs;
@property (nonatomic,assign) CGFloat maximumZoomScale;
@property (nonatomic,assign) CGFloat minimumZoomScale;
@property (nonatomic,strong) NSArray *sizeArray;
@property (nonatomic,strong) UIButton *fullScreenMaskView;

@end

@implementation PhotoEditorViewController


#pragma mark - Life Cycle

- (instancetype)initWithImage:(UIImage *)image
{
    if(self=[super init]){
        _originalImage = image;
        _isFromCameraVC = YES;
    }
    return self;
}
- (instancetype)initWithScanFile:(ScanFile *)file
{
    if(self=[super init]){
        _originalFile = file;
        _isFromCameraVC = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubviews];
    [self refreshData];
}
- (void)dealloc
{
    NSLog(@"CameraViewController========:dealloc");
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [self adjustImageViewCenter];
//}
#pragma mark - Public


#pragma mark - Private
- (void)setupSubviews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
   //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton sizeToFit];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(editDoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.doneButton];
    
    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.toolBarView];
    [self.view addSubview:self.sizeTable];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kToolBarHeight));
    }];
    [GuideView showGuideWithImageName:@"新手引导页11"];
}

- (void)refreshData
{
    if(self.isFromCameraVC){
        
        self.imageView.image = [self.originalImage copy];
        self.editedImageFile = [ScanFile new];
        self.editedImageFile.imageData = UIImageJPEGRepresentation(self.editedImage, 0.5);
        [self initZoomScale];
        self.titleView.title = kDefaultFileName;
        
    }else{
        self.editedImageFile = [self.originalFile copy];
        self.titleView.title = self.originalFile.name;
        self.imageView.frame = CGRectZero;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.originalFile.imageUrlStr] placeholderImage:[UIImage imageNamed:@"相册默认图片"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.imageView.image = image;
            [self initZoomScale];
        }];
    }

//    [self resizeImageWithIndex:0];
}

- (void)initZoomScale
{
    NSLog(@"image size : %@",[NSValue valueWithCGSize:self.editedImage.size]);
    self.scrollView.zoomScale = 1;
    
    CGFloat widthScale = self.scrollView.bounds.size.width / self.editedImage.size.width;
    CGFloat heightScale = self.scrollView.bounds.size.height / self.editedImage.size.height;
    CGFloat minScale = MIN(widthScale, heightScale);
    
    self.scrollView.contentSize = self.editedImage.size;
    self.imageView.frame = CGRectMake(0, 0, self.editedImage.size.width, self.editedImage.size.height);
    self.scrollView.maximumZoomScale = 3;
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
    [self adjustImageViewCenter];
}
- (void)adjustImageViewCenter
{
    CGFloat yOffset = MAX(0, (self.scrollView.bounds.size.height - self.editedImage.size.height*self.scrollView.zoomScale) / 2);
    CGFloat xOffset = MAX(0, (self.scrollView.bounds.size.width - self.editedImage.size.width*self.scrollView.zoomScale) / 2);
    self.imageView.frame = CGRectMake(xOffset, yOffset, self.editedImage.size.width*self.scrollView.zoomScale, self.editedImage.size.height*self.scrollView.zoomScale);

}
- (void)tapImageView:(UITapGestureRecognizer *)gr
{
    if(self.scrollView.zoomScale == self.scrollView.minimumZoomScale){
        CGPoint p = [gr locationInView:self.imageView];
        CGFloat zoomScale = 2;
        CGFloat zoomWidth = self.imageView.bounds.size.width/zoomScale;
        CGFloat zoomHeight = self.imageView.bounds.size.height/zoomScale;
        CGRect zoomRect = CGRectMake(p.x-zoomWidth/2, p.y-zoomHeight/2, zoomWidth, zoomHeight);
        
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }else{
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}
- (void)goBack
{
    //编辑进入
//    if(self.imageFile){
//        UIViewController *vc = self.navigationController.viewControllers[[self.navigationController.viewControllers count]-3];
//        [self.navigationController popToViewController:vc animated:YES];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}
- (void)editDoneButtonClicked:(UIBarButtonItem *)sender
{
    sender.enabled = NO;
    //有image，新拍的照片
    __weak typeof(self) ws = self;
    if(self.isFromCameraVC){
        
        ScanUploadModel *model = [ScanUploadModel new];
        model.name = self.titleView.titleButton.currentTitle;
        model.fileType = 0;
        model.fileSize = [NSString stringWithFormat:@"%.0f*%.0f",self.editedImage.size.width,self.editedImage.size.height];
        NSData *imgData = UIImageJPEGRepresentation(self.editedImage, 0.4);
        NSLog(@"size:%@=========%.2f",model.fileSize,imgData.length/1024.f/1024.f);
        model.photoDataArray = [NSArray arrayWithObject:imgData];
        model.isSingle = YES;
        if(self.editedImageFile.dirId>0){
            model.dirId = self.editedImageFile.dirId;
        }else{
            NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
            if(defaultId>0){
                model.dirId = defaultId;
            }
        }
        [RequestManager uploadNewFile:model complete:^(id data, NSError *error) {
            sender.enabled = YES;
            __strong typeof(self) ss = ws;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ss.navigationController dismissViewControllerAnimated:NO completion:^{
                    NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
                    if(defaultId>0){
                        CameraNavigationController *navVC = (CameraNavigationController*)ss.navigationController;
                        if(navVC.fromModelVC&&navVC.fromModelVC.navigationController){
                            [navVC.fromModelVC.navigationController popViewControllerAnimated:NO];
                        }
                    }
                }];
            });
        }];
    }else if(!self.isFromCameraVC){//编辑进入
        
        self.editedImageFile.imageData = UIImageJPEGRepresentation(self.editedImage, 0.7);
        self.editedImageFile.name = self.titleView.title;
        NSData *imgData = UIImageJPEGRepresentation(self.editedImage, 0.4);
        NSLog(@"size:%@=========%.2f",self.editedImageFile.fileSize,imgData.length/1024.f/1024.f);
        
        [RequestManager updateFile:self.editedImageFile complete:^(id data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = YES;
                __strong typeof(self) ss = ws;
                if(ss.navigationController&&[ss.navigationController.viewControllers count]>1){
                    
                    UIViewController *vc = ss.navigationController.viewControllers[1];
                    [ss.navigationController popToViewController:vc animated:YES];
                }
            });
 
        }];
    }
    
}

- (void)menuButtonClicked:(UIButton *)sender
{
    sender.highlighted = YES;
    
    if(sender.tag!=kBtnTagClip &&self.isClipping){
        [self endClip];
    }
    
    switch (sender.tag) {
        case kBtnTagRotation:{//旋转
            UIImage *oldImg = self.imageView.image;
            self.imageView.image = [oldImg imageRotatedByDegrees:90];
            [self initZoomScale];
        }
            break;
        case kBtnTagClip:{//裁剪
            
            if(!self.isClipping){
                [self beginClip];
            }else{
                [self endClip];
            }
        }
            break;
        case kBtnTagText:{//文本
            [ProgressHUD show:@"识别中..."];
            
            [RequestManager queryOcr:self.editedImage complete:^(id data, NSError *error) {
                [ProgressHUD dismiss];
                if(data&&![data isKindOfClass:[NSNull class]]&&![data isEqualToString:@"<null>"]){
                    TextViewController *textVC = [TextViewController new];
                    textVC.superViewController = self;
                    self.editedImageFile.textContent = data;
                    self.editedImageFile.name = self.titleView.title;
                    textVC.file = self.editedImageFile;
                    [self.navigationController presentViewController:textVC animated:YES completion:nil];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"识别失败！" message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alertView show];
                    
                }
            }];
        }
            break;
        case kBtnTagFolder:{//文件夹
            CGRect rect = [self.view convertRect:sender.frame fromView:self.toolBarView];
            CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)+20);
            [self.popover showAtPoint:startPoint
                       popoverPostion:DXPopoverPositionUp
                      withContentView:self.dirSelectionView
                               inView:self.navigationController.view];
        }
            break;
        case kBtnTagCancel:{//取消
            [self refreshData];
            [self.dirSelectionView resetSelectionState];
            [self.sizeTable resetSelectionState];
        }
            break;
            
        default:
            break;
    }
}
- (void)beginClip
{
    self.isClipping = YES;
    
    [self initZoomScale];
    [self.clipView show];
    [self lockZoom];
}
- (void)endClip
{
    self.isClipping = NO;
    [self.clipView hide];
    [self unlockZoom];
}
-(void)lockZoom
{
    self.maximumZoomScale = self.scrollView.maximumZoomScale;
    self.minimumZoomScale = self.scrollView.minimumZoomScale;
    
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}

-(void)unlockZoom
{
    
    self.scrollView.maximumZoomScale = self.maximumZoomScale;
    self.scrollView.minimumZoomScale = self.minimumZoomScale;
    
}
- (void)showOrHideSizeTableView
{
    CGRect rect = self.sizeTable.frame;
    rect.origin.y = rect.origin.y<0?0:-kViewHeight;
    [UIView animateWithDuration:0.5 animations:^{
        self.sizeTable.frame = rect;
    }];
    
    if(rect.origin.y==0){
        [self.view insertSubview:self.fullScreenMaskView belowSubview:self.sizeTable];
        self.doneButton.enabled = NO;
    }else{
        [self.fullScreenMaskView removeFromSuperview];
        self.doneButton.enabled = YES;
    }
}
- (void)resizeImageWithIndex:(NSInteger)index
{
//    [SVProgressHUD showWithStatus:@"处理中"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        NSLog(@"%@",self.sizeTable.sizeArray[index]);
        NSString *sizeStr = self.sizeTable.sizeArray[index];
        NSArray *tmpArr = [sizeStr componentsSeparatedByString:@"x"];
        if([tmpArr count]>=2){
            CGFloat width = ceilf([tmpArr[0] floatValue] * kDefaultPixelPerMMWith150DPI);
            CGFloat height = ceilf([tmpArr[1] floatValue] * kDefaultPixelPerMMWith150DPI);
            
            UIImage *image = [UIImage compressImage:self.editedImage toSize:CGSizeMake(width, height)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
                self.imageView.image = image;
                [self initZoomScale];
            });
        }
//    });
}
#pragma mark - Protocol
#pragma mark PhotoEditorTitleViewDelegate
- (void)titleButtonClicked:(PhotoEditorTitleView *)titleView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.text = self.titleView.title;
    tf.delegate = self;
    tf.tag = kTextFieldTagNewName;
    alertView.tag = kAlertTagNewName;
//    [tf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                name:UITextFieldTextDidChangeNotification   object:tf];

    [alertView show];
    
}
- (void)pullDownButtonClicked:(PhotoEditorTitleView *)titleView
{
    [self showOrHideSizeTableView];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kAlertTagNewName){
        
        UITextField *tf=[alertView textFieldAtIndex:0];
        [tf resignFirstResponder];
        if(buttonIndex==1){
            self.editedImageFile.name = tf.text;
            self.titleView.title = tf.text;
        }
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{ 
    if(alertView.tag == kAlertTagNewName){
        UITextField *tf=[alertView textFieldAtIndex:0];
        if(tf.text.length==0){
            return NO;
        }
        return YES;
    }
    return YES;
}
#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if(textField.tag == kTextFieldTagNewName){
//        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        return (newLength > 15) ? NO : YES;
//    }
//    return YES;
//}
//- (void)textFieldDidChanged:(UITextField *)sender
//{
//    if([sender.text length]>15){
//        sender.text = [sender.text substringToIndex:15];
//    }
//}
- (void)textFieldDidChange:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField.tag == kTextFieldTagNewName) {
        
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
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self adjustImageViewCenter];
}

- (void)clipMaskView:(ClipMaskView *)clipMaskView clippedWithRect:(CGRect)rect
{
    [self endClip];
    
    CGRect convertRect = [self.scrollView convertRect:rect toView:self.imageView];
    NSLog(@"\nimage:%@\norgin:%@\nconvert:%@",[NSValue valueWithCGSize:self.editedImage.size],[NSValue valueWithCGRect:rect],[NSValue valueWithCGRect:convertRect]);
    UIImage *img = self.imageView.image;
    
    self.imageView.image = [img getSubImage:convertRect];
    [self initZoomScale];

}
#pragma mark PhotoSizeTableViewDelegate

- (void)photoSizeTableView:(PhotoSizeTableView *)tableView hidenWithSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self pullDownButtonClicked:nil];
    [self resizeImageWithIndex:indexPath.row];
}
#pragma mark - Custom Accessors
- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        tap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}
- (UIImage *)editedImage
{
    return self.imageView.image;
}
- (UIView *)toolBarView
{
    if(!_toolBarView){
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,kViewHeight-self.navigationController.navigationBar.bounds.size.height-kToolBarHeight, kViewWidth, kToolBarHeight)];
        
        NSArray *imageNames = @[@"扫描_旋转",@"扫描_裁剪",@"扫描_文本",@"扫描_文件夹",@"扫描_取消"];
        NSArray *menuNames = @[@"旋转",@"剪裁",@"文本",@"添加到",@"取消"];
        NSArray *tags = @[@(kBtnTagRotation),@(kBtnTagClip),@(kBtnTagText),@(kBtnTagFolder),@(kBtnTagCancel)];
        
        UIView *leftView = nil;
        
        for(int i=0;i<[menuNames count];i++){
            
            UIButton *btn = [UIButton new];
            btn.tag = [tags[i] integerValue];
            btn.tintColor = [UIColor colorWithRGBHex:0xFF342B];
            [btn setTitle:menuNames[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRGBHex:0xFF342B] forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            UIImage *img = [UIImage imageNamed:imageNames[i]];
            [btn setImage:img forState:UIControlStateNormal];
            [btn setImage:[[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-10, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBarView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if(leftView){
                    make.left.equalTo(leftView.mas_right);
                    make.width.equalTo(leftView);
                }else{
                    make.left.equalTo(_toolBarView);
                }
                if(i==[menuNames count]-1){
                    make.right.equalTo(_toolBarView.mas_right);
                }
                make.centerY.equalTo(_toolBarView);
                make.height.equalTo(@(50.f));
            }];
            leftView = btn;
        }

        

    }
    return _toolBarView;
}
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight-self.navigationController.navigationBar.bounds.size.height-kToolBarHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (PhotoEditorTitleView *)titleView
{
    if(!_titleView){
        _titleView = [[PhotoEditorTitleView alloc]initWithFrame:CGRectMake(0, 0, 240, 40)];
        _titleView.delegate = self;
    }
    return _titleView;
}
- (PhotoSizeTableView *)sizeTable
{
    if(!_sizeTable){
        CGFloat tableHeight = MIN(kSizeTableHeight,[PhotoSizeTableView rowHeight]*[self.sizeArray count]);
        _sizeTable = [[PhotoSizeTableView alloc]initWithFrame:CGRectMake(kSizeTableHorMargin,-kViewHeight, kViewWidth-kSizeTableHorMargin*2, tableHeight)];
        _sizeTable.layer.cornerRadius = 5.f;
        _sizeTable.layer.masksToBounds = YES;
        _sizeTable.sizeArray = self.sizeArray;
        _sizeTable.sizeDelegate = self;
        _sizeTable.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9f];
//        __weak typeof(self) ws = self;
//        _sizeTable.selectRowBlock = ^(NSIndexPath *indexPath){
//            
////             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//           
//                [ws pullDownButtonClicked:nil];
//                [ws resizeImageWithIndex:indexPath.row];
//            
////             });
//        };
    }
    return _sizeTable;
}
- (UIButton *)fullScreenMaskView
{
    if(!_fullScreenMaskView){
        _fullScreenMaskView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _fullScreenMaskView.backgroundColor = [UIColor clearColor];
        [_fullScreenMaskView addTarget:self action:@selector(showOrHideSizeTableView) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenMaskView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _fullScreenMaskView;
}
- (DirectorySelectionView *)dirSelectionView
{
    if(!_dirSelectionView){
        NSInteger userId = [[NSUserDefaults standardUserDefaults] floatForKey:kUserXiaomiID];
        NSArray *dirs = [[ScanUtil sharedInstance] findAllDirsWithUserId:userId];
        _dirSelectionView = [[DirectorySelectionView alloc]initWithFrame:CGRectMake(0, 0, 240, 350)];
        _dirSelectionView.dirs = dirs;
        CGRect frame = _dirSelectionView.frame;
        
        frame.size.height = MIN(600*kScreenHeight/736,[dirs count]*_dirSelectionView.rowHeight+10);
         __weak typeof(self) ws = self;
        _dirSelectionView.selectRowBlock = ^(NSInteger selectedDirId){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(){
                ws.editedImageFile.dirId = selectedDirId;
                [ws.popover dismiss];
            });
        };
    }
    return _dirSelectionView;
}
- (DXPopover *)popover
{
    if(!_popover){
        _popover = [DXPopover new];
        _popover.contentInset = UIEdgeInsetsZero;
        _popover.backgroundColor = [UIColor whiteColor];
    }
    return _popover;
}
- (ClipMaskView *)clipView
{
    if(!_clipView){
        _clipView = [[ClipMaskView alloc]initWithContainerView:self.scrollView];
        _clipView.delegate = self;
    }
    return _clipView;
}
- (NSArray *)sizeArray
{
    if(!_sizeArray){
//        _sizeArray = @[@"211x298",@"216x280",@"216x356",@"298x419",@"149x211",@"432x280",@"280x432",@"85x55"];
        //将名片尺寸跳大一倍
        _sizeArray = @[@"211x298",@"216x280",@"216x356",@"298x419",@"149x211",@"432x280",@"280x432",@"170x110"];
    }
    return _sizeArray;
}
@end
