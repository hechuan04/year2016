
//  RequestManager.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/11.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "RequestManager.h"
#import "AddressBook.h"
#import "FriendModel.h"
#import "JYMainViewController.h"
#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import "BaseLoad.h"
#import "ScanDirectory.h"
#import "ScanUtil.h"
#import "AppHelper.h"
#import "SDImageCache.h"

@implementation RequestManager
{
 
    UIWindow  *__sheetWindow;

}
#pragma mark 第一次登录上传头像
+ (void)actionForDeviceToken {
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *deviceToken = [def objectForKey:kDeviceToken];
    
    NSArray *arr = [deviceToken componentsSeparatedByString:@" "];
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < arr.count; i++) {
        
        [str appendString:arr[i]];
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@updUser",kXiaomiUrl];
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
 
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]  forKey:@"uid"];
    [dic setObject:str forKey:@"token"];
    
    
    /*NSString *str111 = [NSString stringWithFormat:@"openID:%@",openID];
     UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:str111 message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     [alterView show];*/
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strForSucc = [responseObject objectForKey:@"flag"];
        if ([strForSucc isEqualToString:@"succ"]) {
            NSString *tToken = responseObject[@"tToken"];
            if(![tToken isKindOfClass:[NSNull class]]&&[tToken length]>0){
                [RequestManager kickOffLoginPeople:tToken];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

#pragma mark 第一次登录上传头像
+ (void)actionForUpNameAndHead:(passType)type
                       thirdId:(NSString *)thirdId
                      validate:(NSString *)validate {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [def objectForKey:kUserName];
    NSString *head = [def objectForKey:kUserHead];
    NSString *deviceToken = [def objectForKey:kDeviceToken];
    NSString *openID = thirdId;
    
    if(!name && type != telLogin){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录异常，请检查您的网络设置!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alter show];
        [ProgressHUD dismiss];
        return;
    }
    
    NSArray *arr = [deviceToken componentsSeparatedByString:@" "];
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < arr.count; i++) {
        
        [str appendString:arr[i]];
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@login",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [dic setObject:str forKey:@"token"];
    
    if (type == qqLogin) {
        
        [dic setObject:name forKey:@"userName"];
        [dic setObject:head forKey:@"head"];
        [dic setObject:openID forKey:@"qq_third_id"];
        
    }else if(type == weiboLogin){
        
        [dic setObject:name forKey:@"userName"];
        [dic setObject:head forKey:@"head"];
        [dic setObject:openID forKey:@"weibo_third_id"];

    }else if(type == weixinLogin){
       
        [dic setObject:name forKey:@"userName"];
        [dic setObject:head forKey:@"head"];
        [dic setObject:openID forKey:@"wx_third_id"];

    }else{
    
        [dic setObject:openID forKey:@"tel"];
        [dic setObject:validate forKey:@"validate"];
    }
    
    
    /*NSString *str111 = [NSString stringWithFormat:@"openID:%@",openID];
     UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:str111 message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     [alterView show];*/
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (responseObject[@"uid"] == nil) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"上传数据失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
            
            [defaults setBool:NO forKey:kUserFirstLogin];
            [defaults setBool:NO forKey:kIsLogin];
            
            return ;
            
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *strForFail = [responseObject objectForKey:@"flag"];
            if ([strForFail isEqualToString:@"fail"]) {
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"上传数据失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterView show];
                [defaults setBool:NO forKey:kUserFirstLogin];
                [defaults setBool:NO forKey:kIsLogin];
                [ProgressHUD dismiss];
                
                return ;
            }
            
            BOOL isFirstLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstLogin];
            NSLog(@"%@",responseObject);
            if (!isFirstLogin) {
                
                if ([[[responseObject objectForKey:@"user"] objectForKey:@"isData"] intValue] != 0) {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLogin];
                    
                }
                
            }
            
            BOOL isTiUp = NO;
            if ([responseObject[@"bindTel"] intValue] == 1) {
                
            }else{
             
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                NSLog(@"验证码错误");
                return;
            }
            
            
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setBool:YES forKey:kIsLogin];
            [def setObject:responseObject[@"uid"] forKey:kUserXiaomiID];
            
            NSDictionary *dicForUser = responseObject[@"user"];
            
            [def setObject:dicForUser[@"head"] forKey:kUserHead];
            [def setObject:dicForUser[@"userName"] forKey:kUserName];
            
            NSString *skin = dicForUser[@"skin"];
            if(skin&&![skin isKindOfClass:[NSNull class]]&&![skin isEqualToString:@"<null>"]){

                [def setObject:skin forKey:kUserSkin];
                //更新换肤状态
                [BaseLoad skinAction];
                [[JYSkinManager shareSkinManager]actionForChangeSkin:skin];
            }
            
            //绑定第三方ID
            if (![dicForUser[@"qq_third_id"] isKindOfClass:[NSNull class]]) {
                [def setObject:dicForUser[@"qq_third_id"] forKey:kQq_third_id];
            }else{
                [def setObject:@"" forKey:kQq_third_id];
            }
          
            if (![dicForUser[@"weibo_third_id"] isKindOfClass:[NSNull class]]) {
                [def setObject:dicForUser[@"weibo_third_id"] forKey:kWeibo_third_id];
            }else{
                [def setObject:@"" forKey:kWeibo_third_id];
            }
            
            if (![dicForUser[@"wx_third_id"] isKindOfClass:[NSNull class]]) {
                [def setObject:dicForUser[@"wx_third_id"] forKey:kWx_third_id];
            }else{
                [def setObject:@"" forKey:kWx_third_id];
            }
            

            
            
            NSLog(@"%@",[def objectForKey:kWeibo_third_id]);
            
            //增加性别，地区，签名三个字段
            if([dicForUser[@"sex"] isKindOfClass:[NSNull class]]){
                [def setObject:@"" forKey:kUserSex];
            }else{
                [def setObject:dicForUser[@"sex"] forKey:kUserSex];
            }
            if([dicForUser[@"city"] isKindOfClass:[NSNull class]]){
                [def setObject:@"" forKey:kUserLocal];
            }else{
                [def setObject:dicForUser[@"city"] forKey:kUserLocal];
            }
            
            if([dicForUser[@"sign"] isKindOfClass:[NSNull class]]){
                [def setObject:@"" forKey:kUserSign];
            }else{
                [def setObject:dicForUser[@"sign"] forKey:kUserSign];
            }
            
            if ([dicForUser[@"tel"] isKindOfClass:[NSNull class]]) {
                isTiUp = NO;
            }else{
                isTiUp = YES;
                NSString *tel = [NSString stringWithFormat:@"%@",dicForUser[@"tel"]];
                [def setObject:tel forKey:kuserTel];
            }
            
            //是否绑定手机
            [def setBool:isTiUp forKey:kTiUpTel];
            
            if([[NSNull null] isEqual:dicForUser[@"weibo"]] || [@"" isEqual:dicForUser[@"weibo"]]){
                [def setObject:@"-1" forKey:kTiUpWeiBo];
            }else{
                [def setObject:dicForUser[@"weibo"] forKey:kTiUpWeiBo];
            }
            
            [def synchronize];
            
            NSString *tToken = responseObject[@"tToken"];
            if(![tToken isKindOfClass:[NSNull class]]&&[tToken length]>0){
                [RequestManager kickOffLoginPeople:tToken];
            }
            
            RootTabViewController *jytabbarVC = [RootTabViewController shareInstance];
            UIApplication *pla = [UIApplication sharedApplication];
            pla.delegate.window.rootViewController = jytabbarVC;
            
            [jytabbarVC handle3DTouch];
            
            //[RequestManager actionForGroup];
            
            [ProgressHUD dismiss];
            
            //请求后台数据，同步
            if(kAppDelegate.logout){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:@"正在刷新数据..."];
                    kAppDelegate.logout = NO;
                });
            }
            [RequestManager actionForReloadData];
            [RequestManager loadAllPassWordWithResult:^(id responseObject) {
                
            }];
            
            //同步好友数据
            [RequestManager actionForSelectFriendIsNewFriend:YES];
            
            //同步组
            [RequestManager actionForGroup];
            
            
            
            //绑定微博账号
            //[self bindWeibo:responseObject[@"uid"] openIdParam:openID];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *err = [NSString stringWithFormat:@"%@",error];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:err message:err delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
    }];
    
}

#pragma mark 加载提醒数据
+ (void)actionForReloadData
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *xiaoMiId = [defaults objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@loading?uid=%@",kXiaomiUrl,xiaoMiId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([SVProgressHUD isVisible]){
            [SVProgressHUD dismiss];
        }
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        
        //判断是否加红点
        ManagerForButton *managerForBtn = [ManagerForButton shareManagerBtn];
        
        //新朋友个数
        int newFrC = [[dict objectForKey:@"haveapply"] intValue];
        
        [defaults setObject:@(newFrC) forKey:newFriendCount];
        /*
        //判断总的带请求好友是否超过现有的，超过说明有新好友
        int countNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] intValue];
        
        
        BOOL isHaveF = [[[NSUserDefaults standardUserDefaults] objectForKey:isHaveNewFriend] boolValue];
        
        int chaCount = 0;
        if (newFrC > countNumber) {
            
            chaCount = newFrC - countNumber;
            isHaveF = YES;
            
            [[[NSUserDefaults standardUserDefaults] objectForKey:isHaveNewFriend] boolValue];
            
        }else {
            
            chaCount = countNumber;
        }
        
        //不能存储，因为不确定看没看过，所以不能存储在userDefault中，暂时存放
        managerForBtn.newFriendCountNow = chaCount;
        */
    
        dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //判断是否隐藏主页未添加好友个数
//                if (newFrC > 0) {
//                    
//                    managerForBtn.numberLabelForPerson.hidden = NO;
//
//                }else{
//                
//                    managerForBtn.numberLabelForPerson.hidden = YES;
//                }
                
                
                id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
                if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
                    if(newFrC>0){
                        ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%d",newFrC];
                    }else{
                        ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = nil;
                    }
                }

                
                
                managerForBtn.haveNewFriend = YES;
                managerForBtn.numberLabelForPerson.text = [NSString stringWithFormat:@"%d",newFrC];
            });
            
      
      
        
        //#warning 在这里更改增加对于数据的删除
 
        NSArray *arrForMe = [dict objectForKey:@"me"]; //我发给别人的
        NSArray *arrForHe = [dict objectForKey:@"he"]; //别人发给我的
        
        
        NSArray *arrForShareMe = [dict objectForKey:@"share_me"]; //我发给别人的
        NSArray *arrForShareHe = [dict objectForKey:@"share_he"]; //别人发给我
        
        //FriendListManager *friendManager = [FriendListManager shareFriend];
        if ([arrForMe isEqual:[NSNull null]]) {
            
            arrForMe = @[];
            
        }
        
        if ([arrForHe isEqual:[NSNull null]]) {
            
            arrForHe = @[];
            
        }
        
        if ([arrForShareMe isEqual:[NSNull null]]) {
            
            arrForShareMe = @[];
        }
        
        if ([arrForShareHe isEqual:[NSNull null]]) {
            
            arrForShareHe = @[];
        }
        
        
        //我给别人的
        [Tool loadPassOtherRemind:arrForMe];

        //别人给我的提醒
        [Tool loadPassMeRemind:arrForHe];
        
        //别人分享给我的
        [Tool loadShareMeRemind:arrForShareHe];
        
        //我分享给别人
        [Tool loadShareOtherRemind:arrForShareMe];
     
        //#warning 在这里写通知，说明加载数据完毕，需要刷新页面

        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
        //查询所有的任务
        NSArray *allArray = [locManager searchAllDataWithText:@""];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
        
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        //加载完成，刷新列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:nil];
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([SVProgressHUD isVisible]){
            [SVProgressHUD dismiss];
        }
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    
}

