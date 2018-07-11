//
//  SearchFriendDetailViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SearchFriendDetailViewController.h"
#import "NewAddFriendCell.h"
#import "NewFriendBar.h"
#import "JYFriendListVC.h"
#import "WXApi.h"

static NSString *kIdentifierForNormal = @"kIdentifierForNormal";
static NSString *strForNewAddFriend = @"strForNewAddFriend";

@interface SearchFriendDetailViewController ()
@end

@implementation SearchFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.searchModel.userName;
    self.title = @"详细资料";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGFloat heightForBtnNow = heightForBtn;
    if (IS_IPHONE_4_SCREEN) {
        
        heightForBtnNow = heightForBtn + 8;
        
    }
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = self.btnForAccept.frame;
    [_actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.layer.cornerRadius = 5.f;
    _actionButton.layer.masksToBounds = YES;
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.tableView addSubview:_actionButton];

    [self.btnForAccept removeFromSuperview];
    [self.btnForRefuse removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFriendStatus:) name:kNotificationForAddNewFriend object:nil];


    if(kSystemVersion>=10){
        UIView *navLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,0.5)];
        navLineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:navLineView];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    switch (self.searchModel.status) {
        case -1://验证通过
            [_actionButton setTitle:@"添加" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             _actionButton.backgroundColor = bgRedColor;
            break;
        case 0://等待验证
            [_actionButton setTitle:@"等待验证" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _actionButton.backgroundColor = [UIColor whiteColor];
            _actionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _actionButton.layer.borderWidth = 0.5f;
            _actionButton.enabled = NO;
            break;
        case 1://已添加
            [_actionButton setTitle:@"已添加" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _actionButton.backgroundColor = [UIColor whiteColor];
            _actionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _actionButton.layer.borderWidth = 0.5f;
            _actionButton.enabled = NO;
            break;
        case 2://可添加
            [_actionButton setTitle:@"添加" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _actionButton.backgroundColor = bgRedColor;
            break;
        default:
            break;
    }
    if(self.searchModel.status != 1){
        self.rightBtn.hidden = YES;//不是好友隐藏分享按钮
    }
}
- (void)actionButtonClicked:(UIButton *)sender
{
    if(self.searchModel.status==2){//可添加
        [RequestManager actionForAddNewFriend:[NSString stringWithFormat:@"%ld",self.searchModel.uid]];
    }else if(self.searchModel.status==-1){//验证通过
        [RequestManager actionForAcceptNewFriend:[NSString stringWithFormat:@"%ld",self.searchModel.uid]];
    }

}
// 分享
- (void)actionForRight:(UIButton *)sender
{
    
    //监测分享好友方法
    [RequestManager actionForHttp:@"share_info"];
    
    ShareContent * content = [[ShareContent alloc]init];
//    content.hideUrl = [NSString stringWithFormat:@"http://192.168.11.78:8080/xiaomi/cardShare/card.jsp?uid=%ld",self.searchModel.uid];
    content.hideUrl = [NSString stringWithFormat:@"%@cardShare/card.jsp?uid=%ld",kXiaomiUrl,self.searchModel.uid];
    content.title = @"诊断结果：你不是健忘症！你只是没有小秘神器！";
    content.des = @"分享到微信朋友";
    [self weChatSceneSession:content];
    
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
        NSString *name = self.searchModel.userName;
        if(self.model.fid == [[NSUserDefaults standardUserDefaults] floatForKey:kUserXiaomiID]){
            name = [[NSUserDefaults standardUserDefaults]valueForKey:kUserName];
        }
        message.description = [NSString stringWithFormat:@"-----------------------\n小秘名片:%@\n-----------------------",name];
        
        // 图片内容作为扩展
        //        NSString* imgurl = @"http://xiaomi.qxhd.com/xiaomi/img/xiaomi_icon.png";
        //        NSURL* url = [NSURL URLWithString:imgurl];
        //        NSData* data = [[NSData alloc]initWithContentsOfURL:url];
        //        UIImage* img = [[UIImage alloc]initWithData:data];
        
        UIImage *img = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:self.searchModel.avatarUrl];
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
        cell.headUrl = self.searchModel.avatarUrl;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.searchModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        NSString *xiaomiID = [NSString stringWithFormat:@"小秘号：%ld",(long)self.searchModel.uid];
        cell.xiaomiId.text = xiaomiID;
        cell.tel_phone.text = [NSString stringWithFormat:@"手机号：%@",self.searchModel.phoneNumber];
        cell.nameLabel.text = self.searchModel.userName;
        
        cell.headImage.hidden = NO;
        cell.xiaomiId.hidden = NO;
        cell.tel_phone.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.barImage.hidden = YES;
        cell.openImage.hidden = YES;
        cell.barLbael.hidden = YES;
        
    }else if(indexPath.row == 1){
        
        cell.barImage.image = [UIImage imageNamed:@"二维码.png"];
        cell.headImage.hidden = YES;
        cell.xiaomiId.hidden = YES;
        cell.tel_phone.hidden = YES;
        cell.nameLabel.hidden = YES;
        cell.barLbael.hidden = NO;
        cell.openImage.hidden = NO;
        cell.barImage.hidden = NO;
        cell.barLbael.text = @"Ta的二维码";
        
    }else if(indexPath.row == 2){
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
        cell.textLabel.text = @"地区";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = self.searchModel.location;
        return cell;
        
    }else if(indexPath.row == 3){
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifierForNormal];
        cell.textLabel.text = @"签名";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = self.searchModel.signature;
        return cell;
    }
    
    cell.tel_phone.hidden = YES;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        NewFriendBar *newFriend = [[NewFriendBar alloc] init];
        newFriend.model = [self.searchModel convertToFriendModel];
        [self.navigationController pushViewController:newFriend animated:YES];
    }
}


- (void)reloadFriendStatus:(NSNotification *)notice
{
    NSDictionary *dic = notice.userInfo;
    NSString *fid = [dic valueForKey:@"fid"];
    if([fid isEqualToString:[NSString stringWithFormat:@"%ld",self.searchModel.uid]]){
        //status被上层vc改变了
        if(self.searchModel.status==1){
            [_actionButton setTitle:@"已添加" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _actionButton.backgroundColor = [UIColor whiteColor];
            _actionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _actionButton.layer.borderWidth = 0.5f;
            _actionButton.enabled = NO;
        }else if(self.searchModel.status==0){
            [_actionButton setTitle:@"等待验证" forState:UIControlStateNormal];
            [_actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _actionButton.backgroundColor = [UIColor whiteColor];
            _actionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _actionButton.layer.borderWidth = 0.5f;
            _actionButton.enabled = NO;
        }
    }
}
@end
