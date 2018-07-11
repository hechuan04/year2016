//
//  NewAddFriend.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "NewAddFriend.h"
#import "NewAddFriendCell.h"
#import "NewFriendBar.h"
#import "JYFriendListVC.h"
#import "WXApi.h"

static NSString *kIdentifierForNormal = @"kIdentifierForNormal";

@implementation ShareContent


@end



static NSString *strForNewAddFriend = @"strForNewAddFriend";


@interface NewAddFriend ()
{
 
 
}
@end

@implementation NewAddFriend


//添加完成的回调
- (void)actionForNotification
{
 
    //再次查询好友列表，更新好友列表
    [RequestManager actionForSelectFriendIsNewFriend:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _model.friend_name;
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(actionForRight:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 80, 44);
    [btnView setTitle:@"分享好友" forState:UIControlStateNormal];
    btnView.backgroundColor = [UIColor clearColor];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    self.rightBtn = btnView;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForNotification) name:kNotificationForNewFriend object:@""];
    
    [self _creatTableView];
    
}

- (void)actionForLeft:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 分享
- (void)actionForRight:(UIButton *)sender
{
    
    //监测分享好友方法
    [RequestManager actionForHttp:@"share_info"];
    
    ShareContent * content = [[ShareContent alloc]init];
//    content.hideUrl = @"http://itunes.apple.com/us/app/id1073540859";

//    content.hideUrl = [NSString stringWithFormat:@"http://xiaomi.qxhd.com/xiaomi/cardShare/card.jsp?uid=%ld",self.model.fid];
    content.hideUrl = [NSString stringWithFormat:@"%@cardShare/card.jsp?uid=%ld",kXiaomiUrl,self.model.fid];
//    content.hideUrl = [NSString stringWithFormat:@"http://xiaomi.jyhd.com/xiaomi/cardShare/card.jsp?uid=%ld",self.model.fid];
    content.title = @"诊断结果：你不是健忘症！你只是没有小秘神器！";
//    content.title = [NSString stringWithFormat:@"%@分享测试~",self.title];
    content.des = @"分享到微信朋友";
    [self weChatSceneSession:content];
    
    
//    content.hideUrl = [NSString stringWithFormat:@"http://static.erzao.org/babycard/html/index.html?b=%@&t=%ld&u=%@",_bid,(long)_taskID,userID];
//    NSLog(@"%@",content.hideUrl);

}


#pragma mark ---
#pragma mark ---微信---

// 授权登录
-(void)weChatAuth{
    
    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]){
        
        SendAuthReq* req =[[SendAuthReq alloc ] init] ;
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        
        [WXApi sendReq:req];
        
    } else {
        // 没有安装微信客户端
        NSLog(@"尚未安装微信客户端");
        
        // 发事件通知界面
        [self wechatPostEvent];
    }
}

// 分享好友
-(void)weChatSceneSession:(ShareContent *)shareObject
{
    // 分享到朋友圈
//    [self weChatSendMsg:WXSceneTimeline Object:shareObject];
    [self weChatSendMsg:WXSceneSession Object:shareObject];
}

-(void)weChatSendMsg:(int) scene Object:(ShareContent *)shareObject
{
    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]) {
        
        // 多媒体消息
        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = shareObject.title;
//        message.description = shareObject.des;
        NSString *name = self.model.friend_name;
        if(self.model.fid == [[NSUserDefaults standardUserDefaults] floatForKey:kUserXiaomiID]){
            name = [[NSUserDefaults standardUserDefaults]valueForKey:kUserName];
        }
        message.description = [NSString stringWithFormat:@"---------------------------\n小秘名片:%@\n---------------------------",name];
        
        // 图片内容作为扩展
//        NSString* imgurl = @"http://xiaomi.qxhd.com/xiaomi/img/xiaomi_icon.png";
//        NSURL* url = [NSURL URLWithString:imgurl];
//        NSData* data = [[NSData alloc]initWithContentsOfURL:url];
//        UIImage* img = [[UIImage alloc]initWithData:data];
        
        UIImage *img = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:self.model.head_url];
//        img = [img scaledToSize:CGSizeMake(80,80)];
        img = [UIImage createRoundedRectImage:img size:CGSizeMake(100, 100) radius:50];
        [message setThumbImage:img];
        
        // 多媒体消息中包含的网页数据对象
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = shareObject.hideUrl;
        message.mediaObject = ext;
        
        // 第三方程序发送消息至微信终端程序的消息结构体
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    } else {
        // 没有安装微信客户端
        //        NSLog(@"尚未安装微信客户端");
        
        // 发事件通知界面
        [self wechatPostEvent];
    }
    
}

