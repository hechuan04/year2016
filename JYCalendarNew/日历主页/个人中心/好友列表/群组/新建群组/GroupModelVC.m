//
//  GroupModelVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "GroupModelVC.h"
#import "AddFriendCell.h"
#import "AddFriendVC.h"
#import "GroupNameVC.h"
#import "ImageViewController.h"

#import "CamerManager.h"
#import "VPImageCropperViewController.h"

#define bigPage 50 / 750.0 * kScreenWidth
#define smallPage 36 / 750.0 * kScreenWidth

#define yForUserHead 30 / 1334.0 * kScreenHeight


#define heightForView 200 / 1334.0 * kScreenHeight
#define heightForView4 220 / 1334.0 * kScreenHeight


#define pageForLabel 15 / 1334.0 * kScreenHeight

#define heightForTitle 88 / 1334.0 * kScreenHeight
#define heightForHeaderView 144 / 1334.f * kScreenHeight
#define heightForHeader 100 / 1334.f * kScreenHeight

static NSString *strForAddFriend = @"strForAddFriend";

static const NSInteger addBtnTag = 2001;
static const NSInteger addLabelTag = 2002;
static const NSInteger arrowHeadTag = 2003;

@interface GroupModelVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>

{
  
    UITableView *_tableView;
    NSArray     *_arrForHeader;
    NSArray *_arrForAllFriend;
    UITextField *textFiled;
    
    NSMutableArray *_arrForFriendHead;
    
    NSMutableArray *_arrForAllBgView;
    UILabel *_labelForName;
    UIImageView *_headerImageView;
}
@end

@implementation GroupModelVC

- (void)rightAction
{
    NSString *groupName = _groupName;
    
    if ([_groupName isEqualToString:@""] || _groupName == nil) {
  
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请您输入组名" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];

        return;
        
    }else if(_arrForAllFriend.count <= 0 || _arrForAllFriend == nil){
    
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请您添加组成员" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        
        return;
        
    }
    
    //判断是否是更改群组还是创建群组
    if (_gid != 0) {
        
        GroupModel *model = [[GroupModel alloc] init];
        
        model.gid = _gid;
        model.group_name = groupName;
        model.groupHeader = _headerImageView.image;
        
        [RequestManager actionForEditGroupModel:model friendArr:_arrForAllFriend];
                
    }else{
     
//        [RequestManager actionForCreateGroupWithName:groupName friendArr:_arrForAllFriend];
        [RequestManager actionForCreateGroupWithName:groupName groupHeader:_headerImageView.image friendArr:_arrForAllFriend];

    }
    
    [self actionForPopGroupVc];

    
}

//#warning 在这里加等待菊花图
- (void)actionForPopGroupVc
{
 

    self.actionForReloadData();
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushAction:(UIButton *)sender
{
    AddFriendVC *friend = [[AddFriendVC alloc] init];

    DataArray *dataArr = [DataArray shareDateArray];
    NSArray *arrForAllFriend = [NSArray arrayWithArray:dataArr.arrForAllFriend];
    
    
    //添加群组成员的时候除去我
    NSInteger userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] integerValue];
    NSMutableArray *arrNotMe = [NSMutableArray array];
    for (int i = 0; i < arrForAllFriend.count; i++) {
        
        FriendModel *model = arrForAllFriend[i];
    
        if (model.fid == userID) {
            
            continue;
        }
        
        [arrNotMe addObject:model];
        
    }
    
    friend.dicForAllName = [Tool actionForReturnNameDic:arrNotMe];
    friend.arrForModel = _arrForAllFriend;
    
    __block GroupModelVC *vc = self;
    
    [friend setActionForSelect:^(NSArray *arrForSelect) {
        
        
        _arrForAllFriend = arrForSelect;
        
        [vc actionForCreateGroupView];
        
    }];
    
    for (int i = 0; i < _arrForAllBgView.count; i++) {
        
        
        UIView *viewForBg = _arrForAllBgView[i];
        
        [viewForBg removeFromSuperview];
        
    }
    
    [self.navigationController pushViewController:friend animated:YES];
    
}


