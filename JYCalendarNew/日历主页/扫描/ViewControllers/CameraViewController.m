//
//  CameraViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/23.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "CameraViewController.h"
#import "Masonry.h"
#import "PhotoEditorViewController.h"
#import "PhotoPreviewViewController.h"
#import "CameraView.h"
#import "CameraNavigationController.h"

#define kModeBtnWidth 80.f
#define kModeBtnHeight 25.f
@interface CameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIView *bottomView;
//@property (nonatomic,strong) GPUImageView *captureView;
@property (nonatomic,strong) CameraView *captureView;
@property (nonatomic,strong) UIView *focusIndicator;
@property (nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong) UIButton *captureButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *albumButton;
@property (nonatomic,strong) UILabel *photoCountLabel;
@property (nonatomic,strong) UIView *pointView;
@property (nonatomic,strong) UIScrollView *modeOptionScrollView;
@property (nonatomic,strong) UIButton *singleModeButton;
@property (nonatomic,strong) UIButton *multiModeButton;
@property (nonatomic,strong) NSMutableArray *photoDataArray;

//@property (nonatomic,strong) GPUImageStillCamera *stillCamera;
//@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *blackWhiteFilter;
//@property (nonatomic,strong) GPUImageBilateralFilter *tmpFilter;

@property (nonatomic,strong) UISwipeGestureRecognizer *leftRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *rightRecognizer;
@end

@implementation CameraViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self setupSubview];
    
    [self setupGesture];
//    [self setupCamera];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.multiModeButton.selected){
        self.modeOptionScrollView.contentOffset = CGPointMake(kModeBtnWidth,0);
    }
    [self.captureView start];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureView stop];
}

#pragma mark - Private
- (void)setupSubview
{
    self.navigationItem.titleView = self.segmentControl;
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.bottomView];
    [self.captureView addSubview:self.focusIndicator];
    
    [self.captureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captureView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(130.f));
    }];
    
    [GuideView showGuideWithImageName:@"新手引导页10"];
}
- (void)setupGesture
{
    self.view.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureTrigger:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftRecognizer];
    self.leftRecognizer = leftRecognizer;
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureTrigger:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightRecognizer];
    self.rightRecognizer = rightRecognizer;
    
    self.captureView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusTap:)];
    [self.captureView addGestureRecognizer:tap];
    
}

//- (void)setupCamera
//{
//    _stillCamera = [[GPUImageStillCamera alloc] init];
//    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    
//    _tmpFilter = [[GPUImageBilateralFilter alloc] init];
//    [_tmpFilter addTarget:self.captureView];
//    [_stillCamera addTarget:_tmpFilter];
//    
//    [_stillCamera startCameraCapture];
//}
- (void)focusTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [sender locationInView:self.captureView];
        
        [self focusIndicatorAnimateToPoint:location];
        [self.captureView focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}
- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint
{
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.focusIndicator.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4 animations:^
          {
              self.focusIndicator.alpha = 0.0;
          }];
     }];
}
- (void)albumButtonClicked:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)rightButtonClicked:(UIButton *)sender
{
    if([sender.currentTitle isEqualToString:@"取消"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if([sender.currentTitle isEqualToString:@"完成"]){
        sender.enabled = NO;
        [ProgressHUD show:@"保存中..."];
        ScanUploadModel *model = [ScanUploadModel new];
        model.fileType = 0;
        UIImage *img = [UIImage imageWithData:[self.photoDataArray firstObject]];
//        CGFloat scale = [UIScreen mainScreen].scale;
        model.name = @"新文档";
        NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
        if(defaultId>0){
            model.dirId = defaultId;
        }
        model.fileSize = [NSString stringWithFormat:@"%.0f*%.0f",img.size.width,img.size.height];
        model.photoDataArray = self.photoDataArray;
        //有image，新拍的照片
        model.isSingle = NO;
        __weak typeof(self) ws = self;
        [RequestManager uploadNewFile:model complete:^(id data, NSError *error) {
            [ProgressHUD dismiss];
            sender.enabled = YES;
            __strong typeof(self) ss = ws;
            [ss dismissViewControllerAnimated:YES completion:^{
                NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
                if(defaultId>0){
                    CameraNavigationController *navVC = (CameraNavigationController*)ss.navigationController;
                    if(navVC.fromModelVC&&navVC.fromModelVC.navigationController){
                        [navVC.fromModelVC.navigationController popViewControllerAnimated:NO];
                    }
                }
            }];
        }];
    }
}
- (void)swipeGestureTrigger:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self multiModeButtonClicked:nil];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self singleModeButtonClicked:nil];
    }
}
- (void)singleModeButtonClicked:(UIButton *)sender
{
    if(sender.selected){
        return;
    }
    self.singleModeButton.selected = YES;
    self.multiModeButton.selected = NO;
    
    [self.photoDataArray removeAllObjects];
    self.photoCountLabel.text = @"0";
    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"扫描_取消"] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.25 animations:^{
        self.photoCountLabel.alpha = 0;
        self.modeOptionScrollView.contentOffset = CGPointMake(0,0);
    }];
    
}
- (void)multiModeButtonClicked:(UIButton *)sender
{
    if(sender.selected){
        return;
    }
    self.multiModeButton.selected = YES;
    self.singleModeButton.selected = NO;
   [UIView animateWithDuration:0.25 animations:^{
       self.modeOptionScrollView.contentOffset = CGPointMake(kModeBtnWidth,0);
       self.photoCountLabel.alpha = 1;
   }];
}

