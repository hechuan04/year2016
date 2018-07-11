//
//  ScanMainViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/16.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanMainViewController.h"
#import "ScanDirectoryCell.h"
#import "BrowserToolBar.h"
#import "CameraNavigationController.h"
#import "ScanDirectory.h"
#import "ScanFile.h"
#import "CreateDirectoryCell.h"
#import "FileBrowserViewController.h"
#import "Masonry.h"
#import "RequestManager.h"
#import "ScanUtil.h"
#import "NSString+Common.h"

#define kCellMargin 15.f
#define kCollectionMargin 15.f

#define kToolBarHeight 55.f

#define kAlertTagForDelete 100001
#define kAlertTagForNewTitle 100002
#define kTextFieldTagNewName 100003
#define kMaxTextLength 15
static NSString *kCellIdentifierNewDir = @"kCellIdentifierNewDir";
static NSString *kCellIdentifierNormal = @"kCellIdentifierNormal";

@interface ScanMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,BrowserToolBarDelegate,UIAlertViewDelegate,UITextFieldDelegate>


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BrowserToolBar *toolBar;
@property (nonatomic,strong) UIView *editToolBar;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSMutableArray *dirs;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) NSMutableArray *checkedDirIDs;

@property (nonatomic,assign) NSInteger dirIdToPush;//如果!=-1，就跳转到相应目录。
@end

@implementation ScanMainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫描";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataFromServer:) name:kNotificationReloadScanFilesFromServer object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataFromDB) name:kNotificationReloadScanFilesFromDataBase object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [leftBtn addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBar];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.toolBar.mas_top);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kToolBarHeight));
    }];
    
    self.dirIdToPush = -1;
    
    [self refreshDataFromDB];
    
    __weak typeof(self) ws = self;
    [RequestManager queryAllDoucments:^(id data, NSError *error) {
        [ws refreshDataFromDB];
    }];
    
    [GuideView showGuideWithImageName:@"新手引导页9"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.navigationController.navigationBar.shadowImage = [[UIColor colorWithRGBHex:0xdddddd] image];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kDefaultDirId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}
#pragma mark - Public

#pragma mark - Private

#pragma mark Event
- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editBtnClicked:(UIButton *)sender{
    [self changeEditStatus];
}
- (void)longPressToDo:(UIGestureRecognizer *)recognizer
{
    if(recognizer.state==UIGestureRecognizerStateBegan){
        [self changeEditStatus];
    }
}
- (void)changeEditStatus{
    
    _isEditing = !_isEditing;
    self.editButton.selected = _isEditing;
    self.toolBar.shareButton.hidden = !_isEditing;
    self.toolBar.deleteButton.hidden = !_isEditing;
    
    [self.checkedDirIDs removeAllObjects];
    [self.collectionView reloadData];
}
#pragma mark Data
- (void)refreshDataFromDB
{
    //从本地查询
    NSInteger userId = [[NSUserDefaults standardUserDefaults] floatForKey:kUserXiaomiID];
    self.dirs = [NSMutableArray arrayWithArray:[[ScanUtil sharedInstance]findAllDirsWithUserId:userId]];
    [self.collectionView reloadData];
    
    self.editButton.hidden = ([self.dirs count]==0);
    
    if(self.dirIdToPush!=-1){
        ScanDirectory *destDir = nil;
        for(ScanDirectory *dir in self.dirs){
            if(dir.dirId==self.dirIdToPush){
                destDir = dir;
            }
        }
        if(destDir){
            FileBrowserViewController *fileVC = [FileBrowserViewController new];
            fileVC.directory = destDir;
            [self.navigationController pushViewController:fileVC animated:YES];
        }
        self.dirIdToPush = -1;
    }
}

- (void)loadDataFromServer:(NSNotification *)notification
{
    NSString *dirId = notification.object;
    if(dirId){
        self.dirIdToPush = [dirId integerValue];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if(self.navigationController.topViewController == self){
            [ProgressHUD show:@"刷新中..."];
        }
        __weak typeof(self) ws = self;
        [RequestManager queryAllDoucments:^(id data, NSError *error) {
            [ProgressHUD dismiss];
            [ws refreshDataFromDB];
        }];
    });
}

