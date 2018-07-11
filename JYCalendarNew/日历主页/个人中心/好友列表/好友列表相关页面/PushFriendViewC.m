//
//  PushFriendViewC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/25.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "PushFriendViewC.h"
#import "JYRemindViewController.h"
#import "JYMainViewController.h"
#import "NewAddFriendCell.h"
#import "NewFriendBar.h"
#import "EditRemarkViewController.h"
#import "SignCell.h"

#define xForKeyImage 684 / 750.0 * kScreenWidth
#define yForKeyImage 30 / 1334.0 * kScreenHeight

#define widthForImage 36 / 750.0 * kScreenWidth
#define heightForImage 34 / 1334.0 * kScreenHeight

static NSString *kIdentifierForNormal = @"kIdentifierForNormal";
static NSString *kIdentifierForRemark = @"kIdentifierForRemark";
static NSString *strForNewAddFriend = @"strForNewAddFriend";
static NSString *kIdentifierForSign = @"kIdentifierForSign";
@interface PushFriendViewC ()
{
 
    UIImageView *keyStatusImage;
    UIButton    *_keyStatusBtn;

}
@end

@implementation PushFriendViewC

- (void)actionForNotification
{
 
}

- (void)dealloc
{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    if([self.model.remarkName length]>0){
//        self.title = self.model.remarkName;
//    }else{
//        self.title = self.model.friend_name;
//    }
    self.title = @"详细资料";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifierForRemark];
    
    keyStatusImage = [[UIImageView alloc] initWithFrame:CGRectMake(xForKeyImage, yForKeyImage, widthForImage , heightForImage)];
    [self.tableView addSubview:keyStatusImage];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.btnForAccept setImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateNormal];
    [self.btnForRefuse setImage:[UIImage imageNamed:@"删除好友.png"] forState:UIControlStateNormal];
    
    if(self.showRemarkView){
        
        CGRect frame = self.btnForAccept.frame;
        frame.origin.y += 60.f;
        frame.origin.y += [SignCell heightForSign:self.model.sign]-60;
        self.btnForAccept.frame = frame;
        
        frame = self.btnForRefuse.frame;
        frame.origin.y += 60.f;
        frame.origin.y += [SignCell heightForSign:self.model.sign]-60;
        self.btnForRefuse.frame = frame;
    }else{
        CGRect frame = self.btnForAccept.frame;
        frame.origin.y += [SignCell heightForSign:[[NSUserDefaults standardUserDefaults]valueForKey:kUserSign]]-60;
        self.btnForAccept.frame = frame;
        
        frame = self.btnForRefuse.frame;
        frame.origin.y += [SignCell heightForSign:[[NSUserDefaults standardUserDefaults]valueForKey:kUserSign]]-60;
        self.btnForRefuse.frame = frame;

    }
    
    CGFloat bottom = self.btnForRefuse.frame.origin.y+self.btnForRefuse.frame.size.height+64-kScreenHeight;
    if(bottom>0){
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0,bottom+100, 0);
    }
    //点击Push进入本人的情况
    if (self.model.fid == [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] integerValue]) {
        
        [self.btnForRefuse removeFromSuperview];
        [keyStatusImage removeFromSuperview];
        
    }else{
    
        _keyStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 60)];
        _keyStatusBtn.backgroundColor = [UIColor clearColor];
        [_keyStatusBtn addTarget:self action:@selector(actionForKeyStatus) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_keyStatusBtn];
    }
    
    
    if (self.model.keystatus == 1) {
        
        _isKeyStatus = YES;
        keyStatusImage.image = [UIImage imageNamed:@"是关键人.png"];
        
    }else{
     
        _isKeyStatus = NO;
        keyStatusImage.image = [UIImage imageNamed:@"非关键人.png"];
    }
 
    [self.tableView registerClass:[SignCell class] forCellReuseIdentifier:kIdentifierForSign];
    
    //关键人
    _keyStatusBtn.hidden = YES;
    keyStatusImage.hidden = YES;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)actionForKeyStatus
{
    
    _isKeyStatus = !_isKeyStatus;
    
    if (_isKeyStatus) {
        
        keyStatusImage.image = [UIImage imageNamed:@"是关键人.png"];
        
    }else {
        
        keyStatusImage.image = [UIImage imageNamed:@"非关键人.png"];
        
    }
    
    __block PushFriendViewC *weekSelf = self;
    [RequestManager actionForKeyStatus:self.model type:_isKeyStatus keyBlock:^(BOOL success) {
        
        if (success) {
            
            [Tool showAlter:weekSelf title:@"设置成功"];

            
        }else{
            
//            __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"网络异常！" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
//                
//                //Window隐藏，并置为nil，释放内存 不能少
//                __sheetWindow.hidden = YES;
//                __sheetWindow = nil;
//                
//            }];
            [Tool showAlter:self title:@"网络异常"];

        }
        
    }];
    

}