#pragma mark 查询好友
+ (void)actionForSelectFriendIsNewFriend:(BOOL )isNew
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@queryFriend",kXiaomiUrl];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    [dic setObject:@"1" forKey:@"type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        
        NSArray *arrForDic = responseObject[@"data"];
        
        FriendListManager *manag = [FriendListManager shareFriend];
        
        [manag deleAllData];
        
        AddressBook *boo = [AddressBook shareAddressBook];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < arrForDic.count; i++) {
            

            FriendModel *model = [[FriendModel alloc] init];
            NSDictionary *dicForFriend = arrForDic[i];
            model.friend_name = dicForFriend[@"friendName"];
            model.head_url = dicForFriend[@"friendHead"];
            model.fid = [dicForFriend[@"friendId"] integerValue];
            model.status = 2;
            model.tel_phone = dicForFriend[@"friendTel"];
            model.keystatus = [dicForFriend[@"keystatus"] intValue];
            NSString *remark = dicForFriend[@"remarkName"];
            NSString *city = dicForFriend[@"city"];
            if(city&&![city isKindOfClass:[NSNull class]]&&![city isEqualToString:@"<null>"]){
                model.local = city;
            }
            NSString *sign = dicForFriend[@"sign"];
            if(sign&&![sign isKindOfClass:[NSNull class]]&&![sign isEqualToString:@"<null>"]){
                model.sign = sign;
            }
            if(remark&&![remark isKindOfClass:[NSNull class]]&&![remark isEqualToString:@"<null>"]){
                model.remarkName = remark;
            }else{
                model.remarkName = @"";
            }
            if(![model.friend_name isKindOfClass:[NSNull class]]){
                [manag insertDataWithName:model.friend_name fid:model.fid headUrl:model.head_url status:model.status telIPhone:model.tel_phone keyStatus:model.keystatus remarkName:model.remarkName city:model.local sign:model.sign];
                [arr addObject:model];
            }

        }
        
        //查询所有的任务
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllFriend = arr;
        boo.arrForFriend = arr;
        
        
        //刷新提醒列表
        [RequestManager actionForReloadData];
      
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForNewFriend object:@""];
        
        //新创建的发送通知，不是新创建的不发送
        if (isNew) {

            //之前删除的好友可能又加回来，需要刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        
    }];
    
}

#pragma mark 同步手机通讯录好友
+ (NSArray *)actionForAddressBookWithArr:(NSArray *)arrForAllModel isNewFriend:(BOOL)isNewFriend {
    
    if (isNewFriend) {
        
        [SVProgressHUD showWithStatus:@"添加好友成功!"];
        
    }else {
        
        [SVProgressHUD showWithStatus:@"同步中…"];
        
    }
    
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < arrForAllModel.count; i++) {
        
        FriendModel *model = arrForAllModel[i];
        
        if (i == arrForAllModel.count - 1) {
            
            [str appendString:[NSString stringWithFormat:@"%@",model.tel_phone]];
            
        }else{
            
            [str appendString:[NSString stringWithFormat:@"%@,",model.tel_phone]];
            
        }
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@synTelFri",kXiaomiUrl];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [dic setObject:str forKey:@"telStr"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
//        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
//             [SVProgressHUD showSuccessWithStatus:@"同步失败"];
//        }else{
//            [SVProgressHUD showSuccessWithStatus:@"同步完成"];
//        }

        
        NSDictionary *dicForData = (NSDictionary *)responseObject;
        
        AddressBook *address = [AddressBook shareAddressBook];
        
        NSArray *alreadySend = [dicForData objectForKey:@"3"];
        NSArray *beWorthToAdd = [dicForData objectForKey:@"1"];
        NSArray *noXioami = [dicForData objectForKey:@"0"];
        NSArray *alreadyAdd = [dicForData objectForKey:@"2"];
        
        
        //点击同步通讯录
        if(!isNewFriend){
            NSString *title = [NSString stringWithFormat:@"您有%ld位小秘好友!",[alreadyAdd count]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }

        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < alreadySend.count; i ++) {
            
            FriendModel *model = [address.dicForAllName objectForKey:alreadySend[i]];
            
            model.status = 3;
            [arr1 addObject:model];
            
        }
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i < beWorthToAdd.count; i ++) {
            
            FriendModel *model = [address.dicForAllName objectForKey:beWorthToAdd[i]];
            model.status = 1;
            [arr2 addObject:model];
            
        }
        
        NSMutableArray *arr3 = [NSMutableArray array];
        for (int i = 0; i < noXioami.count; i++) {
            
            FriendModel *model = [address.dicForAllName objectForKey:noXioami[i]];
            model.status = 0;
            [arr3 addObject:model];
        }
        
        NSMutableArray *arr4 = [NSMutableArray array];
        for (int i = 0; i < alreadyAdd.count; i++) {
            
            FriendModel *model = [address.dicForAllName objectForKey:alreadyAdd[i]];
            model.status = 2;
            [arr4 addObject:model];
            
        }
        
        
        NSDictionary *dic1 = [Tool actionForReturnNameDic:arr1];
        NSDictionary *dic2 = [Tool actionForReturnNameDic:arr2];
        NSDictionary *dic3 = [Tool actionForReturnNameDic:arr3];
        NSDictionary *dic4 = [Tool actionForReturnNameDic:arr4];
        
        NSArray *arrFor4Dic = @[dic1,dic2,dic3,dic4];
        
        
        address.arrForAddress  = arrFor4Dic;
        
        //通过通讯录添加完成的回调
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForApplyFriden object:@""];
        
//        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"同步通讯录失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        [SVProgressHUD dismiss];
        
    }];
    
    return nil;
}

#pragma mark 添加朋友
+ (void)actionForAddFriendWithTel:(NSString *)tel_phone {
    
    [ProgressHUD show:@"请求发送中…"];
    NSMutableString *strForTel = [NSMutableString string];
    
    NSArray *arrForTel = [tel_phone componentsSeparatedByString:@"-"];
    
    for (int i = 0 ; i < arrForTel.count; i++) {
        
        [strForTel appendString:arrForTel[i]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@addFriend",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    [dic setObject:strForTel forKey:@"tel"];
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    __block NSString *telStr = strForTel;
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        
        //移除菊花图
        [ProgressHUD dismiss];
        
//        AddressBook *add = [AddressBook shareAddressBook];
//        [RequestManager actionForAddressBookWithArr:add.arrForBeforeA isNewFriend:NO];
        
        [RequestManager actionForNewPushWithTelFriend:telStr type:@"2"];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        //移除菊花图
        [ProgressHUD dismiss];
        
    }];
    
    
    
}

#pragma mark 查询待接收的好友列表
+ (void)actionForSelectLoginFriendIsNew:(BOOL )isNew
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@queryFriend",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    [dic setObject:@"0" forKey:@"type"];
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        DataArray *arrForMa = [DataArray shareDateArray];
        
        NSArray *arrForNewFriend = [responseObject objectForKey:@"data"];
        NSMutableArray *arrForF = [NSMutableArray array];
        for (int i = 0; i < arrForNewFriend.count; i++) {
            
            NSDictionary *dic = arrForNewFriend[i];
            
            FriendModel *model = [[FriendModel alloc] init];
            
            model.friend_name = dic[@"userName"];
            model.fid = [dic[@"uid"] intValue];
            model.head_url = dic[@"userHead"];
            model.local = dic[@"city"];
            if(isNew){
                model.sign = dic[@"fsign"];
            }else{
                model.sign = dic[@"sign"];
            }
            [arrForF addObject:model];
            
        }
        
        //待接收好友存入列表
        arrForMa.arrForNewFreind = arrForF;
        
        
        //好友列表刷新
        if (isNew) {
            
            int haveapply = [[responseObject objectForKey:@"newFCount"] intValue];
            //存储一下总的
            [[NSUserDefaults standardUserDefaults] setObject:@(haveapply) forKey:newFriendCount];
            //没有新好友
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isHaveNewFriend];
            
//            ManagerForButton *btn = [ManagerForButton shareManagerBtn];
            
//            btn.haveNewFriend = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
          
                //通讯录 角标
                id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
                if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
                    if(haveapply>0){
                        ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%d",haveapply];
                    }else{
                        ((RootTabViewController *)jytabBarVc).tabBar.items[3].badgeValue = nil;
                    }
                }
                
                //删除label上的数字
                JYNotReadList *notList = [JYNotReadList shareNotReadList];
                [notList selectNotReadRemind];
                
            });
            
            
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForNewFriend object:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForAcceptFriend object:@""];
            
        }else{
            
            
            //appdelegate接到通知
            NSUserDefaults *stan = [NSUserDefaults standardUserDefaults];
            int haveapply = [[responseObject objectForKey:@"newFCount"] intValue];
            [stan setObject:@(haveapply) forKey:newFriendCount];

            //当前总的
            //判断当前存储的是否大于请求网络的好友数量
            /*
            int nowNumber = [[stan objectForKey:newFriendCount] intValue];
            int chaNumber = haveapply - nowNumber;
            
            btn.newFriendCountNow = chaNumber;
            
            //有新好友
            if (chaNumber == 0) {
                
                [stan setBool:NO forKey:isHaveNewFriend];
                btn.haveNewFriend = NO;
                
            }else {
                
                [stan setBool:YES forKey:isHaveNewFriend];
                btn.haveNewFriend = YES;
                
            }
            */
            
      
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForAcceptFriend object:@""];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        
    }];
    
    
}

#pragma mark 点击接受好友的方法
+ (void )actionForAcceptRequest:(int )fid type:(int )type {
    
    [ProgressHUD show:@"添加中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@confirmFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"fid"];
    [dic setObject:@(type) forKey:@"type"];
    [dic setObject:@(fid) forKey:@"uid"];
    
    __block int fidNow = fid;
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        
        NSString *fidStr = [NSString stringWithFormat:@"%d",fidNow];
        
  
        
        if ([responseObject[@"isAccept"] intValue] == 1) {
            
            //点击接收了好友
            [RequestManager actionForNewPushFriend:fidStr type:@"3"];
            [RequestManager actionForSelectFriendIsNewFriend:YES];
            [RequestManager actionForSelectLoginFriendIsNew:YES];
            
        }else {
            
            [RequestManager actionForSelectLoginFriendIsNew:YES];
            
        }
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        
        [ProgressHUD dismiss];
        
    }];
    
    
}

#pragma mark 群组创建
+ (void)actionForCreateGroupWithName:(NSString *)groupName
                         groupHeader:(UIImage *)groupHeader
                           friendArr:(NSArray *)friendArr {
    
    [ProgressHUD show:@"创建组中…"];
    DataArray *dataArr = [DataArray shareDateArray];
    
    dataArr.strForGroupName = groupName;
    dataArr.arrForGroup = friendArr;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@createGroup",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableString *idStr = [NSMutableString string];
    
    for (int i = 0; i < friendArr.count; i++) {
        
        
        FriendModel *model = friendArr[i];
        
        NSString *fid = @"";
        
        if (i == friendArr.count - 1) {
            
            fid = [NSString stringWithFormat:@"%ld",(long)model.fid];
            
            
        }else {
            
            fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            
        }
        
        [idStr appendString:fid];
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [dic setObject:idStr forKey:@"fidStr"];
    [dic setObject:groupName forKey:@"groupName"];
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (groupHeader == nil) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"file" fileName:@"" mimeType:@""];
            
            
        }else {
            
            NSData *imageData = [Tool resetSizeOfImageData:groupHeader maxSize:100];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        
        DataArray *dataArr = [DataArray shareDateArray];
        
        //组表
        GroupListManager *manager = [GroupListManager shareGroup];
        NSInteger gid = [[responseObject objectForKey:@"gid"] integerValue];
        NSString *headerUrl = [responseObject objectForKey:@"ghead"];
        [manager insertDataWithGid:gid groupName:dataArr.strForGroupName groupHeaderUrl:headerUrl];
        
        //关系表
        FriendForGroupListManager *managerForF = [FriendForGroupListManager shareFriendGroup];
        
        
        dataArr.arrForAllGroup = [manager selectAllData];
        
        for (int i = 0; i <dataArr.arrForGroup.count; i ++) {
            
            FriendModel *model = dataArr.arrForGroup[i];
            
            [managerForF insertDataWithGid:gid fid:model.fid];
            
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForCreateGroup object:@""];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD dismiss];
        
    }];
    
}


