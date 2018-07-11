//
//  NoteListViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "NoteListViewController.h"
#import "JYNote.h"
#import "AddNoteViewController.h"
#import "JYNoteCell.h"
#import "NoteTableManager.h"
#import "EditNoteViewController.h"
#import "UploadSuccessView.h"

#define kRowHeigth 60.f
#define kEditToolBarHeight 60.f

#define kBtnTagAllSelected 20001
#define kBtnTagDelete 20002
#define kBtnTagSync 20003

#define kAlertTagForDeleteSelected 30001
#define kAlertTagForDeleteOne 30002
#define kAlertTagForSyncAll 30003

#define kToolbarHeight  59.f

static NSString *kIdentifierForCell = @"kIdentifierForCell";
@interface NoteListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *notes; //of JYNote
@property (nonatomic,strong) UIImageView *emptyView;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIView *editToolBar;
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,strong) NSMutableArray *checkedFiles;
@property (nonatomic,strong) UIButton *selectAllButton;
@property (nonatomic,strong) UIButton *syncButton;
@property (nonatomic,strong) NSIndexPath *indexPathToDelete;

@property (nonatomic,strong) UIButton *syncAllBtn;

@end

@implementation NoteListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"记事";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
    [self setupUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:kNotificationForReloadNoteList object:nil];