#pragma mark - Protocol
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(_isEditing){
        return [self.dirs count];
    }else{
        return [self.dirs count]+1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *rtnCell;
    if(_isEditing){
        ScanDirectoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierNormal forIndexPath:indexPath];
        ScanDirectory *dir = self.dirs[indexPath.row];
        cell.directory = dir;
        cell.isEditing = YES;
        cell.isSelected = [self.checkedDirIDs containsObject:@(dir.dirId)];
        rtnCell = cell;
    }else{
        //第一张显示创建cell
        if(indexPath.row==0){
            CreateDirectoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierNewDir forIndexPath:indexPath];
            rtnCell = cell;
        }else{
            ScanDirectoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierNormal forIndexPath:indexPath];
            cell.directory = self.dirs[indexPath.row-1];
            cell.isEditing = NO;
            rtnCell = cell;
        }
    }
    return rtnCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isEditing){
        ScanDirectory *dir = self.dirs[indexPath.row];
        NSInteger did = dir.dirId;
        if([self.checkedDirIDs containsObject:@(did)]){
            [self.checkedDirIDs removeObject:@(did)];
        }else{
            [self.checkedDirIDs addObject:@(did)];
        }
        [self.collectionView reloadData];
    }else{
        //创建新文件夹
        if(indexPath.row==0){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新建文件夹" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = kAlertTagForNewTitle;
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.tag = kTextFieldTagNewName;
            tf.delegate = self;
//            [tf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
            [alertView show];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)
                                                        name:UITextFieldTextDidChangeNotification   object:tf];
        }else{//进入文件夹
            FileBrowserViewController *fileVC = [FileBrowserViewController new];
            ScanDirectory *dir = self.dirs[indexPath.row-1];
            fileVC.directory = dir;
            [self.navigationController pushViewController:fileVC animated:YES];
        }
    }
    
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==kAlertTagForNewTitle){
        
        UITextField *tf=[alertView textFieldAtIndex:0];
        [tf resignFirstResponder];
        
        if(buttonIndex==1){
            __weak typeof(self) ws = self;
            [ProgressHUD show:@"创建中..."];
            [RequestManager createNewDirectory:tf.text complete:^(id data, NSError *error) {
                [RequestManager queryAllDoucments:^(id data, NSError *error) {
                    [ws refreshDataFromDB];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ws.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[ws.dirs count]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
                        [ProgressHUD dismiss];
                    });

                }];

            }];
        }
        
    }else if(alertView.tag == kAlertTagForDelete){
        if(buttonIndex==1){
            //删除文件
            NSString *didStr = [self.checkedDirIDs componentsJoinedByString:@","];
            __weak typeof(self) ws = self;
            [ProgressHUD show:@"删除中..."];
            [RequestManager deleteDirectoriesWithDirIdStr:didStr complete:^(id data, NSError *error) {
                [ws changeEditStatus];
                [ProgressHUD dismiss];
            }];
        }
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == kAlertTagForNewTitle){
        UITextField *tf=[alertView textFieldAtIndex:0];
        if(tf.text.length==0){
            return NO;
        }
        return YES;
    }
    return YES;
}
#pragma mark - BrowserToolBarDelegate
- (void)browserTollBar:(BrowserToolBar *)toolBar shareButtonClicked:(UIButton *)sender
{
    NSLog(@"share");
}
- (void)browserTollBar:(BrowserToolBar *)toolBar deleteButtonClicked:(UIButton *)sender
{
    
    if([self.checkedDirIDs count]==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未勾选任何文件!" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确认删除所选文件?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = kAlertTagForDelete;
        [alert show];
    }
}
- (void)browserTollBar:(BrowserToolBar *)toolBar takePhotoButtonClicked:(UIButton *)sender
{
    CameraNavigationController *cameraNav = [[CameraNavigationController alloc]init];
    [self presentViewController:cameraNav animated:YES completion:nil];
}

#pragma mark - Custom Accessors
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kToolBarHeight) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ScanDirectoryCell class] forCellWithReuseIdentifier:kCellIdentifierNormal];
        [_collectionView registerClass:[CreateDirectoryCell class] forCellWithReuseIdentifier:kCellIdentifierNewDir];
        
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
        
        CGFloat itemWidth = (kScreenWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum-1;
        _flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth*1.5);
    }
    return _flowLayout;
}
- (NSMutableArray *)dirs
{
    if(!_dirs){
        _dirs = [NSMutableArray array];
    }
    return _dirs;
}
- (BrowserToolBar *)toolBar
{
    if(!_toolBar){
        _toolBar = [[BrowserToolBar alloc]initWithFrame:CGRectMake(0,kScreenHeight-kToolBarHeight, kScreenWidth,kToolBarHeight)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (UIButton *)editButton{
    
    if(!_editButton){
        _editButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f,40.f, 40.f)];
        [_editButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
- (NSMutableArray *)checkedDirIDs
{
    if(!_checkedDirIDs){
        _checkedDirIDs = [NSMutableArray array];
    }
    return _checkedDirIDs;
}
@end