#pragma mark 修改给他人发送的提醒
+ (void)actionForUpDataRemind:(RemindModel *)remindModel
             sendSuccessBlock:(sendFinishBlock)block
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@updateRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //暂时存储下Model
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.modelForSend = remindModel;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    //    ?title=xxx&message=zzz&
    //    sendUid=（发送人id）&ringId=（铃声id）&
    //    year=2015&month=10&day=11&hour=10&min=11&
    //    randomType=1&countNumber=0&gidStr=1,2（接收组id拼串）&
    //    uidStr=9,8,7（接收人id拼串）
    [dic setObject:uid forKey:@"sendUid"];
    [dic setObject:@(remindModel.uid) forKey:@"mid"];
    [dic setObject:remindModel.title forKey:@"title"];
    [dic setObject:remindModel.content forKey:@"message"];
    [dic setObject:@(remindModel.musicName) forKey:@"ringId"];
    [dic setObject:@(remindModel.year) forKey:@"year"];
    [dic setObject:@(remindModel.month) forKey:@"month"];
    [dic setObject:@(remindModel.day) forKey:@"day"];
    [dic setObject:@(remindModel.hour) forKey:@"hour"];
    [dic setObject:@(remindModel.minute) forKey:@"min"];
    [dic setObject:@(remindModel.randomType) forKey:@"randomType"];
    [dic setObject:@(remindModel.countNumber) forKey:@"countNumber"];
    [dic setObject:remindModel.audioRemoteStr forKey:@"audioStr"];
    [dic setObject:remindModel.audioDurationStr forKey:@"audioDurationStr"];
    [dic setObject:remindModel.latitudeStr forKey:@"latitudeStr"];
    [dic setObject:remindModel.longitudeStr forKey:@"longitudeStr"];
    [dic setObject:remindModel.headUrlStr forKey:@"headUrlStr"];
    [dic setObject:@(remindModel.offsetMinute) forKey:@"offsetMinute"];
    
    if (remindModel.weekStr != nil) {
        
        [dic setObject:remindModel.weekStr forKey:@"weekStr"];
        
    }
    
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    [dic setObject:userName forKey:@"sendUname"];
    

    
    if (remindModel.gidStr != nil) {
        
        [dic setObject:remindModel.gidStr forKey:@"gidStr"];
        
    }else{
        
        remindModel.gidStr = @"";
    }
    
    if (remindModel.fidStr != nil) {
        
        [dic setObject:remindModel.fidStr forKey:@"uidStr"];
        
    }else{
        
        remindModel.fidStr = @"";
    }
    
    if (remindModel.localInfo != nil) {
        
        [dic setObject:remindModel.localInfo forKey:@"localInfo"];
        
    }else{
        remindModel.localInfo = @"";
    }
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *imageArr = remindModel.files;
        
        if (imageArr.count == 0) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
            
        }else {
            
            for (int i = 0; i < imageArr.count; i ++) {
                
                UIImage *imageNow = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageNow, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
        //发送语音
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if([remindModel.audioPathStr length]>0){
            NSArray *audioPathArr = [remindModel.audioPathStr componentsSeparatedByString:@","];
            if([audioPathArr count]>0){
                for (int i = 0; i < [audioPathArr count]; i ++) {
                    if([audioPathArr[i] length]>0){
                        NSString *fullPath = [path stringByAppendingPathComponent:audioPathArr[i]];
                        NSData *audioData = [NSData dataWithContentsOfFile:fullPath];
                        NSString *fileName = [fullPath lastPathComponent];
                        if(audioData){
                            [formData appendPartWithFileData:audioData name:@"audios" fileName:fileName mimeType:@"audio/caf"];
                        }
                    }
                }
            }
        }else{
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"audios" fileName:@"" mimeType:@""];
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [ProgressHUD dismiss];
            
            //发送失败回调
            block(NO);
            
            //#warning 没有网络或发送失败的情况下调用本地数据库，有fid,gid
            /*
             LocalListManager *locManager = [LocalListManager shareLocalListManager];
             
             int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
             
             [locManager deleteDataWithUid:remindModel.oid];
             
             remindModel.isTop = @"0";
             remindModel.isOther = 0;
             //[locManager insertDataWithremindModel:remindModel usersID:xiaomiID];
             
             dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
             */
            return;
        }
        
        [ProgressHUD dismiss];
        
        NSString *notFri = [responseObject objectForKey:@"notFri"];
        if([notFri intValue]!=-1){
            
            FriendModel *model = [[FriendListManager shareFriend]selectDataWithFid:[notFri intValue]];
            if(model){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败!" message:[NSString stringWithFormat:@"用户“%@”已不是您的好友!",model.friend_name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
        }
        
        //发送成功的回调
        block(YES);
        
        
        IncidentListManager *listManager = [IncidentListManager shareIncidentManager];
        
        //更改先删除在插入
        [listManager deleteDataWithUid:remindModel.uid ownId:0 existUid:YES];
        
        remindModel.isOther = 0;
        remindModel.isTop = @"0";
        remindModel.headUrlStr = [responseObject objectForKey:@"picStr"];
        remindModel.audioPathStr = [responseObject objectForKey:@"audioStr"];
        remindModel.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];
        
        //***********************当成功推送***********************/
        [RequestManager actionForNewPush:remindModel type:@"1"];

        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        [locManager deleteLocalAudioFileWithPathStr:remindModel.audioPathStr];
        
        
        
        dataArr.modelForSend.uid = remindModel.uid;
        dataArr.modelForSend.isOther = 0;
        dataArr.modelForSend.isTop = @"0";
        dataArr.modelForSend.headUrlStr = [responseObject objectForKey:@"picStr"];
        dataArr.modelForSend.audioPathStr = [responseObject objectForKey:@"audioStr"];
        dataArr.modelForSend.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];
        
        
        [listManager insertDataWithremindModel:dataArr.modelForSend];
        
        [locManager deleteDataWithUid:remindModel.oid];
        
        
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteImage object:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
        
        //列表刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD dismiss];
        
        //发送失败回调
        block(NO);
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
        //        DataArray *dataArr = [DataArray shareDateArray];
        //
        //        RemindModel *model = dataArr.modelForSend;
   
        remindModel.isTop = @"0";
        remindModel.isOther = 0;
        
        [locManager deleteDataWithUid:remindModel.oid];
        
        //[locManager insertDataWithremindModel:remindModel usersID:xiaomiID];
        
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
        return;
        
    }];
    
}

#pragma mark 给他人发送提醒
+ (void)actionForSendOtherRemind:(RemindModel *)remindModel
                sendSuccessBlock:(sendFinishBlock)block
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@createRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //暂时存储下Model
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.modelForSend = remindModel;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    //    ?title=xxx&message=zzz&
    //    sendUid=（发送人id）&ringId=（铃声id）&
    //    year=2015&month=10&day=11&hour=10&min=11&
    //    randomType=1&countNumber=0&gidStr=1,2（接收组id拼串）&
    //    uidStr=9,8,7（接收人id拼串）
    [dic setObject:uid forKey:@"sendUid"];
    [dic setObject:remindModel.title forKey:@"title"];
    [dic setObject:remindModel.content forKey:@"message"];
    [dic setObject:@(remindModel.musicName) forKey:@"ringId"];
    [dic setObject:@(remindModel.year) forKey:@"year"];
    [dic setObject:@(remindModel.month) forKey:@"month"];
    [dic setObject:@(remindModel.day) forKey:@"day"];
    [dic setObject:@(remindModel.hour) forKey:@"hour"];
    [dic setObject:@(remindModel.minute) forKey:@"min"];
    [dic setObject:@(remindModel.randomType) forKey:@"randomType"];
    [dic setObject:@(remindModel.countNumber) forKey:@"countNumber"];
    [dic setObject:remindModel.audioRemoteStr forKey:@"audioStr"];//修改提醒时间=新建
    [dic setObject:remindModel.audioDurationStr forKey:@"audioDurationStr"];
    [dic setObject:remindModel.latitudeStr forKey:@"latitudeStr"];
    [dic setObject:remindModel.longitudeStr forKey:@"longitudeStr"];
    [dic setObject:@(remindModel.offsetMinute) forKey:@"offsetMinute"];
    
    if (remindModel.weekStr != nil) {
       
        [dic setObject:remindModel.weekStr forKey:@"weekStr"];

    }
    
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    [dic setObject:userName forKey:@"sendUname"];
    
    
    if (remindModel.gidStr != nil) {
        
        [dic setObject:remindModel.gidStr forKey:@"gidStr"];
        
    }else{
        
        remindModel.gidStr = @"";
    }
    
    if (remindModel.fidStr != nil) {
        
        [dic setObject:remindModel.fidStr forKey:@"uidStr"];
        
    }else{
        
        remindModel.fidStr = @"";
    }
    
    if (remindModel.localInfo != nil) {
        
        [dic setObject:remindModel.localInfo forKey:@"localInfo"];
        
    }else{
        remindModel.localInfo = @"";
    }
    
    
    NSLog(@"%d",remindModel.randomType);
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
         NSArray *imageArr = remindModel.files;
        
        if (imageArr.count == 0) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
            
        }else {
            
            for (int i = 0; i < imageArr.count; i ++) {
                
                UIImage *imageNow = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageNow, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
        //发送语音
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if([remindModel.audioPathStr length]>0){
            NSArray *audioPathArr = [remindModel.audioPathStr componentsSeparatedByString:@","];
            if([audioPathArr count]>0){
                for (int i = 0; i < [audioPathArr count]; i ++) {
                    NSString *fullPath = [path stringByAppendingPathComponent:audioPathArr[i]];
                    NSData *audioData = [NSData dataWithContentsOfFile:fullPath];
                    NSString *fileName = [fullPath lastPathComponent];
                    if(audioData){
                        [formData appendPartWithFileData:audioData name:@"audios" fileName:fileName mimeType:@"audio/caf"];
                    }
                }
            }
        }else{
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"audios" fileName:@"" mimeType:@""];
        }
       

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [ProgressHUD dismiss];
            
            //发送失败回调
            block(NO);
      
            //#warning 没有网络或发送失败的情况下调用本地数据库，有fid,gid
            /*
            LocalListManager *locManager = [LocalListManager shareLocalListManager];
    
            int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            
            [locManager deleteDataWithUid:remindModel.oid];
            
            remindModel.isTop = @"0";
            remindModel.isOther = 0;
            //[locManager insertDataWithremindModel:remindModel usersID:xiaomiID];
            
            dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            */
            return;
        }
        
        [ProgressHUD dismiss];
        
        NSString *notFri = [responseObject objectForKey:@"notFri"];
        if([notFri intValue]!=-1){
            
            FriendModel *model = [[FriendListManager shareFriend]selectDataWithFid:[notFri intValue]];
            if(model){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败!" message:[NSString stringWithFormat:@"用户“%@”已不是您的好友!",model.friend_name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
        }
        
        //发送成功的回调
        block(YES);
        
        
        IncidentListManager *listManager = [IncidentListManager shareIncidentManager];
        
    
        remindModel.uid = [[responseObject objectForKey:@"mid"] intValue];
        remindModel.isOther = 0;
        remindModel.isTop = @"0";
        remindModel.headUrlStr = [responseObject objectForKey:@"picStr"];
        remindModel.audioPathStr = [responseObject objectForKey:@"audioStr"];
        remindModel.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];
        NSLog(@"%d",dataArr.modelForSend.randomType);
        
        //***********************当成功推送***********************/
        [RequestManager actionForNewPush:remindModel type:@"1"];
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        [locManager deleteLocalAudioFileWithPathStr:remindModel.audioPathStr];
        
       
        
        dataArr.modelForSend.uid = [[responseObject objectForKey:@"mid"] intValue];
        dataArr.modelForSend.isOther = 0;
        dataArr.modelForSend.isTop = @"0";
        dataArr.modelForSend.headUrlStr = [responseObject objectForKey:@"picStr"];
        dataArr.modelForSend.audioPathStr = [responseObject objectForKey:@"audioStr"];
        dataArr.modelForSend.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];
        
        
        [listManager insertDataWithremindModel:dataArr.modelForSend];
        
        [locManager deleteDataWithUid:remindModel.oid];
        
        
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteImage object:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
        
        //列表刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD dismiss];
    
        //发送失败回调
        block(NO);
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
//        DataArray *dataArr = [DataArray shareDateArray];
//        
//        RemindModel *model = dataArr.modelForSend;
        remindModel.isTop = @"0";
        remindModel.isOther = 0;

        [locManager deleteDataWithUid:remindModel.oid];
        
        //[locManager insertDataWithremindModel:remindModel usersID:xiaomiID];
        
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
        return;
        
    }];

}


#pragma mark 给他人发送提醒（只限于点击同意好友）
+ (void)actionForSendRemindForAddFriend:(RemindModel *)remindModel
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@createRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];

    
    [dic setObject:uid forKey:@"sendUid"];
    [dic setObject:remindModel.title forKey:@"title"];

    
    if (remindModel.weekStr != nil) {
        
        [dic setObject:remindModel.weekStr forKey:@"weekStr"];
        
    }

    
    [dic setObject:remindModel.fidStr forKey:@"uidStr"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = [NSData data];
        [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
        [formData appendPartWithFileData:data name:@"audios" fileName:@"" mimeType:@"audio/caf"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);

    }];
    
   

    
}


