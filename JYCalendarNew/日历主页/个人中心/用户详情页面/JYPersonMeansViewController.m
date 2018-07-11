//
//  JYPersonMeansViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYPersonMeansViewController.h"
#import "PersonTableViewCell.h"
#import "GroupNameVC.h"
#import "ImageViewController.h"
#import "NewFriendBar.h"

#import "SexVC.h"
#import "JYSignVC.h"
#import "JYLocalVC.h"

#import "CamerManager.h"
#import "VPImageCropperViewController.h"

#define yForbar 322 / 1334.0 * kScreenHeight
#define widthForEr 360 / 750.0 * kScreenWidth

static NSString *strForPersonMeans = @"strForPersonMeans";

@interface JYPersonMeansViewController ()
{
    
    UITableView *_tableViewForPerson;
 
}
@end

@interface JYPersonMeansViewController (tableView)<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>

- (void)_createTableView;

@end

@implementation JYPersonMeansViewController

- (void)rightAction
{
 
    [RequestManager actionForPassNameAndUserHead:_userHead name:_name];
    
    _acitonForReloadTb(_userHead,_name);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)actionForLeft:(UIButton *)sender
{
    if(self.isChangePic||self.isChangeName||self.sexChanged||self.locationChanged||self.signChanged){
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [RequestManager actionForPassNameAndUserHead:_userHead name:_name];
        
        _acitonForReloadTb(_userHead,_name);
        //[RequestManager actionForSelectFriendIsNewFriend:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    
    _userHead = nil;
    _name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
   
    
    [self _createTableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"JYPersonMeansViewController dealloc");
}
@end


@implementation JYPersonMeansViewController (tableView)


- (void)_createTableView
{

    _tableViewForPerson = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66) style:UITableViewStylePlain];
    _tableViewForPerson.delegate = self;
    _tableViewForPerson.dataSource = self;
    _tableViewForPerson.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    
    [self.view addSubview:_tableViewForPerson];
    
    [_tableViewForPerson registerNib:[UINib nibWithNibName:@"PersonTableViewCell" bundle:nil] forCellReuseIdentifier:strForPersonMeans];
    
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    [_tableViewForPerson setTableFooterView:footView];
    
    
    [self performSelector:@selector(changeIDFrame) withObject:nil afterDelay:0];
}