//创建或从新刷新列表
- (void)actionForCreateGroupView
{
    UIFont *font = nil;
    CGFloat nowViewForFriend = 0;
    if (IS_IPHONE_4_SCREEN) {
        
        nowViewForFriend = heightForView4;
        font = [UIFont systemFontOfSize:12];
        
    }else if(IS_IPHONE_5_SCREEN){
     
        nowViewForFriend = heightForView;
        font = [UIFont systemFontOfSize:10];
        
    }else if(IS_IPHONE_6_SCREEN){
    
        nowViewForFriend = heightForView;
        font = [UIFont systemFontOfSize:10];
    
    }else{
     
        nowViewForFriend = heightForView;
        font = [UIFont systemFontOfSize:10];
    }
    
    CGFloat width = (kScreenWidth - 4 * smallPage - 2 * bigPage) / 5.0;
    
    
    int viewCount = (int )_arrForAllFriend.count / 5 + 1;
    int remainder = (int )_arrForAllFriend.count % 5;
    
    
    if (viewCount - 1 == 0) {
        
        //说明只有一个人，只创建一个
        UIView *viewForFriend = [[UIView alloc] initWithFrame:CGRectMake(0, heightForHeaderView+heightForTitle, kScreenWidth, nowViewForFriend)];
       // viewForFriend.backgroundColor = [UIColor orangeColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, nowViewForFriend, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        
        [viewForFriend addSubview:lineView];
        [self.view addSubview:viewForFriend];
        

        
        [_arrForAllBgView addObject:viewForFriend];
        
        for (int i = 0; i < _arrForAllFriend.count + 1; i++) {
            
         
            //image显示加号
            if (i == _arrForAllFriend.count) {
       
          
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bigPage + i * (smallPage + width), yForUserHead, width, width)];
                
                [btn setImage:[UIImage imageNamed:@"添加群组成员.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = addBtnTag;
                [viewForFriend addSubview:btn];
                
                //名字
                UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectMake(btn.origin.x, btn.bottom + pageForLabel, width, 20)];
                labelForName.text = @"添加";
                labelForName.font = font;
                labelForName.textAlignment = NSTextAlignmentCenter;
                labelForName.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
                //labelForName.backgroundColor = [UIColor orangeColor];
                labelForName.tag = addLabelTag;
                [viewForFriend addSubview:labelForName];
                
            }else{
                
                FriendModel *model = _arrForAllFriend[i];
                
                //头像
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigPage + i * (smallPage + width), yForUserHead, width, width)];
                imageView.layer.cornerRadius = width / 2.0;
                imageView.layer.masksToBounds = YES;
//                imageView.backgroundColor = [UIColor blueColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                [viewForFriend addSubview:imageView];
                
                
                //名字
                UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.origin.x, imageView.bottom + pageForLabel, width, 20)];
                labelForName.text = model.friend_name;
                labelForName.font = font;
                labelForName.textAlignment = NSTextAlignmentCenter;
                //labelForName.backgroundColor = [UIColor orangeColor];
                [viewForFriend addSubview:labelForName];

                
            }
            
        }
        
        
    }else{
        
        //根据倍数算有多少承载头像的VIEW
        for (int i = 0 ; i < viewCount; i ++) {
            
            UIView *viewForFriend = [[UIView alloc] initWithFrame:CGRectMake(0, heightForView * i + heightForTitle+heightForHeaderView, kScreenWidth, nowViewForFriend)];
            
            if (i == viewCount - 1) {
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, nowViewForFriend, kScreenWidth, 0.5)];
                lineView.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
                
                [viewForFriend addSubview:lineView];

            }
            
         
            
            [self.view addSubview:viewForFriend];
            
            //说明到了最后的一个承载头像的VIEW
            if (i == viewCount - 1) {
                
                for (int j = 0; j < remainder + 1 ; j ++) {
                    
                    if (j == remainder) {
                        
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bigPage + j * (smallPage + width), yForUserHead, width, width)];
                        
                        [btn setImage:[UIImage imageNamed:@"添加群组成员.png"] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [viewForFriend addSubview:btn];
                        
                        //名字
                        UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectMake(btn.origin.x, btn.bottom + pageForLabel, width, 20)];
                        labelForName.text = @"添加";
                        labelForName.font = font;
                        labelForName.textAlignment = NSTextAlignmentCenter;
                        labelForName.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
                        //labelForName.backgroundColor = [UIColor orangeColor];
                        [viewForFriend addSubview:labelForName];
                        
                    }else{
                        
                        FriendModel *model = _arrForAllFriend[i * 5 + j];
                        
                        //头像
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigPage + j * (smallPage + width), yForUserHead, width, width)];
                        imageView.layer.cornerRadius = width / 2.0;
                        imageView.layer.masksToBounds = YES;