#pragma mark 给他人发送提醒(分享)
+ (void)actionForShareRemindWithLocalModel:(RemindModel *)remindModel
                                 andUidStr:(NSString *)uidStr
                                    ringID:(NSString *)ringIdStr
                                    fidStr:(NSString *)fidStr
                                    gidStr:(NSString *)gidStr
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@createRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //暂时存储下Model
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.modelForSend = remindModel;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    //    ?title=xxx&message=zzz&
    //    sendUid=（发送人id）&ringId=（铃声id）&
    //    year=2015&month=10&day=11&hour=10&min=11&
    //    randomType=1&countNumber=0&gidStr=1,2（接收组id拼串）&
    //    uidStr=9,8,7（接收人id拼串）
    [dic setObject:uid forKey:@"sendUid"];
    [dic setObject:remindModel.isTop forKey:@"isTop"];
    [dic setObject:remindModel.title forKey:@"title"];
    [dic setObject:remindModel.content forKey:@"message"];
    [dic setObject:@(remindModel.musicName) forKey:@"ringId"];
    [dic setObject:@(remindModel.year) forKey:@"year"];
    [dic setObject:@(remindModel.month) forKey:@"month"];
    [dic setObject:@(remindModel.day) forKey:@"day"];
    [dic setObject:@(remindModel.hour) forKey:@"hour"];
    [dic setObject:@(remindModel.minute) forKey:@"min"];
    [dic setObject:@(remindModel.randomType) forKey:@"randomType"];
    [dic setObject:@(remindModel.countNumber) forKey:@"countNumber"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    [dic setObject:userName forKey:@"sendUname"];
    
    [dic setObject:remindModel.audioDurationStr forKey:@"audioDurationStr"];
    [dic setObject:@(remindModel.offsetMinute) forKey:@"offsetMinute"];

    if (remindModel.localInfo != nil) {
        
        [dic setObject:remindModel.localInfo forKey:@"localInfo"];
        
    }else{
        remindModel.localInfo = @"";
    }
    
    NSMutableArray *mutArr = [NSMutableArray array];
    if (![remindModel.headUrlStr isEqualToString:@""] && ![remindModel.headUrlStr isKindOfClass:[NSNull class]] && ![remindModel.headUrlStr isEqualToString:@"(null)"] && ![remindModel.headUrlStr isEqualToString:@"<null>"] && remindModel.headUrlStr != nil){
        
        NSArray * tmpArr = [remindModel.headUrlStr componentsSeparatedByString:@","];
        NSLog(@"tmpArray:%@",tmpArr);
        
        // 从网络获取
        if (remindModel.uid != 0) {
            
           
            
        }else{
            
            // 从本地读取
            // 获得此程序的沙盒路径
            
            for (int i = 0; i < tmpArr.count; i ++) {
                
                NSString * fileStr = tmpArr[i];
                
                if (![fileStr isEqualToString:@""]) {
                    
                    // 存放文件路径会变，要重新获取
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *path = [paths objectAtIndex:0];
                    path = [path stringByAppendingPathComponent:@"img"];
                    NSArray *pathArray = [tmpArr[i] componentsSeparatedByString:@"/"];
                    NSString *folderStr = [pathArray objectAtIndex:pathArray.count-2];
                    NSString *imgStr = [pathArray lastObject];
                    NSString *imgPath = [NSString stringWithFormat:@"%@/%@/%@",path,folderStr,imgStr];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath] == YES) {
                        
                        NSData * imgData = [NSData dataWithContentsOfFile:imgPath];
                        UIImage * img = [UIImage imageWithData:imgData];
                        [mutArr addObject:img];
                        
                    }
                }
                
                
            }
        }     
    }
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *imageArr = mutArr;
        
        if (imageArr.count == 0) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
            
        }else {
            
            for (int i = 0; i < imageArr.count; i ++) {
                
                UIImage *imageNow = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageNow, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                
            }
            
            
        }
        //语音
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if([remindModel.audioPathStr length]>0){
            NSArray *audioPathArr = [remindModel.audioPathStr componentsSeparatedByString:@","];
            if([audioPathArr count]>0){
                for (int i = 0; i < [audioPathArr count]; i ++) {
                    NSString *fullPath = [path stringByAppendingPathComponent:audioPathArr[i]];
                    NSData *audioData = [NSData dataWithContentsOfFile:fullPath];
                    NSString *fileName = [fullPath lastPathComponent];
                    if(audioData){
                        [formData appendPartWithFileData:audioData name:@"audios" fileName:fileName mimeType:@"audio/caf"];
                    }
                }
            }
        }else{
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"audios" fileName:@"" mimeType:@""];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [ProgressHUD dismiss];
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您当前无网络，请检查后在发送" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alter show];
            
            
            //#warning 没有网络或发送失败的情况下调用本地数据库，有fid,gid
            LocalListManager *locManager = [LocalListManager shareLocalListManager];
            DataArray *dataArr = [DataArray shareDateArray];
            
            RemindModel *model = dataArr.modelForSend;
            
            model.isOther = 0;
            
            int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            
            [locManager deleteDataWithUid:model.oid];
            
            //[locManager insertDataWithremindModel:model usersID:xiaomiID];
            
            dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
            
            return;
        }
        
        [ProgressHUD dismiss];
  
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        DataArray *dataArr = [DataArray shareDateArray];
        RemindModel *model = dataArr.modelForSend;
        
        
        [locManager deleteLocalAudioFileWithPathStr:model.audioPathStr];
        [locManager deleteDataWithUid:model.oid];
        
        
        model.uid = [[responseObject objectForKey:@"mid"] intValue];
        model.isOther = 0;
        //model.isTop = @"0";
        model.isShare = 0;
        model.headUrlStr = [responseObject objectForKey:@"picStr"];
        model.audioPathStr = [responseObject objectForKey:@"audioStr"];
        model.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];
        
        NSString *uidstr = [NSString stringWithFormat:@"%d",model.uid];
        
        IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
        [incManager insertDataWithremindModel:model];
        
        //插入成功后分享给好友
        NSMutableArray *ar = [NSMutableArray array];
        [ar addObject:model];
        
//        [RequestManager actionForSendShareRemindWithUidStr:uidstr rindId:ringIdStr fidStr:fidStr gidStr:gidStr andModelArr:ar];
        
        [RequestManager actionForSendShareRemindWithUidStr:uidstr rindId:ringIdStr fidStr:fidStr gidStr:gidStr andModelArr:ar comBlock:^(id data, NSError *error) {
            
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD dismiss];
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您当前无网络，请检查后在发送" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alter show];
        
        
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
        DataArray *dataArr = [DataArray shareDateArray];
        
        RemindModel *model = dataArr.modelForSend;
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
       
        model.isOther = 0;

        [locManager deleteDataWithUid:model.oid];
        
        //[locManager insertDataWithremindModel:model usersID:xiaomiID];
        
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        return;
        
    }];
    
    
    
    
}


#pragma mark 查询群组接口
+ (void)actionForGroup
{
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@queryGroup",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    
    [dic setObject:uid forKey:@"uid"];
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        DataArray *dataArrManager = [DataArray shareDateArray];
        
        NSArray *arrForAllGroup = [responseObject objectForKey:@"data"];
        
        GroupListManager *manager = [GroupListManager shareGroup];
        FriendForGroupListManager *fManger = [FriendForGroupListManager shareFriendGroup];
        
        
        //清空表从新加
        [manager deleteAllData]; //清空组表
        [fManger deleteAllData]; //清空关系表
        
        //将加载好的群组数据赋值给数据管理者
        NSMutableArray *arrForAllGroupModel = [NSMutableArray array];
        for (int i = 0; i < arrForAllGroup.count; i ++ ) {
            
            NSDictionary *dic = arrForAllGroup[i];
            NSArray      *users = dic[@"users"];
            
            GroupModel *grModel = [[GroupModel alloc] init];
            
            NSString *gName = dic[@"groupName"];
            NSInteger gid = [dic[@"id"] integerValue];
            NSString *gHeader = dic[@"groupHead"];
            
            grModel.gid = (int )gid;
            grModel.group_name = gName;
            if(gHeader&&![gHeader isKindOfClass:[NSNull class]]&&![gHeader isEqualToString:@"<null>"]&&![gHeader isEqualToString:@"null"]){
                grModel.groupHeaderUrl = gHeader;
            }
            
            [arrForAllGroupModel addObject:grModel];
            
            [manager insertDataWithGid:gid groupName:gName groupHeaderUrl:gHeader];
            
            for (int j = 0; j < users.count; j++) {
                
                NSDictionary *dicForF = users[j];
                
                FriendModel *model = [[FriendModel alloc] init];
                
                model.head_url = dicForF[@"head"];
                model.friend_name = dicForF[@"userNmae"];
                model.fid = [dicForF[@"uid"] integerValue];
                
                [fManger insertDataWithGid:gid fid:model.fid];
            }
            
        }
        
        dataArrManager.arrForAllGroup = arrForAllGroupModel;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForDeleteGroup object:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForCreateGroup object:@""];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}

//绑定微博
+ (void)bindWeibo:(NSString*)uid openIdParam:(NSString*)openid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kWeiboLogin]){
        
        NSString *urlStr = [NSString stringWithFormat:@"%@bindingWeibo",kXiaomiUrl];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:uid forKey:@"uid"];
        [dic setObject:openid forKey:@"weibo"];
        
        [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){
                [defaults setBool:YES forKey:kTiUpWeiBo];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

#pragma mark 接收人删除事件
+ (void)actionForDeleteAccept:(NSString *)mid
             isChangeMainView:(BOOL )isChange {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delAcceptRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 5.0;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    
    [dic setObject:uid forKey:@"acceptUId"];
    [dic setObject:mid forKey:@"midStr"];
    
    __block NSString *nowMid = mid;
    __block BOOL nowIsChange = isChange;
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常,删除失败！"];
            [SVProgressHUD dismissWithDelay:0.5];

            return ;
        }
        
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        
        NSArray *midArr = [nowMid componentsSeparatedByString:@","];
        
        for (int i = 0; i < midArr.count; i ++) {
            
            NSString *midSt = midArr[i];
            
            [manager deleteDataWithUid:[midSt intValue] ownId:0 existUid:[midSt intValue]];
            
        }
        
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        NSArray *allArray = [locManager searchAllDataWithText:@""];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
        
        if (nowIsChange) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForListLoadData object:@""];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        //删除完成，列表刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
        [SVProgressHUD dismissWithDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [SVProgressHUD showErrorWithStatus:@"网络异常,删除失败！"];
        [SVProgressHUD dismissWithDelay:0.5];
        return ;
        
    }];
    
    
}

#pragma mark 母体删除事件
+ (void)actionForDeleteMotherIncident:(NSString *)mid
                     isChangeMainView:(BOOL )isChange {
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:mid forKey:@"midStr"];
    manager.requestSerializer.timeoutInterval = 5.0;
    __block NSString *nowMidStr = mid;
    __block BOOL nowIsChange = isChange;
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常,删除失败！"];
            [SVProgressHUD dismissWithDelay:0.5];
            
            return ;
        }
        
        
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        
        NSArray *midArr = [nowMidStr componentsSeparatedByString:@","];
        
        for (int i = 0; i < midArr.count; i ++) {
            
            NSString *midNow = midArr[i];
            [manager deleteDataWithUid:[midNow intValue] ownId:0 existUid:[midNow intValue]];
            
        }
        
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        NSArray *allArray = [locManager searchAllDataWithText:@""];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
        
        
        if (nowIsChange) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForListLoadData object:@""];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        //删除完成，列表刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
        [SVProgressHUD dismissWithDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常,删除失败！"];
        [SVProgressHUD dismissWithDelay:0.5];

        return ;
    }];
    
    
}