- (void)changeIDFrame
{
 
    [_tableViewForPerson reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    if (section == 0) {
        
        return nil;
        
    }else {
     
        UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        viewBg.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        
        return viewBg;
    }
    

    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    if (section == 0) {
        
        return 0;
        
    }else{
     
        return 20;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if(indexPath.row == 0){
            
            return 82;
            
        }else{
            
            return 49;
        }
        
    }else {
    
        return 49;
        
    }
   
   
    
}

//组数
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 2;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 4;
        
    }else{
     
        return 3;
    }
    
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForPersonMeans];
    
    if (!cell) {
        
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForPersonMeans];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.userTitle.text = @"头像";
            cell.userNumber.hidden = YES;
            cell.userHead.hidden = NO;
            
            if (_isChangePic) {
                
                cell.userHead.image = _userHead;
                
            }else{
                
                [cell.userHead sd_setImageWithURL:[NSURL URLWithString:[defaults objectForKey:kUserHead]] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                
            }
    
        }else if(indexPath.row == 1){
     
            cell.userTitle.text = @"昵称";
            cell.userNumber.hidden = NO;
            
            if (_isChangeName) {
                
                cell.userNumber.text = _name;
                
            }else{
                
                cell.userNumber.text = [defaults objectForKey:kUserName];
                
            }
            
            cell.userHead.hidden = YES;
            
        }else if(indexPath.row == 2){
        
            cell.userTitle.text = @"小秘号";
            cell.userNumber.hidden = NO;
            cell.userHead.hidden = YES;
            cell.imageForJiantou.hidden = YES;
            cell.userNumber.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
            cell.userNumber.origin = CGPointMake(kScreenWidth - 15 - 150, 0);
            
        }else if(indexPath.row == 3){
        
            cell.userTitle.text = @"我的二维码";
            cell.userNumber.hidden = YES;
            cell.userHead.hidden = NO;
            
            cell.userHead.image = [UIImage imageNamed:@"二维码.png"];
            
        }
        
        
    }else{
     
        if (indexPath.row == 0) {
            
            cell.userTitle.text = @"性别";
            cell.userNumber.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
            cell.userNumber.hidden = NO;
            cell.userHead.hidden = YES;
            
            
        }else if(indexPath.row == 1){
        
            cell.userTitle.text = @"地区";
            cell.userNumber.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLocal];
            cell.userNumber.hidden = NO;
            cell.userHead.hidden = YES;
            
        }else if(indexPath.row == 2){
        
            cell.userTitle.text = @"个性签名";
            NSString *sign = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSign];
            cell.userNumber.text = sign;
            cell.userNumber.hidden = NO;
            cell.userHead.hidden = YES;
            
        }
        
    }
    
    
    return cell;
    
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
       
        if (indexPath.row == 0) {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
            [sheet showInView:self.view];
            
            
        }else if(indexPath.row == 1){
            
            GroupNameVC *gVc = [[GroupNameVC alloc] init];
            gVc.strForGroupName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            gVc.title = @"个人昵称";
            
            [gVc setActionForPopGroupName:^(NSString *userName) {
                
                
                if (![userName isEqualToString:@""]) {
                    
                    _isChangeName = YES;
                    _name = userName;
                    
//                    [RequestManager actionForPassNameAndUserHead:_userHead name:_name];
//                    _acitonForReloadTb(_userHead,_name);
                    
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableViewForPerson reloadData];
                    
                });
                
            }];
            
            [self.navigationController pushViewController:gVc animated:YES];
            
        }else if(indexPath.row == 2){
        
            
        
        }else if(indexPath.row == 3){
        
            NewFriendBar *bar = [[NewFriendBar alloc] init];
            
            FriendModel *model = [[FriendModel alloc] init];
            
            model.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            model.fid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] integerValue];
            model.friend_name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            
            bar.model = model;
            
            [self.navigationController pushViewController:bar animated:YES];
            
            
        }else if(indexPath.row == 4){
        
        
        }
        
    }else{
     
        if (indexPath.row == 0) {
            
            SexVC *sexVC = [[SexVC alloc] init];
            
            sexVC.title = @"性别";
            
            __weak typeof(self) ws = self;
            __block UITableView *table = _tableViewForPerson;
            [sexVC setActionForLoadTableView:^{
                ws.sexChanged = YES;
                [table reloadData];
            
            }];
            
            [self.navigationController pushViewController:sexVC animated:YES];
            
        }else if(indexPath.row == 1){
         
            JYLocalVC *jylocalVC = [[JYLocalVC alloc] init];
            
            jylocalVC.title = @"地区";
            __weak typeof(self) ws = self;
            __block UITableView *table = _tableViewForPerson;
            [jylocalVC setActionForReloadTb:^{
                ws.locationChanged = YES;
                [table reloadData];
                
            }];
            
            [self.navigationController pushViewController:jylocalVC animated:YES];
            
        }else{
         
            JYSignVC *signVC = [[JYSignVC alloc] init];
            
            signVC.title = @"个性签名";
            __weak typeof(self) ws = self;
            __block UITableView *table = _tableViewForPerson;
            [signVC setActionForSign:^(NSString *text) {
                ws.signChanged = YES;
                [table reloadData];
                
            }];
            
            [self.navigationController pushViewController:signVC animated:YES];
            
        }
    }
 
   
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        // 拍照
        __weak typeof(self) ws = self;
        [[CamerManager shareInstance]showCameraWithBlock:^{
            
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
        [[CamerManager shareInstance]showPhotoLibraryWithBlock:^{

            ImageViewController *imageVC = [[ImageViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
            
            [imageVC setActionForPassFullPic:^(UIImage *image) {
                
//                ws.userHead = image;
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [_tableViewForPerson reloadData];
//                });
                
                
                CGSize showSize = CGSizeMake(kScreenWidth-100,kScreenWidth-100);
                VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake((kScreenWidth-showSize.width)/2,(kScreenHeight-showSize.height)/2, showSize.width, showSize.height) limitScaleRatio:3.0];
                imgCropperVC.delegate = ws;
                [ws presentViewController:imgCropperVC animated:YES completion:^{}];
                
            }];
            [ws presentViewController:nav animated:YES completion:^{
            }];
        }];

    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGSize showSize = CGSizeMake(kScreenWidth-100,kScreenWidth-100);
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake((kScreenWidth-showSize.width)/2,(kScreenHeight-showSize.height)/2, showSize.width, showSize.height) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{}];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        _userHead = editedImage;
        _isChangePic = YES;
        [_tableViewForPerson reloadData];
//        [RequestManager actionForPassNameAndUserHead:_userHead name:_name];
//        _acitonForReloadTb(_userHead,_name);

    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}



@end