//    [ProgressHUD show:@"查询中…"];
    [self refreshData];
    [self requestDataFromServer];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(self.isEditing){
        [self endEdit];
    }
    [self.tableView setEditing:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Public

#pragma mark - Private
- (void)setupUI
{
    //导航
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [leftBtn addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(0, 0, 50, 22);
    editBtn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.hidden = YES;
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    [editBtn setImage:[[UIImage imageNamed:@"编辑"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    editBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.editButton = editBtn;
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn addTarget:self action:@selector(createBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    createBtn.frame = CGRectMake(0, 0, 22, 22);
    createBtn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [createBtn setImage:[[UIImage imageNamed:@"新建便签"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    createBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc]initWithCustomView:createBtn];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItems = @[createItem,editItem];
    
    //table
    [self.view addSubview:self.tableView];
    //外面工具条
    [self.view addSubview:self.toolbar];
    
    [self.view addSubview:self.emptyView];
    self.emptyView.center = CGPointMake(kScreenWidth/2.f,kScreenHeight/2.f-100);
    
    
    [self.view addSubview:self.editToolBar];
}
- (void)refreshData
{
    [self.notes removeAllObjects];
    [self.notes addObjectsFromArray:[[NoteTableManager sharedManager]findAllNotes]];
    self.editButton.hidden = self.notes.count==0;
    
    [self.tableView reloadData];
    
    self.emptyView.hidden = [self.notes count]>0;
    self.toolbar.hidden = [self.notes count]==0;
}
- (void)requestDataFromServer
{
    @weakify(self);
    [RequestManager queryAllNotesCompleted:^(id data, NSError *error) {
        if([data isKindOfClass:[NSArray class]]){
            @strongify(self);
            NSArray *result = (NSArray *)data;
            //循环将服务器数据同步到本地(本地没有的创建，本地过期的更新)
            NSMutableArray *tids = [NSMutableArray arrayWithCapacity:[result count]];
            for(int i=0;i<[result count];i++){
                JYNote *note = [[JYNote alloc]initWithDictionary:result[i]];
                if(note.tId){
                    [tids addObject:note.tId];
                }
                JYNote *localNote;
                for(JYNote *n in self.notes){
                    if([note.tId isEqualToString:n.tId]){
                        localNote = n;
                        break;
                    }
                }
                if(localNote){
                    note.nId = localNote.nId;
                    if([note.syncTime compare:localNote.updateTime]==NSOrderedDescending){
                        [[NoteTableManager sharedManager]updateNoteViaSync:note];
                    }
                }else{
                    [[NoteTableManager sharedManager]insertNoteBySync:note];
                }
            }
            //循环遍历本地数据,将本地有同步记录的，但服务器返回中不包含的，删除
            for(JYNote *note in self.notes){
                if(note.tId&&note.syncTime){
                    if(![tids containsObject:note.tId]){
//                        note.tId = @"";
//                        note.syncTime = nil;
//                        [[NoteTableManager sharedManager]updateNoteViaSync:note];
                        [[NoteTableManager sharedManager]deleteNote:note];
                    }
                }
            }
            [self refreshData];
        }
    }];
   
}
- (void)actionForLeft:(UIButton *)sender
{
    if(self.tableView.editing){
        self.tableView.editing = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createBtnClicked:(UIButton *)sender
{
    AddNoteViewController *addVC = [AddNoteViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)editBtnClicked:(UIButton *)sender
{
    [self changeEditStatus];
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
    CGRect frame = self.editToolBar.frame;
    frame.origin.y = kScreenHeight - kEditToolBarHeight-64;
    CGRect frame2 = self.toolbar.frame;
    frame2.origin.y = kScreenHeight;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kToolBarHeight, 0);
    [UIView animateWithDuration:0.35f animations:^{
        self.editToolBar.frame = frame;
        self.toolbar.frame = frame2;
    }];
    
    self.selectAllButton.selected = NO;
    [self.checkedFiles removeAllObjects];
    [self.tableView reloadData];
}
- (void)endEdit
{
    _isEditing = NO;
    self.editButton.selected = NO;
    CGRect frame = self.editToolBar.frame;
    frame.origin.y = kScreenHeight;
    CGRect frame2 = self.toolbar.frame;
    frame2.origin.y = kScreenHeight - kToolbarHeight - 64;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.35f animations:^{
        self.editToolBar.frame = frame;
        self.toolbar.frame = frame2;
    }];
    self.selectAllButton.selected = NO;
    [self.checkedFiles removeAllObjects];
    [self.tableView reloadData];
}
- (void)menuButtonClicked:(UIButton *)sender
{
    switch (sender.tag) {
            
        case kBtnTagAllSelected:{
            //已经全选取消全选
            if([self.checkedFiles count]==[self.notes count]){
                [self.checkedFiles removeAllObjects];
                sender.selected = NO;
            }else{//全选
                sender.selected = YES;
                [self.checkedFiles removeAllObjects];
                [self.checkedFiles addObjectsFromArray:self.notes];
            }
            [self.tableView reloadData];
        }
            break;
        case kBtnTagDelete:{
            if([self.checkedFiles count]==0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未勾选任何文件!" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确认删除所选文件?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = kAlertTagForDeleteSelected;
                [alert show];
            }
        }
            break;
        case kBtnTagSync:{            
            if([self.checkedFiles count]==0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未勾选任何文件!" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }else{
                @weakify(self)
                [RequestManager uploadNotes:self.checkedFiles complete:^(id data, NSError *error) {
                    @strongify(self);
                    if([data isKindOfClass:[NSDictionary class]]){
                        [UploadSuccessView showSuccessView];
                        
                        NSDictionary *dic = (NSDictionary *)data;
                        NSArray *tidArr = [dic[@"tid"] componentsSeparatedByString:@"|"];
                        NSArray *imgPaths = [dic[@"imagePath"] componentsSeparatedByString:@"|"];
                        
                        for(int i=0;i<[self.checkedFiles count];i++){
                            JYNote *note = self.checkedFiles[i];
                            [[NoteTableManager sharedManager]deleteOldNoteImages:note];
                            note.imagePathLocal = @"";
                            note.syncTime = note.updateTime;
                            if(i<[tidArr count]&&i<[imgPaths count]){
                                note.tId = tidArr[i];
                                note.imagePathRemote = imgPaths[i];
//                                NSLog(@"%@--%@",note.tId,note.imagePathRemote);
                            }
                            [[NoteTableManager sharedManager]updateNoteViaSync:note];
                        }
                        [self endEdit];
                        [self refreshData];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}
- (void)syncAllButtonClicked:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否同步所有文档？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = kAlertTagForSyncAll;
    [alert show];
}
#pragma mark - Protocol
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForCell];
    JYNote *note = self.notes[indexPath.row];
    cell.note = note;
    cell.checkWidthConstraint.offset = self.isEditing?25.f:0.f;
    cell.titleLeftConstraint.offset = self.isEditing?15.f:0.f;
    cell.isSelected = [self.checkedFiles containsObject:note];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isEditing){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditNoteViewController *editVC = [EditNoteViewController new];
        JYNote *note = self.notes[indexPath.row];
        editVC.note = note;
        [self.navigationController pushViewController:editVC animated:YES];
    }else{
        JYNoteCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = !cell.isSelected;
        JYNote *note = self.notes[indexPath.row];
        if(![self.checkedFiles containsObject:note]){
            [self.checkedFiles addObject:note];
        }else{
            [self.checkedFiles removeObject:note];
        }
        //是否全选
        if([self.checkedFiles count]==[self.notes count]){
            self.selectAllButton.selected = YES;
        }else{
            self.selectAllButton.selected = NO;
        }

    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isEditing;
}
//- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isEditing){
        self.indexPathToDelete = indexPath;
        if(editingStyle==UITableViewCellEditingStyleDelete){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确认删除?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = kAlertTagForDeleteOne;
            [alert show];
        }
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==kAlertTagForDeleteSelected){
        if(buttonIndex==1){
            //同步过的和未同步过的分开处理，同步过的需要从服务器删除成功后，本地才能删除，未同步过的直接可以本地删除
            NSMutableArray *unSyncFiles = [NSMutableArray arrayWithCapacity:[self.checkedFiles count]];
            NSMutableArray *syncFiles = [NSMutableArray arrayWithCapacity:[self.checkedFiles count]];
            NSMutableArray *tids = [NSMutableArray arrayWithCapacity:[self.checkedFiles count]];
            for(int i=0;i<[self.checkedFiles count];i++){
                JYNote *note = self.checkedFiles[i];
                if(note.tId.length>0){
                    [syncFiles addObject:note];
                    [tids addObject:note.tId];
                }else{
                    [unSyncFiles addObject:note];
                }
            }
            [[NoteTableManager sharedManager]deleteNotes:unSyncFiles];//直接删除未同步的
            
            NSString *tidStr = [tids componentsJoinedByString:@","];
            if(tidStr.length==0){
                [self endEdit];
                [self refreshData];
            }else{
                @weakify(self);
                [RequestManager deleteNotesWithTidStr:tidStr complete:^(id data, NSError *error) {
                    @strongify(self);
                    [[NoteTableManager sharedManager]deleteNotes:syncFiles];
                    [self endEdit];
                    [self refreshData];
                }];
            }
            
        }
    }else if(alertView.tag==kAlertTagForDeleteOne){
        if(buttonIndex==1){
            NSIndexPath *indexPath = self.indexPathToDelete;
            JYNote *note = self.notes[indexPath.row];
            if(note.syncTime&&note.tId){//已同步过的数据需联网删除服务器上的再删本地
                @weakify(self);
                [RequestManager deleteNotesWithTidStr:note.tId complete:^(id data, NSError *error) {
                    @strongify(self);
                    [[NoteTableManager sharedManager]deleteNote:note];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.notes removeObjectAtIndex:indexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        if([self.notes count]==0){
                            self.emptyView.hidden = NO;
                            self.toolbar.hidden = YES;
                        }else{
                            self.toolbar.hidden = NO;
                        }
                        self.editButton.hidden = self.notes.count==0;
                    });
                }];
            }else{
                [[NoteTableManager sharedManager]deleteNote:note];
                [self.notes removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if([self.notes count]==0){
                    self.emptyView.hidden = NO;
                    self.toolbar.hidden = YES;
                }else{
                    self.toolbar.hidden = NO;
                }
                self.editButton.hidden = self.notes.count==0;
                    
            }
        }else{
            [self.tableView setEditing:NO];
        }
    }else if(alertView.tag==kAlertTagForSyncAll){
        if(buttonIndex==1){
            //全部同步
            @weakify(self)
            [RequestManager uploadNotes:self.notes complete:^(id data, NSError *error) {
                @strongify(self);
                if([data isKindOfClass:[NSDictionary class]]){
                    [UploadSuccessView showSuccessView];
                    
                    NSDictionary *dic = (NSDictionary *)data;
                    NSArray *tidArr = [dic[@"tid"] componentsSeparatedByString:@"|"];
                    NSArray *imgPaths = [dic[@"imagePath"] componentsSeparatedByString:@"|"];
                    
                    for(int i=0;i<[self.notes count];i++){
                        JYNote *note = self.notes[i];
                        [[NoteTableManager sharedManager]deleteOldNoteImages:note];
                        note.imagePathLocal = @"";
                        note.syncTime = note.updateTime;
                        if(i<[tidArr count]&&i<[imgPaths count]){
                            note.tId = tidArr[i];
                            note.imagePathRemote = imgPaths[i];
                            //                                NSLog(@"%@--%@",note.tId,note.imagePathRemote);
                        }
                        [[NoteTableManager sharedManager]updateNoteViaSync:note];
                    }
                    [self refreshData];
                }
            }];
        }
    }
}

#pragma mark - Custom Accessors
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-kNavbarHeight-kStatusBarHeight-kToolbarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowHeigth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _tableView.tintColor = bgRedColor;
        [_tableView registerClass:[JYNoteCell class] forCellReuseIdentifier:kIdentifierForCell];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)notes
{
    if(!_notes){
        _notes = [NSMutableArray array];
    }
    return _notes;
}
- (UIImageView *)emptyView
{
    if(!_emptyView){
        _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无便签"]];
        _emptyView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyView.hidden = YES;
    }
    return _emptyView;
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
        _editToolBar = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth,kEditToolBarHeight)];
        _editToolBar.backgroundColor = [UIColor whiteColor];
        _editToolBar.clipsToBounds = YES;
        
        NSArray *imageNames = @[@"扫描_全选",@"扫描_删除_红",@"上传红色"];
        NSArray *menuNames = @[@"全选",@"删除",@"同步"];
        NSArray *tags = @[@(kBtnTagAllSelected),@(kBtnTagDelete),@(kBtnTagSync)];
        CGFloat btnWidth = (kScreenWidth / [menuNames count]);

        for(int i=0;i<[menuNames count];i++){
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*btnWidth,0, btnWidth, kEditToolBarHeight)];
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
            }else if(i==2){
                self.syncButton = btn;
            }
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_editToolBar addSubview:lineView];
        
    }
    return _editToolBar;
}
- (UIButton *)syncAllBtn
{
    if(!_syncAllBtn){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44.f,44.f)];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateHighlighted];
        [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
        [btn setBackgroundImage:[[JYSkinManager shareSkinManager].btnBackGroundColor image] forState:UIControlStateHighlighted];
        btn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"同步" forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"上传红色"];
        [btn setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(5,-img.size.width,-img.size.height, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-5, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;

        [btn addTarget:self action:@selector(syncAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _syncAllBtn = btn;
    }
    return _syncAllBtn;
}
- (UIToolbar *)toolbar
{
    if(!_toolbar){

        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-kNavbarHeight-kStatusBarHeight-kToolbarHeight, kScreenWidth, kToolbarHeight)];
        toolbar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        NSLog(@"%@---%@",[JYSkinManager shareSkinManager].colorForDateBg,[JYSkinManager shareSkinManager].keywordForSkinColor);
        UIBarButtonItem *sapceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *sapceRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        sapceRight.width = 20.f;
        UIBarButtonItem *syncBtn = [[UIBarButtonItem alloc]initWithCustomView:self.syncAllBtn];
        toolbar.items = @[sapceLeft,syncBtn,sapceRight];
        toolbar.translucent = NO;
        _toolbar = toolbar;
    }
    return _toolbar;
}
@end