#pragma mark 删除好友方法
+ (void)actionForDeleteFriendWithFid:(int )fid
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delFriend",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    [dic setObject:@(fid) forKey:@"fid"];
    [dic setObject:userID forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //从新查询好友接口，更新页面
        [RequestManager actionForSelectFriendIsNewFriend:YES];
        
        //从新查找通讯录列表,刷新通讯录
//        AddressBook *addBook = [AddressBook shareAddressBook];
//        [RequestManager actionForAddressBookWithArr:addBook.arrForBeforeA isNewFriend:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}


#pragma mark 编辑群组
+ (void)actionForEditGroupModel:(GroupModel *)model
                      friendArr:(NSArray *)friendArr
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@updGroup",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(model.gid) forKey:@"id"];
    [dic setObject:model.group_name forKey:@"groupName"];
    
    NSMutableString *idStr = [NSMutableString string];
    
    for (int i = 0; i < friendArr.count; i++) {
        
        FriendModel *model = friendArr[i];
        
        NSString *fid = @"";
        
        if (i == friendArr.count - 1) {
            
            fid = [NSString stringWithFormat:@"%ld",(long)model.fid];
            
        }else {
            
            fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            
        }
        
        [idStr appendString:fid];
        
    }
    [dic setObject:idStr forKey:@"fidStr"];
    [ProgressHUD show:@"更新中..."];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (model.groupHeader == nil) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"file" fileName:@"" mimeType:@""];
            
            
        }else {
            
            NSData *imageData = [Tool resetSizeOfImageData:model.groupHeader maxSize:100];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [RequestManager actionForGroup];
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        
    }];
    
    
    
}

#pragma mark 删除组
+ (void)actionForDeleteGroupId:(int )gid
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delGroup",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(gid) forKey:@"gid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [RequestManager actionForGroup];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

#pragma mark 注销接口
+ (void)actionForCancelDevicetoken
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@cancle",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    [dic setObject:userID forKey:@"uid"];
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


#pragma mark 设置关键人接口                          1为关键人，0为取消
+ (void)actionForKeyStatus:(FriendModel *)model type:(int )isKeyStatus keyBlock:(keyStatusBlock)block{
    
    [ProgressHUD show:@"设置中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@setKeyFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    [dic setObject:userID forKey:@"uid"];
    [dic setObject:@(model.fid) forKey:@"fid"];
    [dic setObject:@(isKeyStatus) forKey:@"type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            [RequestManager actionForSelectFriendIsNewFriend:YES];
            
            block(YES);
            
        }else {
         
            block(NO);
        }
        
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(NO);
        [ProgressHUD dismiss];
        
    }];
    
}

#pragma mark 上传意见
+ (void)actionForSendFeedWithImageArr:(NSArray *)imageArr
                                 text:(NSString *)text {
    
    [ProgressHUD show:@"意见上传中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@feedback",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *xiaomiUid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaomiUid forKey:@"uid"];
    [dic setObject:text forKey:@"feedback"];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (imageArr.count == 0) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
            
        }else {
            
            for (int i = 0; i < imageArr.count; i ++) {
                
                UIImage *imageNow = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageNow, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                
            }
            
            
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"意见上传成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForBackSetView object:@""];
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"意见上传失败" message:@"请检查您的网络情况" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        
        [ProgressHUD dismiss];
        
    }];
    
    
}


#pragma mark 更改铃声 
+ (void)actionForChangeMusicName:(RemindModel *)model 
{
    NSString *urlS = @"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];

    if (model.isShare == 1 && model.isOther == 0) {
        urlS = @"updShareBase";
        [dic setObject:@(model.isLook) forKey:@"isLook"];
        [dic setObject:@(model.sid) forKey:@"rid"];
        [dic setObject:xiaomiID forKey:@"acceptUId"];

    }else if(model.isShare == 1 && model.isOther != 0){
        urlS = @"updShareInfo";
        [dic setObject:@(model.isLook) forKey:@"isLook"];
        [dic setObject:@(model.sid) forKey:@"rid"];
        [dic setObject:xiaomiID forKey:@"acceptUId"];

    }else{
        
        urlS = @"updateRemindRing";
        [dic setObject:@(model.uid) forKey:@"mid"];
        if(model.isOther==0){//发送的
            [dic setObject:@"" forKey:@"uid"];
        }else{//接受的
            [dic setObject:xiaomiID forKey:@"uid"];
        }
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kXiaomiUrl,urlS];
    NSURL *url = [NSURL URLWithString:urlStr];

    [dic setObject:@(model.musicName) forKey:@"ringId"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

#pragma mark 上传头像
+ (void)actionForPassNameAndUserHead:(UIImage *)image
                                name:(NSString *)name {
    
    [ProgressHUD show:@"上传中…"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@editorUser",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *nowName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    
    if (![name isEqualToString:@""]) {
        
        nowName = name;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userID = [defaults objectForKey:kUserXiaomiID];
    NSString *sign = [defaults objectForKey:kUserSign];
    NSString *city = [defaults objectForKey:kUserLocal];
    NSString *sex = [defaults objectForKey:kUserSex];
    NSString *skin = [defaults objectForKey:kUserSkin];
    
    if ([sign isEqual:[NSNull class]] || sign == nil) {
        
        sign = @"";
        [defaults setObject:sign forKey:kUserSign];
        
    }
    
    if ([sex isEqual:[NSNull class]] || sex == nil) {
        
        sex = @"";
        [defaults setObject:sex forKey:kUserSex];
        
    }
    
    if ([city isEqual:[NSNull class]] || city == nil) {
        
        city = @"";
        [defaults setObject:city forKey:kUserLocal];
        
    }
    
    if ([skin isEqual:[NSNull class]] || skin == nil) {
        
        skin = @"红色";
        [defaults setObject:skin forKey:kUserSkin];
    }
    
    //    sign
    //    city
    //    sex
    //    skin
    [dic setObject:nowName forKey:@"userName"];
    [dic setObject:userID forKey:@"uid"];
    [dic setObject:sign forKey:@"sign"];
    [dic setObject:city forKey:@"city"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:skin forKey:@"skin"];
    
    [manager POST:strUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        if (image == nil) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"file" fileName:@"" mimeType:@""];
            
            
        }else {
            
            NSData *imageData = [Tool resetSizeOfImageData:image maxSize:100];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicForAll = [responseObject objectForKey:@"user"];
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [ProgressHUD dismiss];
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"上传失败，请重试" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
            
            return ;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:dicForAll[@"head"] forKey:kUserHead];
        [[NSUserDefaults standardUserDefaults] setObject:dicForAll[@"userName"] forKey:kUserName];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForNewFriend object:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:@""];
//        [ProgressHUD dismiss];

        [ProgressHUD show:@"保存成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * 0.5)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"上传失败，请重试" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        [ProgressHUD dismiss];
        
    }];
    
}


#pragma mark 更改是否看过的状态
+ (void)actionForIsHaveLook:(NSString *)midStr
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@remindLook",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    [dic setObject:xiaomiID forKey:@"uid"];
    [dic setObject:midStr forKey:@"midStr"];
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshUnreadRemindLabel object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshUnreadRemindLabel object:nil];
    }];
    
    
    
    
}


#pragma mark 添加好友(手机,推送)
+ (void)actionForNewPushWithTelFriend:(NSString *)telStr type:(NSString *)type
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@push",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:type forKey:@"type"];
    [dic setObject:telStr forKey:@"tel"];
    [dic setObject:nameStr forKey:@"sendName"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}


#pragma mark 添加好友(扫码,推送)
+ (void)actionForNewPushFriend:(NSString *)fid type:(NSString *)type
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@push",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *sendId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:type forKey:@"type"];
    [dic setObject:fid forKey:@"uidStr"];
    [dic setObject:sendId forKey:@"sendId"];
    [dic setObject:nameStr forKey:@"sendName"];
    
    if ([type isEqualToString:@"3"]) {
        
        RemindModel *model = [[RemindModel alloc] init];
        model.title = @"我通过你的好友请求";
        model.weekStr = @"100";
        model.fidStr = fid;
        [RequestManager actionForSendRemindForAddFriend:model];
        
    }
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        
      
        
        
        //NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

#pragma mark 分享推送
+ (void)actionForSharePushWithUid:(NSString *)uidStr
                           gidStr:(NSString *)gidStr
                             type:(NSString *)type
                           number:(int )number
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@push",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *sendName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];

    [dic setObject:uidStr forKey:@"uidStr"];
    [dic setObject:gidStr forKey:@"gidStr"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:sendName forKey:@"sendName"];
    [dic setObject:userId forKey:@"sendId"];
    [dic setObject:@(number) forKey:@"shareNum"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

#pragma mark 给别人添加提醒(推送)
+ (void)actionForNewPush:(RemindModel *)model type:(NSString *)type
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@push",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSString *sendName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *title = model.title;
    NSString *time = [NSString stringWithFormat:@"%d,%d,%d,%d,%d",model.year,model.month,model.day,model.hour,model.minute];
    NSString *ringId = [NSString stringWithFormat:@"%d",model.musicName];
    
    NSArray *fidArr = [model.fidStr componentsSeparatedByString:@","];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    //把包括自己的去掉
    NSMutableString *fidStr = [NSMutableString string];
    for (int i = 0; i < fidArr.count; i++) {
        
        NSString *fstr = fidArr[i];
        
        if (![userId isEqualToString:fstr]) {
            
            NSString *fidS = [NSString stringWithFormat:@"%@,",fstr];
            [fidStr appendString:fidS];
        }
        
    }
    
    NSString *passStr = @"";
    if (fidStr.length > 1) {
        
        passStr = [fidStr substringWithRange:NSMakeRange(0, fidStr.length - 1)];
    }
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:sendName forKey:@"sendName"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:time forKey:@"time"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:ringId forKey:@"ringId"];
    [dic setObject:model.gidStr forKey:@"gidStr"];
    [dic setObject:passStr forKey:@"uidStr"];
    [dic setObject:@(model.uid) forKey:@"mid"];
    [dic setObject:userId forKey:@"sendId"];
    // 添加randomType类型
    NSString * randomType = [NSString stringWithFormat:@"%d",model.randomType];
    [dic setObject:randomType forKey:@"randomType"];
    
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 监控接口，点击按钮
+ (void)actionForHttp:(NSString *)strForPage
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //NSLog(@"%@",adId);
    
    NSString *day = [Tool actionForNowSingleDay:nil];
    NSString *month = [Tool actionForNowMonth:nil];
    NSString *year = [Tool actionForNowYear:nil];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    NSString *strForName = strForPage;
    NSString *strForUrl = [NSString stringWithFormat:@"http://data.qxhd.com/monitor_platform/insertPageOriginData?u_id=%@&login_time=%@&page_code=%@&appType=%d",adId,str,strForName,4];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strForUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // NSLog(@"%@",error);
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

#pragma mark 监控接口，上传时间
+ (void)actionForTime:(NSString *)time
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // NSLog(@"%@",adId);
    
    NSString *day = [Tool actionForNowSingleDay:nil];
    NSString *month = [Tool actionForNowMonth:nil];
    NSString *year = [Tool actionForNowYear:nil];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    
    NSString *stringForURL = @"http://data.qxhd.com/monitor_platform/synTemp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stringForURL]];
    [request setHTTPMethod:@"POST"];
    
    NSString *strForPhone = [JYFontManager  getCurrentDeviceModel];
    
    NSDictionary * paramsDict = @{@"u_id":adId,
                                  @"login_time":str,
                                  @"ph_type":strForPhone,
                                  @"start_time_dif":time,
                                  @"appType":@"4",
                                  @"way_name":@"App Store"};
    
    NSString *data = [NSString stringWithFormat:@"monitorJson=%@",paramsDict];
    
    
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //  NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //  NSLog(@"%@",error);
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    
}


#pragma mark 发送验证码
+ (void)actionForPostTest:(NSString *)number andBtn:(UIButton *)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"%@telValidate",kXiaomiUrl];;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 10;

    manager.requestSerializer.timeoutInterval = 3;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:number forKey:@"telNum"];
    
    __block NSString *numberTel = number;
    __block UIButton *senderNow = sender;
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            if ([[responseObject objectForKey:@"erroType"] isEqualToString:@"0"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForTest object:@""];
                
                [[NSUserDefaults standardUserDefaults] setObject:numberTel forKey:kThirdOpenID];
                selectManager.linshiUid = [responseObject objectForKey:@"uid"];
                
            }else{
                
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"该手机号已注册" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterView show];
                
                senderNow.userInteractionEnabled = YES;
            }
            
        }else{
            
            
            if ([[responseObject objectForKey:@"erroType"] isEqualToString:@"-1"]) {
                
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码发送过于频繁，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterView show];
                
                senderNow.userInteractionEnabled = YES;
                
            }
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请重新发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        senderNow.userInteractionEnabled = YES;
        
        
    }];
    
    
}