-(void)wechatPostEvent{
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未安装微信客户端" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    NSLog(@"分享失败");


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//接受请求
- (void)actionForAccept
{
    [RequestManager actionForAcceptRequest:(int )_model.fid type:1];
    
    [_arrForNewFriend removeObject:_model];
    
    _actionForRemove(_arrForNewFriend);
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    NSArray *arrForAllVC = self.navigationController.viewControllers;
    id jyfriendVc = nil;
    
    
    //跳到好友列表
    for (int i = 0; i < arrForAllVC.count; i++ ) {
        
        jyfriendVc = arrForAllVC[i];
        
        if ([jyfriendVc isKindOfClass:[JYFriendListVC class]]) {
            
            [self.navigationController popToViewController:jyfriendVc animated:YES];
            
            break;
        }
    }
    
    
}

//拒绝请求
- (void)actionForRefuse
{
  
    [RequestManager actionForAcceptRequest:(int )_model.fid type:0];
    
    [_arrForNewFriend removeObject:_model];
    
    _actionForRemove(_arrForNewFriend);
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)_creatTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 0.5)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"NewAddFriendCell" bundle:nil] forCellReuseIdentifier:strForNewAddFriend];
    
    [Tool actionForHiddenMuchTable:_tableView];
    
    CGFloat heightForBtnNow = heightForBtn;
    if (IS_IPHONE_4_SCREEN) {
        
        heightForBtnNow = heightForBtn + 8;
        
    }else{
        
        
    }
    
    _btnForAccept = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForAccept.frame = CGRectMake((kScreenWidth - widthForBtn) / 2.0, 120 + 60*3 + pageForBtn, widthForBtn,heightForBtnNow);
    [_btnForAccept addTarget:self action:@selector(actionForAccept) forControlEvents:UIControlEventTouchUpInside];

    [_btnForAccept setImage:[UIImage imageNamed:@"agree.png"] forState:UIControlStateNormal];
    [_tableView addSubview:_btnForAccept];
    
    
    _btnForRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForRefuse.frame = CGRectMake((kScreenWidth - widthForBtn) / 2.0, _btnForAccept.bottom + pageForBtn, widthForBtn, heightForBtnNow);
    [_btnForRefuse addTarget:self action:@selector(actionForRefuse) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnForRefuse setImage:[UIImage imageNamed:@"refuse.png"] forState:UIControlStateNormal];
    [_tableView addSubview:_btnForRefuse];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
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
        if (_model.fid == uid) {
            NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            cell.headUrl = headUrlStr;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        }else{
            cell.headUrl = _model.head_url;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:_model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        }
        NSString *xiaomiID = [NSString stringWithFormat:@"小秘号：%ld",(long)_model.fid];
        cell.xiaomiId.text = xiaomiID;
        if(_model.tel_phone&&![_model.tel_phone isKindOfClass:[NSNull class]]&&![_model.tel_phone isEqualToString:@"<null>"]){
            cell.tel_phone.text = [NSString stringWithFormat:@"手机号：%@",_model.tel_phone];
        }
        cell.nameLabel.text = _model.friend_name;
        
        cell.headImage.hidden = NO;
        cell.xiaomiId.hidden = NO;
        cell.tel_phone.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.barImage.hidden = YES;
        cell.openImage.hidden = YES;
        cell.barLbael.hidden = YES;

    }else if(indexPath.row==1){
        
        cell.barImage.image = [UIImage imageNamed:@"二维码.png"];
        cell.headImage.hidden = YES;
        cell.xiaomiId.hidden = YES;
        cell.tel_phone.hidden = YES;
        cell.nameLabel.hidden = YES;
        cell.barLbael.hidden = NO;
        cell.openImage.hidden = NO;
        cell.barImage.hidden = NO;
        
        if ([_model.friend_name isEqualToString:@"俺自己"]) {
            
            cell.barLbael.text = @"我的二维码";

        }else{
         
            cell.barLbael.text = @"Ta的二维码";

        }
        
    }else if(indexPath.row==2){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
        cell.textLabel.text = @"地区";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = self.model.local;
        return cell;
        
    }else if(indexPath.row==3){
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
        cell.textLabel.text = @"个性签名";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = self.model.sign;
        return cell;
    }
//    cell.tel_phone.hidden = YES;

    return cell;
    
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 0) {
        
        return 120;
        
    }else{
    
        return 60;

    }
}


//#warning 接收好友方法,在这里加菊花图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 1) {
        
        NSString *xiaomiID = [NSString stringWithFormat:@"小秘号：%ld",(long)_model.fid];
  
        
        NewFriendBar *newFriend = [[NewFriendBar alloc] init];
        newFriend.model = _model;
        
        [self.navigationController pushViewController:newFriend animated:YES];
    }
   /*
    if (indexPath.row == 2) {
        
        [RequestManager actionForAcceptRequest:(int )_model.fid type:1];
        
        [_arrForNewFriend removeObject:_model];
        
        _actionForRemove(_arrForNewFriend);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(indexPath.row == 3){
        
        [RequestManager actionForAcceptRequest:(int )_model.fid type:0];
        
        [_arrForNewFriend removeObject:_model];
        
        _actionForRemove(_arrForNewFriend);

        [self.navigationController popViewControllerAnimated:YES];
    
    }
   */
}

@end
