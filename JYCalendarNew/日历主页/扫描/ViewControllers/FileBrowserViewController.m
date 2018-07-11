//
//  FileBrowserViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "FileBrowserViewController.h"
#import "ScanFile.h"
#import "ScanFileCell.h"
#import "ImageBrowserViewController.h"
#import "MWPhotoBrowser.h"
#import "Masonry.h"
#import "PhotoEditorViewController.h"
#import "ScanUtil.h"
#import "PhotoEditorTitleView.h"
#import "TextViewController.h"
#import "FCFileManager.h"
#import "CameraNavigationController.h"

#define kCellMargin 15.f
#define kCollectionMargin 15.f
#define kViewWidth self.view.bounds.size.width
#define kViewHeight self.view.bounds.size.height

#define kBtnTagAllSelected 20001
#define kBtnTagShare 20002
#define kBtnTagDelete 20003

#define kAlertTagEditTitle 30001
#define kAlertTagForDelete 30002
#define kTextFieldTagNewName 10002
#define kMaxTextLength 15

static NSString *kCellIdentifierNormal = @"kCellIdentifierNormal";

@interface FileBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,PhotoEditorTitleViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSArray *files;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *photoFiles;
@property (nonatomic,strong) PhotoEditorTitleView *titleView;
@property (nonatomic,strong) UIView *editToolBar;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,assign) BOOL isEditing;
//@property (nonatomic,strong) NSMutableArray *checkedFileIDs;
@property (nonatomic,strong) NSMutableArray *checkedFiles;
@property (nonatomic,strong) MASConstraint *bottomConstraint;
@property (nonatomic,strong) UIButton *selectAllButton;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,assign) BOOL hasLoadData;
@property (nonatomic,strong) UIActivityViewController *activityViewController;
@property (nonatomic,strong) UIImageView *emptyView;

@end

@implementation FileBrowserViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    //导航
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [leftBtn addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    [ProgressHUD show:@"加载中..."];
    //标题
    self.navigationItem.titleView = self.titleView;
    self.titleView.title = self.directory.name;
    
    //主体视图
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.editToolBar];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.editToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60.f);
        self.bottomConstraint = make.bottom.equalTo(self.view).offset(60);
    }];
    
    //空视图
    [self.view addSubview:self.emptyView];
    self.emptyView.center = CGPointMake(kScreenWidth/2.f,kScreenHeight/2.f-100);
    
   }
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage = [[UIColor colorWithRGBHex:0xdddddd] image];
    self.navigationController.navigationBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    if(self.directory&&!self.hasLoadData){
        self.files = [[ScanUtil sharedInstance]findAllFilesWithDirId:self.directory.dirId];
        self.titleView.title = [NSString stringWithFormat:@"%@",self.directory.name];
        [self.collectionView reloadData];
        self.hasLoadData = YES;
        
        self.editButton.hidden = ([self.files count]==0);
        self.emptyView.hidden = ([self.files count]>0);
        
        if(self.files==0){
            UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
            self.navigationItem.rightBarButtonItem = addItem;
        }else{
            UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
            UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
            self.navigationItem.rightBarButtonItems = @[editItem,addItem];
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [ProgressHUD dismiss];
                       });
    }

    
}
- (void)dealloc
{
    [[SDImageCache sharedImageCache] clearMemory];
    NSLog(@"ScanMainViewController========:dealloc");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}
#pragma mark - Public
#pragma mark - Private
- (void)actionForLeft:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editBtnClicked:(UIButton *)sender{
    [self changeEditStatus];
    
    [GuideView showGuideWithImageName:@"新手引导页12"];
}
- (void)longPressToDo:(UIGestureRecognizer *)recognizer
{
    if(recognizer.state==UIGestureRecognizerStateBegan){
        [self changeEditStatus];
    }
}
- (void)changeEditStatus{
    
    if(!_isEditing){
        [self beginEdit];
    }else{
        [self endEdit];
    }
}
- (void)beginEdit
{
    _isEditing = YES;
    self.editButton.selected = YES;
    [UIView animateWithDuration:0.35f animations:^{
        self.bottomConstraint.offset = 0;
    }];

    self.selectAllButton.selected = NO;
    [self.checkedFiles removeAllObjects];
    [self.collectionView reloadData];
}
- (void)endEdit
{
    _isEditing = NO;
    self.editButton.selected = NO;
    [UIView animateWithDuration:0.35f animations:^{
        self.bottomConstraint.offset = 60;
    }];
    self.selectAllButton.selected = NO;
    [self.checkedFiles removeAllObjects];
    [self.collectionView reloadData];
}
- (void)deleteCheckedFiles
{
    NSMutableArray *checkedIds = [NSMutableArray arrayWithCapacity:[self.checkedFiles count]];
    for(int i=0;i<[self.checkedFiles count];i++){
        ScanFile *file = self.checkedFiles[i];
        [checkedIds addObject:@(file.fileId)];
    }
    NSString *fidStr = [checkedIds componentsJoinedByString:@","];
    __weak typeof(self) ws = self;
    [ProgressHUD show:@"删除中..."];
    [RequestManager deleteFilesWithFileIdStr:fidStr complete:^(id data, NSError *error) {
        ws.files = [[ScanUtil sharedInstance]findAllFilesWithDirId:self.directory.dirId];
        [ws changeEditStatus];
        [ProgressHUD dismiss];
        ws.editButton.hidden = ([ws.files count]==0);
        ws.emptyView.hidden = ([ws.files count]>0);
        if(ws.files==0){
            UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
            ws.navigationItem.rightBarButtonItem = addItem;
        }else{
            UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
            UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
            ws.navigationItem.rightBarButtonItems = @[editItem,addItem];
        }

    }];
}
- (void)showEditNameAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = kAlertTagEditTitle;
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.text = self.titleView.title;
    tf.tag = kTextFieldTagNewName;
    tf.delegate = self;