- (void)captureButtonClicked:(UIButton *)sender
{
    if(self.multiModeButton.selected){
        if([self.photoDataArray count]>=20){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可拍摄照片数量已达上限!" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        self.singleModeButton.enabled = NO;
        self.leftRecognizer.enabled = NO;
        self.rightRecognizer.enabled = NO;
        self.modeOptionScrollView.scrollEnabled = NO;
    }
    
    sender.enabled = NO;

    
    __weak typeof(self) ws = self;
//    if(self.segmentControl.selectedSegmentIndex == 1){
//        [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.blackWhiteFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
//            
//            [ws dealThePhoto:processedJPEG];
//        }];
//    }else{
//        [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.tmpFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
//            [ws dealThePhoto:processedJPEG];
//            
//        }];
//    }
    [self.captureView captureImageWithCompletionHander:^(NSString *imageFilePath)
     {
//         NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
         UIImage *img = [UIImage imageWithContentsOfFile:imageFilePath];
         img = [img scaledToSize:CGSizeMake(1080, 1920)];
         NSData *data = UIImageJPEGRepresentation(img, 0.5);
         NSLog(@"File size is : %.2f MB",(float)data.length/1024.0f/1024.0f);
         ws.captureButton.enabled = YES;
         [ws dealThePhoto:data];
     }];
    
}
- (void)dealThePhoto:(NSData *)data
{
    //单张拍摄模式
    if(self.singleModeButton.selected){
        [self pushToPreviewVCWithData:data];
        
    }else if(self.multiModeButton.selected){
        
        [self.photoDataArray addObject:data];
        
        NSInteger count = [self.photoCountLabel.text integerValue];
        count = count + 1;
        self.photoCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"扫描_保存"] forState:UIControlStateNormal];
        
    }
    
}
//- (void)segmentControlClicked:(UISegmentedControl *)segmentedControl
//{
//    
//    [self.stillCamera removeAllTargets];
//    [self.blackWhiteFilter removeAllTargets];
//    [self.tmpFilter removeAllTargets];
//    
//    if(segmentedControl.selectedSegmentIndex==0){
//        if(!_tmpFilter){
//            _tmpFilter = [[GPUImageBilateralFilter alloc] init];
//        }
//        [_tmpFilter addTarget:self.captureView];
//        [_stillCamera addTarget:_tmpFilter];
//        
//    }else if(segmentedControl.selectedSegmentIndex==1){
//        if(!_blackWhiteFilter){
//            _blackWhiteFilter = [[GPUImageErosionFilter alloc] init];
//        }
//        [_blackWhiteFilter addTarget:self.captureView];
//        [_stillCamera addTarget:_blackWhiteFilter];
//    }
//}
- (void)segmentControlClicked:(UISegmentedControl *)segmentedControl
{
    if(segmentedControl.selectedSegmentIndex==0){
        [self.captureView setCameraViewType:IPDFCameraViewTypeBlackAndWhite];
        
    }else if(segmentedControl.selectedSegmentIndex==1){
        [self.captureView setCameraViewType:IPDFCameraViewTypeNormal];
    }
}
- (void)pushToPreviewVCWithData:(NSData *)data
{
    PhotoPreviewViewController *previewVC = [[PhotoPreviewViewController alloc]init];
    previewVC.photoData = data;
    [self.navigationController pushViewController:previewVC animated:YES];
}
#pragma mark - Protocol
#pragma mark UIImagePickerControllerDelegate methods
//完成选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //加载图片
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:^{
        PhotoPreviewViewController *previewVC = [[PhotoPreviewViewController alloc]init];
        previewVC.photoData = data;
        [self.navigationController pushViewController:previewVC animated:YES];
    }];
}
//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
   
}
#pragma mark - Custom Accessors
- (UISegmentedControl *)segmentControl
{
    if(!_segmentControl){
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"黑白",@"彩色"]];
        [segmentControl setTintColor:[UIColor lightGrayColor]];
        [segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
        [segmentControl setSelectedSegmentIndex:0];
        [segmentControl addTarget:self action:@selector(segmentControlClicked:) forControlEvents:UIControlEventValueChanged];
        _segmentControl = segmentControl;
    }
    return _segmentControl;
}
//- (GPUImageView *)captureView
//{
//    if(!_captureView){
//        _captureView = [GPUImageView new];
//        _captureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _captureView.backgroundColor = [UIColor darkGrayColor];
//    }
//    return _captureView;
//}
- (CameraView *)captureView
{
    if(!_captureView){
        _captureView = [CameraView new];
        _captureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _captureView.backgroundColor = [UIColor darkGrayColor];
        [_captureView setupCameraView];
        [_captureView setEnableBorderDetection:NO];
        _captureView.clipsToBounds = YES;
    }
    return _captureView;
}
- (UIView *)focusIndicator
{
    if(!_focusIndicator){
        _focusIndicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusIndicator.layer.borderColor = [UIColor colorWithRGBHex:0x8BC9F9].CGColor;
        _focusIndicator.layer.borderWidth = 2.f;
        _focusIndicator.alpha = 0;
    }
    return _focusIndicator;
}
- (UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [UIView new];
        
        //小红点
        CGFloat pointWidth = 10.f;
        UIView *pointView = [UIView new];
        pointView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
        pointView.layer.cornerRadius = pointWidth / 2.f;
        pointView.layer.masksToBounds = YES;
        [_bottomView addSubview:pointView];
        
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.width.height.equalTo(@(pointWidth));
            make.top.equalTo(_bottomView).offset(10.f);
        }];

        //模式选择滚动条
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(kModeBtnWidth*2,kModeBtnHeight);
        [_bottomView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pointView.mas_bottom);
            make.centerX.equalTo(pointView);
            make.height.equalTo(@(kModeBtnHeight));
            make.width.equalTo(@(kModeBtnWidth*3));
        }];
        
        //单张模式
        UIButton *singleModeButton = [[UIButton alloc]initWithFrame:CGRectMake(kModeBtnWidth, 0,kModeBtnWidth,kModeBtnHeight)];
        [singleModeButton setTitle:@"单张模式" forState:UIControlStateNormal];
        singleModeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [singleModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [singleModeButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1] forState:UIControlStateSelected];
        [singleModeButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1] forState:UIControlStateSelected|UIControlStateHighlighted];
        [singleModeButton setSelected:YES];
        [singleModeButton addTarget:self action:@selector(singleModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:singleModeButton];
        
        //多张模式
        UIButton *multiModeButton = [[UIButton alloc]initWithFrame:CGRectMake(kModeBtnWidth*2, 0,kModeBtnWidth,kModeBtnHeight)];
        [multiModeButton setTitle:@"多张模式" forState:UIControlStateNormal];
        multiModeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [multiModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [multiModeButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1] forState:UIControlStateSelected];
        [multiModeButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1] forState:UIControlStateSelected | UIControlStateHighlighted];
        multiModeButton.showsTouchWhenHighlighted = NO;
        [multiModeButton addTarget:self action:@selector(multiModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:multiModeButton];
        
        //拍摄按钮
        UIButton *captureButton = [UIButton new];
        [captureButton setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
        [captureButton addTarget:self action:@selector(captureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:captureButton];
        [captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.top.equalTo(scrollView.mas_bottom).offset(5);
            make.width.height.equalTo(@(67.f));
        }];
        
        //相册按钮
        UIButton *albumButton = [UIButton new];
        [albumButton setTitle:@"相册" forState:UIControlStateNormal];
        albumButton.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *img = [UIImage imageNamed:@"扫描_相册"];
        [albumButton setImage:img forState:UIControlStateNormal];
        albumButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
        albumButton.imageEdgeInsets = UIEdgeInsetsMake(-albumButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -albumButton.titleLabel.intrinsicContentSize.width);
        albumButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [albumButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:albumButton];
        
        [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(captureButton);
            make.left.equalTo(_bottomView).mas_offset(20.f);
            make.height.equalTo(@(50.f));
        }];
        
        //右边按钮（取消，保存）
        UIButton *rightButton = [UIButton new];
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        img = [UIImage imageNamed:@"扫描_取消"];
        [rightButton setImage:img forState:UIControlStateNormal];
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(-rightButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -rightButton.titleLabel.intrinsicContentSize.width);
        albumButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:rightButton];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView).mas_offset(-20.f);
            make.centerY.equalTo(captureButton);
            make.height.equalTo(@(50.f));
        }];

        UILabel *countLabel = [UILabel new];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.layer.cornerRadius = 10.f;
        countLabel.layer.masksToBounds = YES;
        countLabel.backgroundColor = [UIColor whiteColor];
        countLabel.textColor = [UIColor blackColor];
        countLabel.text = @"0";
        countLabel.alpha = 0;
        [_bottomView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(captureButton);
            make.left.equalTo(captureButton.mas_right);
            make.width.greaterThanOrEqualTo(@(35.f));
            make.height.equalTo(@(20.f));
        }];
        
        
        _photoCountLabel = countLabel;
        _captureButton = captureButton;
        _albumButton = albumButton;
        _rightButton = rightButton;
        _pointView = pointView;
        _modeOptionScrollView = scrollView;
        _singleModeButton = singleModeButton;
        _multiModeButton = multiModeButton;
    }
    return _bottomView;
}
- (NSMutableArray *)photoDataArray
{
    if(!_photoDataArray){
        _photoDataArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _photoDataArray;
}
@end