//查看
- (void)setOnlyInspect:(BOOL)onlyInspect
{
    if (onlyInspect) {
        
        [self.btnForAccept removeFromSuperview];
        [self.btnForRefuse removeFromSuperview];
        [keyStatusImage removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        
    }
}

//重写接受请求方法（添加联系人）
- (void)actionForAccept
{

    JYRemindViewController *vc = [[JYRemindViewController alloc] init];
    
    vc.isCreate = YES;
    vc.arrForFriend = @[self.model];
    
    
    
    RemindModel *modelForVc = [[RemindModel alloc] init];
    modelForVc.year = [[Tool actionForNowYear:nil] intValue];
    modelForVc.month = [[Tool actionForNowMonth:nil] intValue];
    modelForVc.day = [[Tool actionForNowSingleDay:nil] intValue];
    modelForVc.hour = [[Tool actionforNowHour] intValue];
    modelForVc.minute = [[Tool actionforNowMinute] intValue];
    modelForVc.musicName = 1;
    modelForVc.isOther = 0;
    modelForVc.upData = NO;
    modelForVc.isOn = YES;
    modelForVc.fidStr = [NSString stringWithFormat:@"%ld",(long)self.model.fid];
    
    vc.model = modelForVc;
    
    UIApplication *app = [UIApplication  sharedApplication];
//    JYTabBarVC *jytabBarVc = (JYTabBarVC *)app.delegate.window.rootViewController;
    RootTabViewController *jytabBarVc = (RootTabViewController*)app.delegate.window.rootViewController;

    UINavigationController *nav = jytabBarVc.viewControllers[1];
    
    for (int i = 0; i < nav.viewControllers.count; i++) {
        
        id jymainA = nav.viewControllers[i];
        
        if ([jymainA isKindOfClass:[BaseViewController class]]) {
            
            vc.delegate = jymainA;
            
            break;
        }
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

//重写拒绝方法(设为关键人)
- (void)actionForRefuse
{
    NSString *str = [NSString stringWithFormat:@"您确定要删除%@吗？",self.model.friend_name];
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    if (buttonIndex == 0) {
        
        
    }else {
     
        [RequestManager actionForDeleteFriendWithFid:(int )self.model.fid];
        
        [self.navigationController popViewControllerAnimated:YES];
        

    }
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //头像，备注，二维码
    if(self.showRemarkView){
        return 5;
    }else{
        return 4;
    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:strForNewAddFriend];
    
    if (!cell) {
        
        cell = [[NewAddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForNewAddFriend];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        if (self.model.fid == uid) {
            NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
            cell.headUrl = headUrlStr;
        }else{
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
            cell.headUrl = self.model.head_url;
        }
        NSString *xiaomiID = [NSString stringWithFormat:@"小秘号：%ld",(long)self.model.fid];
        cell.xiaomiId.text = xiaomiID;
        
        if([self.model.remarkName length]>0){
            cell.nameLabel.text = self.model.remarkName;
            
            //需求变更：有备注情况下此处显示昵称
            cell.tel_phone.text = [NSString stringWithFormat:@"昵称：%@",self.model.friend_name];
            cell.tel_phone.hidden = NO;
        }else{
            cell.nameLabel.text = self.model.friend_name;
            cell.tel_phone.hidden = YES;
        }
        
        cell.headImage.hidden = NO;
        cell.xiaomiId.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.barImage.hidden = YES;
        cell.openImage.hidden = YES;
        cell.barLbael.hidden = YES;
        
        
    }else {
        if(self.showRemarkView){//显示备注的情况
      
            if(indexPath.row==1){
                cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForRemark];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 11)];
                imgView.image = [UIImage imageNamed:@"展开.png"];
                cell.accessoryView = imgView;
                cell.textLabel.text = @"设置备注";
            }else if(indexPath.row==2){
                cell.barImage.image = [UIImage imageNamed:@"二维码.png"];
                cell.headImage.hidden = YES;
                cell.xiaomiId.hidden = YES;
                cell.tel_phone.hidden = YES;
                cell.nameLabel.hidden = YES;
                cell.barLbael.hidden = NO;
                cell.openImage.hidden = NO;
                cell.barImage.hidden = NO;
                cell.tel_phone.hidden = YES;
                
                if ([self.model.friend_name isEqualToString:@"俺自己"]||self.model.fid == [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue]){
                    cell.barLbael.text = @"我的二维码";
                }else{
                    cell.barLbael.text = @"Ta的二维码";
                }
                
            }else if(indexPath.row==3){
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
                cell.textLabel.text = @"地区";
                cell.detailTextLabel.text = self.model.local;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                NSLog(@"%@",self.model.local);
                
                return cell;
            }else if(indexPath.row==4){
                
                SignCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForSign];
                cell.signContentLabel.text = self.model.sign;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                NSLog(@"%@",self.model.sign);
                return cell;
            }
            
        }else{
            if(indexPath.row==1){
                cell.barImage.image = [UIImage imageNamed:@"二维码.png"];
                cell.headImage.hidden = YES;
                cell.xiaomiId.hidden = YES;
                cell.tel_phone.hidden = YES;
                cell.nameLabel.hidden = YES;
                cell.barLbael.hidden = NO;
                cell.openImage.hidden = NO;
                cell.barImage.hidden = NO;
                cell.tel_phone.hidden = YES;
                
                cell.barLbael.text = @"我的二维码";
               
            }else if(indexPath.row==2){
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
                cell.textLabel.text = @"地区";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserLocal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                NSLog(@"%@",self.model.local);
                return cell;
            }else if(indexPath.row==3){
                SignCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForSign];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.signContentLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserSign];
                cell.signContentLabel.textAlignment = NSTextAlignmentLeft;
//                NSLog(@"%@",self.model.sign);
                return cell;
            }
        }

    }
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return 120;
        
    }else if(indexPath.row<3){

        return 60;
        
    }else if(indexPath.row==3){
        if(self.showRemarkView){
            return 60.f;
        }else{//我自己，这行是签名
            
            return [SignCell heightForSign:[[NSUserDefaults standardUserDefaults]valueForKey:kUserSign]];
           
        }
    }else{
            return [SignCell heightForSign:self.model.sign];
    }
}


//#warning 接收好友方法,在这里加菊花图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.showRemarkView){
        
        if(indexPath.row==1){//备注
            EditRemarkViewController *erVC = [EditRemarkViewController new];
            erVC.friendModel = self.model;
            __weak typeof(self) ws = self;
            erVC.actionForPopWithRemarkName = ^(NSString *remark){
                ws.model.remarkName = remark;
                [ws.tableView reloadData];
            };
            [self.navigationController pushViewController:erVC animated:YES];
            
        }else if (indexPath.row == 2) {//二维码
            
            NewFriendBar *newFriend = [[NewFriendBar alloc] init];
            newFriend.model = self.model;
            
            [self.navigationController pushViewController:newFriend animated:YES];
        }
    }else{
        if(indexPath.row==1){
            NewFriendBar *newFriend = [[NewFriendBar alloc] init];
            newFriend.model = self.model;
            
            [self.navigationController pushViewController:newFriend animated:YES];
        }
    }
    
}

@end