//    [tf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                name:UITextFieldTextDidChangeNotification   object:tf];
    [alertView show];
}

- (void)menuButtonClicked:(UIButton *)sender
{
    switch (sender.tag) {
            
        case kBtnTagAllSelected:{
            //已经全选取消全选
            if([self.checkedFiles count]==[self.files count]){
                [self.checkedFiles removeAllObjects];
                sender.selected = NO;
            }else{//全选
                sender.selected = YES;
                [self.checkedFiles removeAllObjects];
                [self.checkedFiles addObjectsFromArray:self.files];
            }
            [self.collectionView reloadData];
        }
            break;
        case kBtnTagShare:{
            [self shareFiles];
        }
            break;
        case kBtnTagDelete:{
            if([self.checkedFiles count]==0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未勾选任何文件!" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确认删除所选文件?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = kAlertTagForDelete;
                [alert show];
            }
            
        }
            break;
        default:
            break;
    }
}
- (void)shareFiles
{
    
    if([self.checkedFiles count]==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未勾选任何文件!" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:self.checkedFiles applicationActivities:nil];
    self.activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypePrint];
    
    typeof(self) __weak weakSelf = self;
    [self.activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        weakSelf.activityViewController = nil;
        if(completed){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endEdit];
            });
        }
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        self.activityViewController.popoverPresentationController.sourceView = self.shareButton;
    }
    [self presentViewController:self.activityViewController animated:YES completion:nil];

}
- (void)addBtnClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.directory.dirId forKey:kDefaultDirId];
    [[NSUserDefaults standardUserDefaults] synchronize];

    CameraNavigationController *cameraNav = [[CameraNavigationController alloc]init];
    cameraNav.fromModelVC = self;
    [self presentViewController:cameraNav animated:YES completion:nil];
}
#pragma mark - Protocol
#pragma mark PhotoEditorTitleViewDelegate
- (void)titleButtonClicked:(PhotoEditorTitleView *)titleView
{
    [self showEditNameAlertView];
}
- (void)pullDownButtonClicked:(PhotoEditorTitleView *)titleView
{
    [self showEditNameAlertView];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==kAlertTagEditTitle){
        
        UITextField *tf=[alertView textFieldAtIndex:0];
        [tf resignFirstResponder];
        
        if(buttonIndex==1){
            self.titleView.title = [NSString stringWithFormat:@"%@",tf.text];
            [RequestManager updateDirectoryWithDirId:self.directory.dirId name:tf.text complete:^(id data, NSError *error) {
            }];
        }
    }else if(alertView.tag==kAlertTagForDelete){
        if(buttonIndex==1){
            [self deleteCheckedFiles];
        }
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag==kAlertTagEditTitle){
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
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.files count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScanFileCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierNormal forIndexPath:indexPath];
    ScanFile *file = self.files[indexPath.row];
    cell.file = file;
    cell.isEditing = self.isEditing;
    cell.isSelected = [self.checkedFiles containsObject:file];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isEditing){
        ScanFile *file = self.files[indexPath.row];
//        NSInteger fid = file.fileId;
        if([self.checkedFiles containsObject:file]){
            [self.checkedFiles removeObject:file];
        }else{
            [self.checkedFiles addObject:file];
        }
        //是否全选
        if([self.checkedFiles count]==[self.files count]){
            self.selectAllButton.selected = YES;
        }else{
            self.selectAllButton.selected = NO;
        }
        [self.collectionView reloadData];
        
    }else{
        ScanFile *file = self.files[indexPath.row];
        
        if(file.type==0){
    
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = NO;
            browser.enableGrid = NO;
            browser.startOnGrid = NO;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = NO;
            [browser setCurrentPhotoIndex:indexPath.row];
            browser.delayToHideElements = 1000;
            [self.navigationController pushViewController:browser animated:YES];

        }else if(file.type==1){
            TextViewController *txtVC = [[TextViewController alloc]init];
            txtVC.file = file;
            txtVC.superViewController = self;
            [self.navigationController presentViewController:txtVC animated:YES completion:nil];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.photos[index];
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    ScanFile *file = self.photoFiles[index];
    return file.name;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
    
    ScanFile *file = self.photoFiles[index];
    PhotoEditorViewController *editorVC = [[PhotoEditorViewController alloc]initWithScanFile:file];
    [self.navigationController pushViewController:editorVC animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editorVC];
//    [photoBrowser.navigationController presentViewController:nav animated:YES completion:nil];

}
#pragma mark - Custom Accessors
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ScanFileCell class] forCellWithReuseIdentifier:kCellIdentifierNormal];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [_collectionView addGestureRecognizer:longPressGr];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = kCellMargin;
        _flowLayout.minimumInteritemSpacing = kCellMargin;
        _flowLayout.sectionInset = UIEdgeInsetsMake(kCollectionMargin, kCollectionMargin, kCollectionMargin, kCollectionMargin);
        NSInteger columnNum = 3;
        
        CGFloat itemWidth = (kViewWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum-1;
        _flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth*1.5);
    }
    return _flowLayout;
}