+ (void)actionForBind:(NSString *)validate
            andIPhone:(NSString *)telStr
          finishBlock:(lodingForTel)block
{
    
    JYSelectManager *select = [JYSelectManager shareSelectManager];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if (select.linshiUid == nil || [select.linshiUid isEqualToString:@""] || [select.linshiUid isKindOfClass:[NSNull class]]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请获取验证码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
        
    }
    
    /// @"thirdPartId"临时解决问题 验证码不能匹配问题
    NSDictionary *parameters = @{@"uid":select.linshiUid, @"validate":validate, @"tel":telStr, @"thirdPartId":telStr};
    manager.requestSerializer.timeoutInterval = 10;
    
    //发送短信验证码
    //__block NSString *strForTel = telStr;
    [manager POST:[kXiaomiUrl stringByAppendingString:@"bindingTel"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setBool:YES forKey:kTiUpTel];
            
            [defaults setObject:[responseObject objectForKey:@"userName"] forKey:kUserName];
            [defaults setObject:[responseObject objectForKey:@"userHead"] forKey:kUserHead];
            [defaults setObject:[responseObject objectForKey:@"thirdPartId"] forKey:kThirdOpenID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForTestAndIphone object:@""];
            
            //登录
            //[RequestManager actionForUpNameAndHead];
            
            block(YES);
       
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机绑定失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
    
    
}

#pragma mark 分享
+ (void)actionForSendShareRemindWithUidStr:(NSString *)uidStr
                                    rindId:(NSString *)ringId
                                    fidStr:(NSString *)fidStr
                                    gidStr:(NSString *)gidStr
                               andModelArr:(NSArray *)modelArr
                                  comBlock:(CompletedBlock )block;

{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@addToShareInfo",kXiaomiUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 5.0;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    [dic setObject:userID forKey:@"sendUid"];
    [dic setObject:ringId forKey:@"ringStr"];
    [dic setObject:uidStr forKey:@"midStr"];
    [dic setObject:gidStr forKey:@"gidStr"];
    [dic setObject:fidStr forKey:@"uidStr"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        JYShareList *shareList = [JYShareList shareList];
        
        NSString *strForSid = [responseObject objectForKey:@"sid"];
        NSArray *arrForSid = [strForSid componentsSeparatedByString:@","];
        
        
        for (int i = 0; i < modelArr.count; i ++) {
            
            RemindModel *model = modelArr[i];
            model.isShare = 1;
            int mid = [arrForSid[i] intValue];
            model.uid = model.uid;
            model.isTop = @"0";
            model.isOther = 0;
            model.isSave = 0;
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            model.createTime = [formatter stringFromDate:date];
            [shareList insertRemindModel:model fidStr:fidStr gidStr:gidStr mid:mid];
            
        }
        
        int count = (int )modelArr.count;
        
        [RequestManager actionForSharePushWithUid:fidStr gidStr:gidStr type:@"4" number:count];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        
        //列表页根据分享成功刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadAllListRemind object:@""];
        
        //回调
        block(responseObject,nil);
        
        //分享成功刷新界面
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error);
        NSLog(@"%@",error);
    }];
    
}


#pragma mark 删除分享
+ (void)actionForDeleteShareRemindWithUidStr:(NSString *)sendUid
                                andAcceptUid:(NSString *)acceptUid modelArr:(NSArray *)modelArr
{
 
    NSString *urlStr = [NSString stringWithFormat:@"%@delShareInfo",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 5.0;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    [dic setObject:sendUid forKey:@"baseStr"];
    [dic setObject:acceptUid forKey:@"infoStr"];
    [dic setObject:userID forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"flag"]isEqualToString:@"succ"]) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常，删除失败"];
            [SVProgressHUD dismissWithDelay:0.5];

            return ;
        }
    
    
        
        NSLog(@"删除%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
        
        //删除完成，列表刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
        [SVProgressHUD dismissWithDelay:0.5];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常，删除失败"];
        [SVProgressHUD dismissWithDelay:0.5];
        
    }];
    
}


#pragma mark 分享编辑方法
+ (void)actionForEditShareList:(RemindModel *)model
{
 
    NSString *urlStr = [NSString stringWithFormat:@"%@updShareInfo",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    
    [dic setObject:@(model.sid) forKey:@"rid"];
    [dic setObject:@(model.musicName) forKey:@"ringId"];
    [dic setObject:@"0" forKey:@"isLook"];
    [dic setObject:userID forKey:@"acceptUId"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"更改分享列表成功");
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshUnreadRemindLabel object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"更新分享列表失败");
        
    }];
    
}

#pragma mark 置顶方法
+ (void)actionForTopWithRmidStr:(NSString *)rmidStr
                     andSmidStr:(NSString *)smidStr
                     andRsidStr:(NSString *)rsidStr
                     andSsidStr:(NSString *)ssidStr
                          isTop:(NSString *)isTop
{
 
    NSString *urlStr = [NSString stringWithFormat:@"%@listToTop",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 5.0;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *uidStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    [dic setObject:rmidStr forKey:@"rmidStr"];
    [dic setObject:smidStr forKey:@"smidStr"];
    [dic setObject:rsidStr forKey:@"rsidStr"];
    [dic setObject:ssidStr forKey:@"ssidStr"];
    [dic setObject:uidStr forKey:@"uid"];
    [dic setObject:isTop forKey:@"isTopStr"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"置顶成功");
        
        //置顶成功刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:nil];
        [SVProgressHUD showSuccessWithStatus:@"置顶成功！"];
        [SVProgressHUD dismissWithDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常，置顶失败！"];
        [SVProgressHUD dismissWithDelay:0.5];
    }];
    
}


#pragma mark 请求相册数据

+ (void)requestPhotoDataWithCompletedBlock:(CompletedBlock)completedBlcok{
    [ProgressHUD show:@"查询中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@querySendImg",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSAssert(![xiaomiID isEqual:[NSNull null]], @"小秘id不能为空");
    NSDictionary *params = @{@"uid":xiaomiID};
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if(completedBlcok){
                    completedBlcok(data,nil);
                    return;
                }
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        completedBlcok(nil,error);
    }];
}

#pragma mark 根据相片id删除相片
+ (void)deletePhotoWithIdStr:(NSString *)idStr completedBlock:(CompletedBlock)completedBlcok{
    [ProgressHUD show:@"正在删除…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delSendImg",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    if(!idStr){
        return;
    }
    NSDictionary *params = @{@"hidStr":idStr};
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                if(completedBlcok){
                    completedBlcok(nil,nil);
                    return;
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
    }];
}


#pragma mark  请求个人收藏数据
+ (void)requestCollectionDataWithCompletedBlock:(CompletedBlock)completedBlcok{
    [ProgressHUD show:@"查询中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@querySaveInfo",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSAssert(![xiaomiID isEqual:[NSNull null]], @"小秘id不能为空");
    NSDictionary *params = @{@"uid":xiaomiID};
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ProgressHUD dismiss];
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                NSArray *results = [responseObject objectForKey:@"data"];
                if(completedBlcok){
                    completedBlcok(results,nil);
                    return;
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        completedBlcok(nil,error);
    }];
}


#pragma mark 删除一条收藏

+ (void)deleteCollectionDataWithId:(NSInteger)sId completedBlock:(CompletedBlock)completedBlcok{
    [ProgressHUD show:@"正在删除…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@delSaveInfo",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSDictionary *params = @{@"sid":@(sId)};
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                
                [RequestManager actionForReloadData];
                
                //[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
                if(completedBlcok){
                    completedBlcok(nil,nil);
                    return;
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
    }];
    

}
#pragma mark 查看收藏详情

+ (void)requestCollectionDetailDataWithId:(NSInteger)mId
                                  isOhter:(BOOL)isOther
                           completedBlock:(CompletedBlock)completedBlcok{
    [ProgressHUD show:@"正在查询…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@querySaveBase",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSString *uid = @"";
    if(isOther){//接受的，传个uid
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    }
    
    NSDictionary *params = @{@"mid":@(mId),@"uid":uid};
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [ProgressHUD dismiss];
//        NSLog(@"%@",responseObject);
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                NSArray *results = [responseObject objectForKey:@"data"];
                id data = [results firstObject];//返回是只有一条数据的数组
                if(completedBlcok){
                    completedBlcok(data,nil);
                    return;
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
    }];
    
    
}

#pragma mark 收藏提醒
+ (void)saveRemindWithId:(NSInteger)mId
                 shareId:(NSInteger)sId
          completedBlock:(CompletedBlock)completedBlcok{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@insertSaveInfo",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    if(!xiaomiID||[xiaomiID isEqual:[NSNull null]]){
        NSLog(@"参数错误");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:xiaomiID forKey:@"uid"];
    if (mId == 0) {
        
        [params setObject:@(sId) forKey:@"sid"];
//        [params setObject:@"" forKey:@"mid"];
        
    }else if (sId == 0){
     
        [params setObject:@(mId) forKey:@"mid"];
//        [params setObject:@"" forKey:@"sid"];

    }
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
                [SVProgressHUD dismissWithDelay:0.5];

                if(completedBlcok){
                    completedBlcok(nil,nil);
                    return;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络异常，收藏失败"];
                [SVProgressHUD dismissWithDelay:0.5];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，收藏失败"];
        [SVProgressHUD dismissWithDelay:0.5];
    }];
}

#pragma mark 收藏（本地转换成远程）
+ (void)actionForCollectionForLocal:(RemindModel *)model completedBlock:(finishWithUid)finish
{
 
    NSString *urlStr = [NSString stringWithFormat:@"%@createRemind",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    

    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    

    [dic setObject:uid forKey:@"sendUid"];
    [dic setObject:model.title forKey:@"title"];
    [dic setObject:model.content forKey:@"message"];
    [dic setObject:@(model.musicName) forKey:@"ringId"];
    [dic setObject:@(model.year) forKey:@"year"];
    [dic setObject:@(model.month) forKey:@"month"];
    [dic setObject:@(model.day) forKey:@"day"];
    [dic setObject:@(model.hour) forKey:@"hour"];
    [dic setObject:@(model.minute) forKey:@"min"];
    [dic setObject:@(model.randomType) forKey:@"randomType"];
    [dic setObject:@(model.countNumber) forKey:@"countNumber"];
    [dic setObject:model.audioDurationStr forKey:@"audioDurationStr"];
    [dic setObject:@(model.offsetMinute) forKey:@"offsetMinute"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    [dic setObject:userName forKey:@"sendUname"];
    
    if (model.weekStr != nil) {
        
        [dic setObject:model.weekStr forKey:@"weekStr"];
        
    }
    
    if (model.localInfo != nil) {
        
        [dic setObject:model.localInfo forKey:@"localInfo"];
        
    }else{
        model.localInfo = @"";
    }
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *imageArr = model.files;
        
        if (imageArr.count == 0) {
            
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"files" fileName:@"" mimeType:@""];
            
        }else {
            
            for (int i = 0; i < imageArr.count; i ++) {
                
                UIImage *imageNow = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageNow, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                
            }
            
            
        }
        //语音
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if([model.audioPathStr length]>0){
            NSArray *audioPathArr = [model.audioPathStr componentsSeparatedByString:@","];
            if([audioPathArr count]>0){
                for (int i = 0; i < [audioPathArr count]; i ++) {
                    NSString *fullPath = [path stringByAppendingPathComponent:audioPathArr[i]];
                    NSData *audioData = [NSData dataWithContentsOfFile:fullPath];
                    NSString *fileName = [fullPath lastPathComponent];
                    if(audioData){
                        [formData appendPartWithFileData:audioData name:@"audios" fileName:fileName mimeType:@"audio/caf"];
                    }
                }
            }
        }else{
            NSData *data = [NSData data];
            [formData appendPartWithFileData:data name:@"audios" fileName:@"" mimeType:@""];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"fail"]) {
            
            [ProgressHUD dismiss];
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您当前无网络，请检查后在发送" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alter show];
            
            
            //#warning 没有网络或发送失败的情况下调用本地数据库，有fid,gid
            LocalListManager *locManager = [LocalListManager shareLocalListManager];
            
            DataArray *dataArr = [DataArray shareDateArray];
            
            RemindModel *model = dataArr.modelForSend;
            
            model.isTop = @"0";
            model.isOther = 0;
            
            int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            
            [locManager deleteDataWithUid:model.oid];
            
            //[locManager insertDataWithremindModel:model usersID:xiaomiID];
            
            dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
            
            return;
        }
        
        [ProgressHUD dismiss];
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        [locManager deleteDataWithUid:model.oid];
        [locManager deleteLocalAudioFileWithPathStr:model.audioPathStr];
        
        model.uid = [[responseObject objectForKey:@"mid"] intValue];
        model.isOther = 0;
        model.isTop = @"0";
        model.isShare = 0;
        model.headUrlStr = [responseObject objectForKey:@"picStr"];
        model.audioPathStr = [responseObject objectForKey:@"audioStr"];
        model.audioDurationStr = [responseObject objectForKey:@"audioDurationStr"];

        NSString *uidstr = [NSString stringWithFormat:@"%d",model.uid];
        
        IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
        [incManager insertDataWithremindModel:model];
    
        if (finish) {
            
            finish(uidstr);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD dismiss];
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您当前无网络，请检查后在发送" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alter show];
        
        
        
        LocalListManager *locManager = [LocalListManager shareLocalListManager];
        
        DataArray *dataArr = [DataArray shareDateArray];
        
        RemindModel *model = dataArr.modelForSend;
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        
        model.isTop = @"0";
        model.isOther = 0;
        
        [locManager deleteDataWithUid:model.oid];
        
        //[locManager insertDataWithremindModel:model usersID:xiaomiID];
        
        dataArr.arrForAllData = [locManager searchAllDataWithText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];

        
        return;
        
    }];
    

    
}
//添加好友
+ (void)actionForAddNewFriend:(NSString *)fid
{
    //显示菊花
    [ProgressHUD show:@"添加好友中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@addFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:fid forKey:@"fid"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        //移除菊花
        [ProgressHUD dismiss];
        if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                BOOL isfriend = [[responseObject objectForKey:@"isfriend"] boolValue];
                if(!isfriend){
                    //发送好友申请的推送
                    [RequestManager actionForNewPushFriend:fid type:@"2"];
                    //刷新数据
                    [RequestManager actionForReloadData];
                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show ];
                    
                    NSNotification *notice = [[NSNotification alloc]initWithName:kNotificationForAddNewFriend object:nil userInfo:@{@"fid":fid}];
                    [[NSNotificationCenter defaultCenter] postNotification:notice];
                    
                }else{
                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"您已申请添加过该好友！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show ];
                    
                }
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        //移除菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友失败，请检查网路！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];

}
+ (void)actionForAcceptNewFriend:(NSString *)fid
{
    [ProgressHUD show:@"添加中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@confirmFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [dic setObject:[defaults objectForKey:kUserXiaomiID] forKey:@"fid"];
    [dic setObject:@(1) forKey:@"type"];
    [dic setObject:fid forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        if ([responseObject[@"isAccept"] intValue] == 1) {
            //点击接收了好友
            [RequestManager actionForNewPushFriend:fid type:@"3"];
            [RequestManager actionForSelectFriendIsNewFriend:YES];
            [RequestManager actionForSelectLoginFriendIsNew:YES];
            
            NSNotification *notice = [[NSNotification alloc]initWithName:kNotificationForAddNewFriend object:nil userInfo:@{@"fid":fid}];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
        }else {
            [RequestManager actionForSelectLoginFriendIsNew:YES];
        }
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {

        [ProgressHUD dismiss];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友失败，请检查网路！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];

    }];
}