//                        imageView.backgroundColor = [UIColor blueColor];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:model.head_url]  placeholderImage:[UIImage imageNamed:@"默认群组头像.png"]];
                        [viewForFriend addSubview:imageView];
                        
                        //名字
                        UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.origin.x, imageView.bottom + pageForLabel, width, 20)];
                        labelForName.text = model.friend_name;
                        labelForName.font = font;
                        labelForName.textAlignment = NSTextAlignmentCenter;
                        [viewForFriend addSubview:labelForName];

                        
                    }
                    
                }
                
            }else{
                
                for (int j = 0; j < 5; j ++) {
                    
                    FriendModel *model = _arrForAllFriend[(i * 5) + j];
                    
                    //头像
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigPage + j * (smallPage + width), yForUserHead, width, width)];
                    imageView.layer.cornerRadius = width / 2.0;
                    imageView.layer.masksToBounds = YES;
//                    imageView.backgroundColor = [UIColor blueColor];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认群组头像.png"]];
                    [viewForFriend addSubview:imageView];
                    
                    //名字
                    UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.origin.x, imageView.bottom + pageForLabel, width, 20)];
                    labelForName.text = model.friend_name;
                    labelForName.font = font;
                    //labelForName.backgroundColor = [UIColor orangeColor];
                    labelForName.textAlignment = NSTextAlignmentCenter;
                    [viewForFriend addSubview:labelForName];

                    
                }
                
            }
      
            [_arrForAllBgView addObject:viewForFriend];
        }
    }
    
}

- (void)actionForLeft:(UIButton *)sender
{
 
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  创建‘添加群组头像’UI，直接拷贝的旧代码，改的比较乱，待优化
 */
- (void)createViewForHeader{
    
    UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeaderView)];
    [self.view addSubview:viewForHeader];
    
    UILabel *labelForGroup = [[UILabel alloc] initWithFrame:CGRectMake(10, (heightForHeaderView - 30) / 2.0, 200, 30)];
    labelForGroup.text = @"群组头像";
    labelForGroup.font = [UIFont systemFontOfSize:18];
    [viewForHeader addSubview:labelForGroup];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6,(heightForHeaderView - 11) / 2.0, 6, 11)];
    imageView.image = [UIImage imageNamed:@"展开.png"];
    [viewForHeader addSubview:imageView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.left - heightForHeader - 15, (heightForHeaderView - heightForHeader) / 2.0, heightForHeader,heightForHeader)];
    NSURL *headerUrl = [NSURL URLWithString:self.groupHeaderUrl];
    [_headerImageView sd_setImageWithURL:headerUrl placeholderImage:[UIImage imageNamed:@"默认群组头像.png"]];
    _headerImageView.layer.cornerRadius = heightForHeader/2.f;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [viewForHeader addSubview:_headerImageView];
    
    UIButton *btnForGroupName = [[UIButton alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, heightForHeaderView)];
    [btnForGroupName addTarget:self action:@selector(actionForChooseHeader:) forControlEvents:UIControlEventTouchUpInside];
    [viewForHeader addSubview:btnForGroupName];
}

- (void)actionForChooseHeader:(UIButton *)sender{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
    
   
}
#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    _arrForFriendHead = [NSMutableArray array];
    
    self.title = @"群组信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    _arrForHeader = @[@"组名",@"成员"];
 

    _arrForAllBgView = [NSMutableArray array];
  
    //创建列表
    [self actionForCreateGroupView];
    [self createViewForHeader];
    
    //群组命名
    UIView *viewForName = [[UIView alloc] initWithFrame:CGRectMake(0, heightForHeaderView, kScreenWidth, heightForTitle)];
    //viewForName.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:viewForName];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, heightForTitle, kScreenWidth, 0.5)];
    lineView.backgroundColor = lineColor;
    [viewForName addSubview:lineView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
    topLineView.backgroundColor = lineColor;
    [viewForName addSubview:topLineView];
    
    UILabel *labelForGroup = [[UILabel alloc] initWithFrame:CGRectMake(10, (heightForTitle - 30) / 2.0, 200, 30)];
    labelForGroup.text = @"群组名称";
    labelForGroup.font = [UIFont systemFontOfSize:18];
    [viewForName addSubview:labelForGroup];
    

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6,(heightForTitle - 11) / 2.0, 6, 11)];
    imageView.image = [UIImage imageNamed:@"展开.png"];
    [viewForName addSubview:imageView];
    imageView.tag = arrowHeadTag;
    
    _labelForName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left - 150 - 15, (heightForTitle - 30) / 2.0, 150, 30)];
    _labelForName.text = _groupName;
    _labelForName.textColor = [UIColor grayColor];
    _labelForName.textAlignment = NSTextAlignmentRight;
    //_labelForName.backgroundColor = [UIColor orangeColor];
    _labelForName.font = [UIFont systemFontOfSize:16];
    [viewForName addSubview:_labelForName];
    
    UIButton *btnForGroupName = [[UIButton alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, heightForTitle)];
    [btnForGroupName addTarget:self action:@selector(actionForPushGroupNameVC:) forControlEvents:UIControlEventTouchUpInside];
    [viewForName addSubview:btnForGroupName];
    
   //[self _creatTableView];
    
}