- (NSMutableArray *)photos
{
    if(!_photos){
        _photos = [NSMutableArray arrayWithCapacity:[self.files count]];
        _photoFiles = [NSMutableArray arrayWithCapacity:[self.files count]];
        for(int i=0;i<[self.files count];i++){
            ScanFile *file = self.files[i];
            if(file.type==0){
                MWPhoto *photo;
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:file.imageUrlStr]];
                [_photos addObject:photo];
                [_photoFiles addObject:file];
            }
        }
    }
    return _photos;
}
- (PhotoEditorTitleView *)titleView
{
    if(!_titleView){
        _titleView = [[PhotoEditorTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        _titleView.delegate = self;
        _titleView.titleColor = [UIColor blackColor];
        _titleView.image = [UIImage imageNamed:@"下拉框"];
    }
    return _titleView;
}
- (UIButton *)editButton{
    
    if(!_editButton){
        _editButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f,40.f, 40.f)];
        [_editButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [_editButton setTintColor:[JYSkinManager shareSkinManager].colorForDateBg];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.hidden = YES;
    }
    return _editButton;
}
- (UIButton *)addButton{
    
    if(!_addButton){
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f,40.f, 40.f)];
        [_addButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [_addButton setTintColor:[JYSkinManager shareSkinManager].colorForDateBg];
//        [_addButton setImage:[[UIImage imageNamed:@"new_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
         [_addButton setTitle:@"扫描" forState:UIControlStateNormal];
        _addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _addButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_addButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.hidden = NO;
    }
    return _addButton;
}
- (NSMutableArray *)checkedFiles
{
    if(!_checkedFiles){
        _checkedFiles = [NSMutableArray array];
    }
    return _checkedFiles;
}
- (UIView *)editToolBar
{
    if(!_editToolBar){
        _editToolBar = [UIView new];
        _editToolBar.backgroundColor = [UIColor whiteColor];
        _editToolBar.clipsToBounds = YES;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_editToolBar addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.top.equalTo(_editToolBar);
        }];
        
        
        NSArray *imageNames = @[@"扫描_全选",@"扫描_传送",@"扫描_删除_红"];
        NSArray *menuNames = @[@"全选",@"传送",@"删除"];
        NSArray *tags = @[@(kBtnTagAllSelected),@(kBtnTagShare),@(kBtnTagDelete)];
        
        UIView *leftView = nil;
        for(int i=0;i<[menuNames count];i++){
            
            UIButton *btn = [UIButton new];
            btn.tag = [tags[i] integerValue];
            [btn setTitle:menuNames[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateHighlighted];
            [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
            [btn setBackgroundImage:[[JYSkinManager shareSkinManager].btnBackGroundColor image] forState:UIControlStateHighlighted];
            btn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            UIImage *img = [UIImage imageNamed:imageNames[i]];
            [btn setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(5,-img.size.width,-img.size.height, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-5, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.adjustsImageWhenHighlighted = NO;
            [_editToolBar addSubview:btn];
            
            if(i==0){
                self.selectAllButton = btn;
                [btn setBackgroundImage:[[JYSkinManager shareSkinManager].btnBackGroundColor image] forState:UIControlStateSelected];
            }else if(i==1){
                self.shareButton = btn;
            }
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if(leftView){
                    make.left.equalTo(leftView.mas_right);
                    make.width.equalTo(leftView);
                }else{
                    make.left.equalTo(_editToolBar);
                }
                if(i==[menuNames count]-1){
                    make.right.equalTo(_editToolBar.mas_right);
                }
                make.centerY.equalTo(_editToolBar).offset(0.5);
                make.height.equalTo(_editToolBar).offset(-1);
            }];
            leftView = btn;
        }
    }
    return _editToolBar;
}
- (UIImageView *)emptyView
{
    if(!_emptyView){
        _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无扫描文档"]];
        _emptyView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