#pragma mark 修改备注
+ (void)actionForSetRemark:(NSString *)remark forFriend:(NSString *)fid completedBlock:(CompletedBlock)block
{
    if(!remark||!fid){
        NSLog(@"remark/fid 不能为空");
        return;
    }
    [ProgressHUD show:@"修改中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@addFriRemark",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:remark forKey:@"friendName"];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:fid forKey:@"friendId"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            //点击接收了好友
            if(block){
                block(nil,nil);
            }
        }
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        
        [ProgressHUD dismiss];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"网络请求失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }];
}

#pragma mark 同账号换设备登陆剔除之前的
+ (void)kickOffLoginPeople:(NSString *)tToken{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@push",kXiaomiUrl];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:tToken forKey:@"token"];
        [dic setObject:@"6" forKey:@"type"];
    
        [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"flag"] isEqualToString:@"succ"]){
                NSLog(@"踢人推送成功！");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

}

+ (void)checkIfShuldLogout
{
    NSString *urlStr = [NSString stringWithFormat:@"%@queryIsBeT",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(!uid||!token){
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:@"token"];
    [dic setObject:uid forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            NSInteger ret = [responseObject[@"isBeT"] integerValue];
            NSString *alert = responseObject[@"alert"];
            if(ret==0){
                if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsLogin] boolValue]){
                    UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:alert message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alterV show];
                    [kAppDelegate logoutIfRequestServer:NO];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark - 密码相关
#pragma mark 设置密码
+ (void)setPassWordWithStr:(NSString *)passWordStr
                  complish:(accomplishBlock)accomplish

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic = @{@"password":passWordStr,@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@insertMyPassword",kXiaomiUrl];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,[[responseObject objectForKey:@"typeId"]intValue]);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
    
}

+ (void)changePassWordWithStr:(NSString *)passWordStr
                     complish:(accomplishBlock)accomplish
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic = @{@"password":passWordStr,@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@editMyPassword",kXiaomiUrl];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,[[responseObject objectForKey:@"typeId"]intValue]);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
}


#pragma mark 密码类型

+ (void)addNewPassWordTypeWithModel:(PassWordTitleModel *)model
                           complish:(accomplishBlock)accomplish
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.title forKey:@"typename"];
    [dic setObject:model.top forKey:@"typeIstop"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID] forKey:@"uid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@insertPasswordType",kXiaomiUrl];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,[[responseObject objectForKey:@"typeId"]intValue]);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
    
}

+ (void)upDatePassWordTitleWithModel:(PassWordTitleModel *)model
                            complish:(accomplishBlock)accomplish
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(model.mid) forKey:@"typeid"];
    [dic setObject:model.title forKey:@"typename"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID] forKey:@"uid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@editPasswordType",kXiaomiUrl];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,0);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        accomplish(NO,0);
    }];
    
    
    
}

+ (void)topPassWordTitleTypeWithMidStr:(NSString *)midStr
                                topStr:(NSString *)topStr
                              complish:(accomplishBlock)accomplish
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:midStr forKey:@"typeid"];
    [dic setObject:topStr forKey:@"typeIstop"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID] forKey:@"uid"];
    NSString *urlStr =  [NSString stringWithFormat:@"%@toTopPasswordType",kXiaomiUrl];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,0);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
    
}


+ (void)deletePassWordTitleTypeWithMidStr:(NSString *)midStr
                                 complish:(accomplishBlock)accomplish

{
    NSString *urlStr = [NSString stringWithFormat:@"%@delPasswordType",kXiaomiUrl];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:midStr forKey:@"typeid"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,0);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
}





#pragma mark 密码详情页
+ (void)addNewPassWordDetailWithModel:(PassWordModel *)model
                               typeId:(int )type_id
                             complish:(accomplishBlock)accomplish

{
    NSString *urlStr = [NSString stringWithFormat:@"%@insertPasswordData",kXiaomiUrl];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    //title=()&username=()&password=()&descript=()&typeId=()
    
    NSDictionary *dic = @{@"title":model.title,@"username":model.userName,@"password":model.passWord,@"descript":model.detail,@"typeId":@(type_id)};
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,[[responseObject objectForKey:@"dataId"]intValue]);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
}


+ (void)editNewPassWordDetailWithModel:(PassWordModel *)model
                              complish:(accomplishBlock)accomplish
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //dataId=()& title=()&username=()&password=()&descript=()
    NSDictionary *dic = @{@"dataId":@(model.mid),@"title":model.title,@"username":model.userName,@"password":model.passWord,@"descript":model.detail};
    NSString *urlStr = [NSString stringWithFormat:@"%@editPasswordData",kXiaomiUrl];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,0);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
    
}


+ (void)deleteNewPassWordDetailWithModel:(PassWordModel *)model
                                complish:(accomplishBlock)accomplish
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"dataId":@(model.mid)};
    NSString *urlStr = [NSString stringWithFormat:@"%@delPasswordData",kXiaomiUrl];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            accomplish(YES,0);
            
        }else{
            
            accomplish(NO,10);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accomplish(NO,0);
    }];
    
    
}


#pragma mark 查询密码
+ (void)loadAllPassWordWithResult:(returnResultBlock)resultBlock
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@loadOther",kXiaomiUrl];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            
            if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                
                PassWordTitleList *list = [PassWordTitleList sharePassWordTitleList];
                PassWordList      *detailList = [PassWordList sharePassList];
                [list deleteAll];
                [detailList deleteAllModel];
                
                NSString *passWord = @"";
                if (![[responseObject objectForKey:@"password"] isKindOfClass:[NSNull class]]) {
                    
                    passWord = [responseObject objectForKey:@"password"];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"passWord"];
                
                NSArray *passWordList = [responseObject objectForKey:@"passwordList"];
                for (int i = 0; i < passWordList.count; i ++) {
                    
                    NSDictionary *passWordType = passWordList[i];
                    PassWordTitleModel *titleModel = [[PassWordTitleModel alloc] init];
                    titleModel.mid = [[passWordType objectForKey:@"typeid"] intValue];
                    titleModel.title = [passWordType objectForKey:@"typename"];
                    NSString *isTop = [passWordType objectForKey:@"typeIstop"];
                    if ([isTop isKindOfClass:[NSNull class]]) {
                        
                        isTop = @"0";
                    }
                    titleModel.top = isTop;
                    [list insertDataWithModel:titleModel];
                    
                    
                    //密码详情
                    NSArray *passWordDetail = [passWordType objectForKey:@"passwordData"];
                    for (int j = 0; j < passWordDetail.count; j++) {
                        
                        NSDictionary *detailDic = passWordDetail[j];
                        PassWordModel *detailModel = [[PassWordModel alloc] init];
                        NSString *time = [detailDic[@"createtime"]substringWithRange:NSMakeRange(0, 16)];
                        NSString *year = [time substringWithRange:NSMakeRange(0, 4)];
                        NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
                        NSString *day   = [time substringWithRange:NSMakeRange(8, 2)];
                        NSString *hour  = [time substringWithRange:NSMakeRange(11, 2)];
                        NSString *minute = [time substringWithRange:NSMakeRange(14, 2)];
                        
                        detailModel.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
                        detailModel.title      = detailDic[@"title"];
                        detailModel.passWord   = detailDic[@"password"];
                        detailModel.userName   = detailDic[@"username"];
                        detailModel.detail     = detailDic[@"descript"];
                        detailModel.mid        = [detailDic[@"dataId"]intValue];
                        detailModel.type_id    = [[passWordType objectForKey:@"typeid"] intValue];
                        [detailList insertDataWithModel:detailModel completionBlock:^(BOOL succ) {
                            
                            if (succ) {
                                
                                NSLog(@"插入成功");
                            }
                            
                        }];
                        
                    }
                    
                    
                }
                
                
            }else{
                
                
            }
        }
        resultBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        resultBlock(nil);
    }];
    
}

#pragma mark - 扫描模块

+ (void)queryAllDoucments:(CompletedBlock)block
{
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@loadOther?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            NSArray *docs = responseObject[@"saoList"];
            NSMutableArray *arr = [NSMutableArray array];
            if([docs isKindOfClass:[NSArray class]]){
                NSArray *result = (NSArray *)docs;
                for(int i=0;i<[result count];i++){
                    ScanDirectory *dic = [[ScanDirectory alloc]initWithDictionary:docs[i]];
                    [arr addObject:dic];
                }
                //获取数据成功重置本地表数据
                [[ScanUtil sharedInstance] resetAllData:arr];
            }
            if(block){
                block(docs,nil);
            }
        }else{
            if(block){
                block(nil,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if(block){
            block(nil,error);
        }
    }];
}