//推出命名群的VC
- (void)actionForPushGroupNameVC:(UIButton *)sender
{
 
    GroupNameVC *gVC = [[GroupNameVC alloc] init];
    gVC.strForGroupName = _groupName;
    gVC.title = @"群组名称";
    __block GroupModelVC *ggg = self;
    [gVC setActionForPopGroupName:^(NSString *groupName) {
        
        if ([groupName isEqualToString:@""]) {
            
            ggg.labelForName.text = _groupName;
            
        }else{
         
            ggg.labelForName.text = groupName;
            ggg.groupName = groupName;
        }
        
    
        
    }];
    
    [self.navigationController pushViewController:gVC animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_onlyInspect) {
        self.navigationItem.rightBarButtonItem = nil;
        _headerImageView.origin = CGPointMake(kScreenWidth - _headerImageView.width - 15, _headerImageView.origin.y);
        _labelForName.origin = CGPointMake(kScreenWidth - _labelForName.width - 15, _labelForName.origin.y);
        UIButton *btn = [self.view viewWithTag:addBtnTag];
        UILabel  *label = [self.view viewWithTag:addLabelTag];
        UIImageView *arrowHead = [self.view viewWithTag:arrowHeadTag];
        
        [btn removeFromSuperview];
        [label removeFromSuperview];
        [arrowHead removeFromSuperview];
        
        self.view.userInteractionEnabled = NO;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//之前用tb做的
/*
- (void)_creatTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *bgView = [UIView new];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [_tableView setTableFooterView:bgView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddFriendCell" bundle:nil] forCellReuseIdentifier:strForAddFriend];
    
    textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 66)];
    
    if ([self.groupName isEqualToString:@""]) {
        
        textFiled.placeholder = @"请您输入群组名称";

    }else{
      
        textFiled.placeholder = self.groupName;
    }
    
    textFiled.delegate = self;
    textFiled.textAlignment = NSTextAlignmentCenter;
    [_tableView insertSubview:textFiled atIndex:1000];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    label.text = _arrForHeader[section];
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    
    return label;
    
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
        
        return 1;
        
    }else{
      
        return _arrForAllFriend.count + 1;

    }
    
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:strForAddFriend];
    
    if (!cell) {
        
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForAddFriend];
  
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        cell.friendHead.hidden = YES;
        cell.friendName.hidden = YES;
        cell.addLabel.hidden = YES;
        
        cell.addLabel.text = @"群组名称";
        
    }else{
    
        if (indexPath.row == 0) {
            
            cell.addLabel.hidden = NO;
            cell.friendName.hidden = YES;
            cell.friendHead.hidden = YES;
            
            cell.addLabel.text = @"点击更改群组成员";
            
        }else{
         
            cell.friendHead.hidden = NO;
            cell.friendName.hidden = NO;
            cell.addLabel.hidden = YES;
            
            if (_arrForAllFriend.count > 0) {
                
                
                FriendModel *model = _arrForAllFriend[indexPath.row - 1];
                cell.friendName.text = model.friend_name;
                [cell.friendHead sd_setImageWithURL:[NSURL URLWithString:model.head_url]];
            }
           
   
        }
        
    }
    
    
    return cell;
    
}

//单元格高度
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 66;
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [textFiled resignFirstResponder];
            AddFriendVC *friend = [[AddFriendVC alloc] init];
            
         
            
            DataArray *dataArr = [DataArray shareDateArray];
            friend.dicForAllName = [Tool actionForReturnNameDic:dataArr.arrForAllFriend];
            friend.arrForModel = _arrForAllFriend;
            
            __block GroupModelVC *vc = self;
            
            [friend setActionForSelect:^(NSArray *arrForSelect) {
                
                
                _arrForAllFriend = arrForSelect;
                
                [vc.tableView reloadData];
                
            }];
            
            [self.navigationController pushViewController:friend animated:YES];
            
        }
    }

}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 20;
    
}

*/
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        // 拍照
        if ([[CamerManager shareInstance] isCameraAvailable] && [[CamerManager shareInstance] doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            if ([[CamerManager shareInstance] isFrontCameraAvailable]) {
            //                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            //            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"相机不可用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
        
    }else if(buttonIndex==1){
        ImageViewController *imageVC = [[ImageViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
        nav.navigationBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [imageVC setActionForPassPic:^(UIImage *image) {
            _headerImageView.image = image;
        }];
        [self presentViewController:nav animated:YES completion:^{}];
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
        _headerImageView.image = editedImage;
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