+ (void)uploadNewFile:(ScanUploadModel *)model complete:(CompletedBlock)block
{
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@insertSaoFile?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:@(model.fileType) forKey:@"ftype"];
    
    if(model.name){
        [dic setObject:model.name forKey:@"name"];
    }
    
    NSString *did = model.dirId>0?[NSString stringWithFormat:@"%ld",model.dirId]:@"";
    [dic setObject:did forKey:@"did"];
    
    if(model.fileType==1){
        [dic setObject:model.textContent forKey:@"wordContent"];
    }else{
        [dic setObject:model.fileSize forKey:@"fsize"];
    }
    
    [ProgressHUD show:@"保存中..."];
    
    AFURLConnectionOperation *operation = [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if(model.fileType==1){
            [formData appendPartWithFileData:[NSData new] name:@"files" fileName:@"empdata" mimeType:@"image/jpeg"];
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            int i=0;
            for(NSData *data in model.photoDataArray){
                i++;
                NSLog(@"data length: %ld",[data length]);
                NSString *fileName = [NSString stringWithFormat:@"%@%@%d.jpg", xiaoMiId,str,i];
                [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpeg"];
            }

        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            if(block){
                block(nil,nil);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromServer object:responseObject[@"documentId"]];
               
            });
        }else{
            if(block){
                block(nil,nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if(block){
            block(nil,error);
        }

    }];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        NSLog(@"======ExecuteAsBackgroundTaskWithExpirationHandle");
    }];
}
+ (void)updateFile:(ScanFile *)file complete:(CompletedBlock)block
{
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@editSaoFile?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:@(file.type) forKey:@"ftype"];
    [dic setObject:file.name forKey:@"name"];
    [dic setObject:@(file.fileId) forKey:@"fid"];
    [dic setObject:@(file.dirId) forKey:@"did"];
    
    
    if(file.type == 1){
        [dic setObject:file.textContent forKey:@"wordContent"];
    }else{
        [dic setObject:file.fileSize forKey:@"fsize"];
    }
    [ProgressHUD show:@"保存中..."];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [ProgressHUD dismiss];

        if(file.type==1){
            [formData appendPartWithFileData:[NSData new] name:@"file" fileName:@"empdata" mimeType:@"image/jpeg"];
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSData *data = file.imageData;
            NSString *fileName = [NSString stringWithFormat:@"%@%@1.jpg", xiaoMiId,str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];

        if(block){
            block(nil,nil);
        }
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(file.type==1){//需要再跳进就传responseObject[@"documentId"]
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromServer object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromServer object:responseObject[@"documentId"]];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(nil,error);
        }
    }];
}

+ (void)createNewDirectory:(NSString *)dirName complete:(CompletedBlock)block
{
    if(!dirName){
        return;
    }
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@insertSaoDocument?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:dirName forKey:@"name"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(block){
            block(nil,nil);
        }

        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(block){
            block(nil,error);
        }
    }];
}
+ (void)updateDirectoryWithDirId:(NSInteger)did name:(NSString *)newName complete:(CompletedBlock)block
{
    if(!did || !newName){
        return;
    }
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@editSaoDocument?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:@(did) forKey:@"did"];
    [dic setObject:newName forKey:@"name"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(block){
            block(nil,nil);
        }
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            [[ScanUtil sharedInstance] updateDirWithId:did name:newName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromDataBase object:nil];
            });
          
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(block){
            block(nil,error);
        }
    }];
}
+ (void)deleteDirectoriesWithDirIdStr:(NSString *)didStr complete:(CompletedBlock)block
{
    if(!didStr){
        return;
    }
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@delSaoDocument?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:didStr forKey:@"did"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(block){
            block(nil,nil);
        }
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            [[ScanUtil sharedInstance] deleteDirectoriesWithDidStr:didStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromDataBase object:nil];
            });
           
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(block){
            block(nil,error);
        }
    }];
}
+ (void)deleteFilesWithFileIdStr:(NSString *)fidStr complete:(CompletedBlock)block
{
    if(!fidStr){
        return;
    }
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@delSaoFile?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    [dic setObject:fidStr forKey:@"fid"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            [[ScanUtil sharedInstance] deleteFilesWithFidStr:fidStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadScanFilesFromDataBase object:nil];
            });
            if(block){
                block(nil,nil);
            }
        }else{
            if(block){
                block(nil,nil);
            }
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(block){
            block(nil,error);
        }
    }];
}

+ (void)queryOcr:(UIImage *)image complete:(CompletedBlock)block
{
    if(!image){
        return;
    }
    
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@queryOcr?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    [manager POST:urlStr parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSString *fileName = [NSString stringWithFormat:@"%@%@1.jpg", xiaoMiId,str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];

        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            NSString *txt = responseObject[@"word"];
            if(block){
                block(txt,nil);
            }
        }else{
             if(block){
                 block(nil,nil);
             }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(block){
            block(nil,error);
        }
    }];
}



#pragma mark - 解除绑定
+ (void)unbindWithStr:(NSString *)type_str complish:(accomplishBlock)block
{
 
    NSString *urlStr = [NSString stringWithFormat:@"%@unbinding",kXiaomiUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{type_str:@"1",@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            
            block(YES,1);
            NSLog(@"解绑成功");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"解绑失败");
    }];
    
}


#pragma mark - 查询天气
+ (void)queryWeatherDataWithCity:(JYCity *)city completed:(CompletedBlock)block
{
    NSString *urlStr;
    if(city.cityType==JYCityTypeInland&&city.countyId.length>2){
        urlStr = [[NSString alloc]initWithFormat: @"%@?citykey=%@", kWeatherUrl,[city.countyId substringFromIndex:2]];
    }else{
        urlStr = [[NSString alloc]initWithFormat: @"%@?city=%@", kWeatherUrl,city.cityNameEN];
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    [request setHTTPMethod: @"GET"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   if(block){
                                       block(nil,error);
                                   }
                               } else {
                                   //                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //                                   NSLog(@"HttpResponseBody %@",responseString);
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if(block){
                                       block(dic,nil);
                                   }
                                   
                               }
                           }];
    
}
/*
 + (void)queryWeatherWithCity:(JYCity *)city completed:(CompletedBlock)block
{
    NSString *urlStr;
    if(city.cityType==JYCityTypeInland){
        urlStr = [[NSString alloc]initWithFormat: @"%@?cityid=%@", kWeatherUrl,city.countyId];
    }else{
        urlStr = [[NSString alloc]initWithFormat: @"%@?city=%@", kWeatherUrl,city.cityNameEN];
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    [request setHTTPMethod: @"GET"];
    [request addValue:kWeatherKey forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   if(block){
                                       block(nil,error);
                                   }
                                   
                               } else {
//                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"HttpResponseBody %@",responseString);
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSDictionary *data = [[dic objectForKey:@"HeWeather data service 3.0"] lastObject];
                                   if(!data || data.count==1){//未获取到正常无数据,用城市中文名再请求一次
                                       [self queryWeatherWithCityNameCN:city.city completed:block];
                                   }else{
                                       if(block){
                                           block(dic,nil);
                                       }
                                   }

                               }
                           }];
    
    
}
//用中文城市名请求数据
+ (void)queryWeatherWithCityNameCN:(NSString *)cityNameCN completed:(CompletedBlock)block
{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?city=%@", kWeatherUrl,cityNameCN];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    [request setHTTPMethod: @"GET"];
    [request addValue:kWeatherKey forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   if(block){
                                       block(nil,error);
                                   }
                                   
                               } else {
                                  
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if(block){
                                       block(dic,nil);
                                   }
                               }
                           }];
    
    
}
 */
#pragma mark - 择吉
+ (void)queryGoodBadDaysWith:(NSString *)yjName from:(NSDate *)startDate to:(NSDate *)endDate  completed:(CompletedBlock)block
{

    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *startStr = [dateFormater stringFromDate:startDate];
    NSString *endStr = [dateFormater stringFromDate:endDate];

    if(!yjName||!startStr||!endStr){
        return;
    }
    
    if([yjName rangeOfString:@"动土"].location!=NSNotFound){
        yjName = [yjName stringByReplacingOccurrencesOfString:@"动土" withString:@"動土"];
    }
   
    
    [ProgressHUD show:@"查询中..."];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@queryYijiRange", kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSDictionary *param = @{@"starttime":startStr,@"endtime":endStr,@"yjname":yjName};
    
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            if(block){
                block(responseObject,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if(block){
            block(nil,error);
        }
    }];
    
    
}

//账号合并
+ (void)mergeDataFromOldId:(NSInteger)oldId complete:(CompletedBlock)block
{
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID];
    
    if(!xiaomiID){
        return;
    }
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@/callMergeAccount", kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSDictionary *param = @{@"in_uid":xiaomiID,@"in_oldid":@(oldId)};
    [ProgressHUD show:@"合并中..."];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            if(block){
                block(responseObject,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if(block){
            block(nil,error);
        }
    }];
    
    
}

#pragma mark - 同步记事
+ (void)uploadNotes:(NSArray *)notes complete:(CompletedBlock)block
{
    NSString *xiaomiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@createNote?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *muArr= [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    for(int i=0;i<[notes count];i++){
        JYNote *note = notes[i];
        NSString *imgPath = note.imagePathLocal;
        NSArray *paths = [imgPath componentsSeparatedByString:@","];
        int count = 0;
        for(NSString *p in paths){
            if(p.length>0){
                count++;
            }
        }
        NSMutableDictionary *subDic = [NSMutableDictionary new];
        [subDic setObject:@(count) forKey:@"imageCount"];
        if([note.tId isEqualToString:@""]){//作为新的上传,置空imagePath
            [subDic setObject:@"" forKey:@"imagePath"];
        }else{
            [subDic setObject:note.imagePathRemote?note.imagePathRemote:@"" forKey:@"imagePath"];
        }
        [subDic setObject:xiaomiId forKey:@"uid"];
        [subDic setObject:note.title?note.title:@"" forKey:@"title"];
        [subDic setObject:note.content?note.content:@"" forKey:@"content"];
        [subDic setObject:[formatter stringFromDate:note.createTime] forKey:@"createTime"];
        [subDic setObject:[formatter stringFromDate:note.updateTime] forKey:@"updateTime"];
        [subDic setObject:note.tId?note.tId:@"" forKey:@"tid"];
        [muArr addObject:subDic];
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muArr options:NSJSONWritingPrettyPrinted error:&error];
    [params setObject:jsonData forKey:@"noteList"];
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    AFURLConnectionOperation *operation = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* cacheDirectory  = [paths objectAtIndex:0];
        NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
        BOOL flag = NO;
        int n = 0;
        for(int i=0; i<[notes count]; i++){
            JYNote *note = notes[i];
            if(note.imagePathLocal.length>0){
                NSArray *imgPaths = [note.imagePathLocal componentsSeparatedByString:@","];
                for(int i=0;i<[imgPaths count];i++){
                    NSString *imgPath = imgPaths[i];
                    n++;
                    if(imgPath.length>0){
                        imgPath = [cacheDirectory stringByAppendingPathComponent:imgPath];
                        NSData *data = [NSData dataWithContentsOfFile:imgPath];
                        NSString *fileName = [NSString stringWithFormat:@"%@%f%d.jpg", xiaomiId,time,n];
//                        NSLog(@"append an image=====%@",fileName);
                        flag = YES;
                        [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                    }
                }
            }if(note.imagePathRemote.length>0&&[note.tId isEqualToString:@""]&&!note.syncTime){
                NSArray *imgPaths = [note.imagePathLocal componentsSeparatedByString:@","];
                NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
                for(int i=0;i<[imgPaths count];i++){
                    NSString *imgPath = imgPaths[i];
                    if(imgPath.length>0){

                        UIImage *img = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imgPath];
                        NSData *data = UIImageJPEGRepresentation(img, 0.8);
                        if(data){
                            NSString *fileName = [NSString stringWithFormat:@"%@%f%d.jpg", xiaomiId,time,i];
//                            NSLog(@"append an image=====%@",fileName);
                            flag = YES;
                            [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                        }
                    }
                }
            }
        }
        if(!flag){
            [formData appendPartWithFileData:[NSData new] name:@"files" fileName:@"emptyData" mimeType:@"image/jpeg"];
        }

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            [SVProgressHUD dismiss];
            if(block){
                block(responseObject,nil);
            }
//            [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败!"];
         NSLog(@"%@",[error localizedDescription]);
    }];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        NSLog(@"======ExecuteAsBackgroundTaskWithExpirationHandle");
    }];
}

+ (void)deleteNotesWithTidStr:(NSString *)tidStr complete:(CompletedBlock)block
{
    if(!tidStr){
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@deleteNote?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:tidStr forKey:@"tids"];
    [SVProgressHUD showWithStatus:@"正在删除!"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
            if(block){
                block(nil,nil);
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"删除失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"删除失败！"];
    }];
}
+ (void)queryAllNotesCompleted:(CompletedBlock)block
{
    NSString *xiaoMiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@queryNote?",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 10.f;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:xiaoMiId forKey:@"uid"];
    
    [SVProgressHUD showWithStatus:@"同步中..."];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"succ"]){
            NSArray *data = responseObject[@"data"];
            if(block){
                block(data,nil);
            }
        }else{
            if(block){
                block(nil,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if(block){
            block(nil,error);
        }
    }];
}

@end
