//
//  RequestManager.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/11.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScanUploadModel.h"
#import "ScanFile.h"
#import "JYNote.h"
#import "JYNoteImage.h"
#import "JYCity.h"

typedef NS_ENUM(int ,passType){
    
    
    qqLogin = 0,
    weiboLogin ,
    weixinLogin,
    telLogin,
    
    
} ;

typedef NS_ENUM(int,state){
    
    notNetWork = 0,
    fwqDown = 10,
    
};

typedef void (^accomplishBlock)(BOOL success,int mid);
typedef void (^returnResultBlock)(id responseObject);

typedef void (^sendFinishBlock)(BOOL sendSuccess);
typedef void (^lodingForTel)(BOOL success);

typedef void (^keyStatusBlock)(BOOL success);

typedef void (^CompletedBlock)(id data, NSError *error);

typedef void (^finishWithUid) (NSString *mid);

@interface RequestManager : NSObject

/**
 *  登录接口（第一次登录调用）
 */
+ (void)actionForUpNameAndHead:(passType)type
                       thirdId:(NSString *)thirdId
                      validate:(NSString *)validate;


/**
 *  加载提醒数据
 */
+ (void)actionForReloadData;


/**
 *  选择好友数据
 */
+ (void)actionForSelectFriendIsNewFriend:(BOOL )isNew;


/**
 *  同步通讯录好友
 */
+ (NSArray *)actionForAddressBookWithArr:(NSArray *)arrForAllModel
                             isNewFriend:(BOOL )isNewFriend;


/**
 *  通过手机号添加好友
 */
+ (void)actionForAddFriendWithTel:(NSString *)tel_phone;


/**
 *  查询待接受的好友申请
 */
+ (void)actionForSelectLoginFriendIsNew:(BOOL )isNew;


/**
 *  接受好友请求方法
 */
+ (void )actionForAcceptRequest:(int )fid type:(int )type;


/**
 *  创建组方法
 */
+ (void)actionForCreateGroupWithName:(NSString *)groupName
                              groupHeader:(UIImage *)groupHeader
                           friendArr:(NSArray *)friendArr;


/**
 *  发送给他人消息
 */
+ (void)actionForSendOtherRemind:(RemindModel *)remindModel
                sendSuccessBlock:(sendFinishBlock)block;


/**
 *  更改提醒
 */
+ (void)actionForUpDataRemind:(RemindModel *)remindModel
             sendSuccessBlock:(sendFinishBlock)block;



/**
 *  查询群组的接口
 */
+ (void)actionForGroup;


/**
 *  接收人删除接口
 */
+ (void)actionForDeleteAccept:(NSString *)mid
             isChangeMainView:(BOOL )isChange;


/**
 *  母体删除接口
 */
+ (void)actionForDeleteMotherIncident:(NSString *)mid
                     isChangeMainView:(BOOL )isChange;


/**
 *  删除好友接口
 */
+ (void)actionForDeleteFriendWithFid:(int )fid;


/**
 *  删除群组接口
 */
+ (void)actionForDeleteGroupId:(int )gid;


/**
 *  编辑群组接口
 */
+ (void)actionForEditGroupModel:(GroupModel *)model
                      friendArr:(NSArray *)friendArr;


/**
 *  注销接口
 */
+ (void)actionForCancelDevicetoken;


/**
 *  设置关键人接口
 */
+ (void)actionForKeyStatus:(FriendModel *)model type:(int )isKeyStatus keyBlock:(keyStatusBlock)block;



/**
 *  上传意见
 */
+ (void)actionForSendFeedWithImageArr:(NSArray *)imageArr
                                 text:(NSString *)text;


/**
 *  修改铃声
 */
+ (void)actionForChangeMusicName:(RemindModel *)model;


/**
 *  上传名字和头像
 */
+ (void)actionForPassNameAndUserHead:(UIImage *)image
                                name:(NSString *)name;


/**
 *  更改查看状态
 */
+ (void)actionForIsHaveLook:(NSString *)midStr;


/**
 *  添加提醒推送接口
 */
+ (void)actionForNewPush:(RemindModel *)model type:(NSString *)type;

/**
 *  添加好友推送接口(扫码)
 */
+ (void)actionForNewPushFriend:(NSString *)fid type:(NSString *)type;

//添加好友推送接口(手机)
+ (void)actionForNewPushWithTelFriend:(NSString *)telStr type:(NSString *)type;

/**
 *  检测点击
 */
+ (void)actionForHttp:(NSString *)strForPage;

/**
 *  登录时间
 */
+ (void)actionForTime:(NSString *)time;


/**
 *  单独上传deviceToken
 */
+ (void)actionForDeviceToken;

/**
 *  获取验证码登录
 */
+ (void)actionForPostTest:(NSString *)number
                   andBtn:(UIButton *)sender;

/**
 *  是否绑定过
 */
+ (void)actionForBind:(NSString *)validate
            andIPhone:(NSString *)telStr
          finishBlock:(lodingForTel)block;


/**
 *  分享接口
 */
+ (void)actionForSendShareRemindWithUidStr:(NSString *)uidStr
                                    rindId:(NSString *)ringId
                                    fidStr:(NSString *)fidStr
                                    gidStr:(NSString *)gidStr
                               andModelArr:(NSArray *)modelArr
                                  comBlock:(CompletedBlock )block;

/**
 *  本地分享接口（先把本地数据同步到后台）
 */
+ (void)actionForShareRemindWithLocalModel:(RemindModel *)remindModel
                                 andUidStr:(NSString *)uidStr
                                    ringID:(NSString *)ringIdStr
                                    fidStr:(NSString *)fidStr
                                    gidStr:(NSString *)gidStr;

/**
 *  分享删除
 */
+ (void)actionForDeleteShareRemindWithUidStr:(NSString *)sendUid
                                andAcceptUid:(NSString *)acceptUid modelArr:(NSArray *)modelArr;

/**
 *  分享更新
 */
+ (void)actionForEditShareList:(RemindModel *)model;


/**
 *  置顶
 *
 *  @param rmidStr 接收提醒ID
 *  @param smidStr 发送提醒ID
 *  @param rsidStr 接收共享ID
 *  @param ssidStr 发送共享ID
 */
+ (void)actionForTopWithRmidStr:(NSString *)rmidStr
                     andSmidStr:(NSString *)smidStr
                     andRsidStr:(NSString *)rsidStr
                     andSsidStr:(NSString *)ssidStr
                          isTop:(NSString *)isTop;



/**
 *  请求相册数据
 *
 *  @param completedBlcok 完成回调
 */
+ (void)requestPhotoDataWithCompletedBlock:(CompletedBlock)completedBlcok;

/**
 *  根据相片id删除相片
 *
 *  @param hId 相片id
 *  @param completedBlcok 完成回调
 */
+ (void)deletePhotoWithIdStr:(NSString *)idStr
           completedBlock:(CompletedBlock)completedBlcok;

/**
 *  请求个人收藏数据
 *  @param completedBlcok 完成回调
 */
+ (void)requestCollectionDataWithCompletedBlock:(CompletedBlock)completedBlcok;

/**
 *  删除一条收藏
 *
 *  @param mId 资源id
 *  @param completedBlcok 完成回调
 */
+ (void)deleteCollectionDataWithId:(NSInteger)sId
                    completedBlock:(CompletedBlock)completedBlcok;
/**
 *  查询收藏详情
 *
 *  @param mId            提醒id
 *  @param completedBlcok 完成回调
 */
+ (void)requestCollectionDetailDataWithId:(NSInteger)mId
                                  isOhter:(BOOL)isOther
                           completedBlock:(CompletedBlock)completedBlcok;

/**
 *  收藏一条提醒
 *
 *  @param mId            提醒id
 *  @param completedBlcok 完成回调
 */
+ (void)saveRemindWithId:(NSInteger)mId
                 shareId:(NSInteger)sId
          completedBlock:(CompletedBlock)completedBlcok;


/**
 *  添加好友成功发送
 *
 *  @param remindModel
 */
+ (void)actionForSendRemindForAddFriend:(RemindModel *)remindModel;


/**
 *  分享推送
 *
 *  @param uidStr <#uidStr description#>
 *  @param gidStr <#gidStr description#>
 *  @param type   <#type description#>
 *  @param number <#number description#>
 */
+ (void)actionForSharePushWithUid:(NSString *)uidStr
                           gidStr:(NSString *)gidStr
                             type:(NSString *)type
                           number:(int )number;


/**
 *  本地收藏先编程运程
 *
 *  @param model
 */
+ (void)actionForCollectionForLocal:(RemindModel *)model completedBlock:(finishWithUid)finish;


/**
 *  添加好友
 *
 *  @param fid
 */
+ (void)actionForAddNewFriend:(NSString *)fid;

/**
 *  接受好友添加
 *
 *  @param fid
 */
+ (void)actionForAcceptNewFriend:(NSString *)fid;

/**
 *  修改备注
 *
 *  @param remark 备注
 *  @param fid    好友id
 */
+ (void)actionForSetRemark:(NSString *)remark forFriend:(NSString *)fid completedBlock:(CompletedBlock)block;

/**
 *  踢人
 *
 *  @param tToken 登陆回传的token
 */
+ (void)kickOffLoginPeople:(NSString *)tToken;

/**
 *  检查是否需要注销（账号在其他设备登陆了)
 *
 */
+ (void)checkIfShuldLogout;

#pragma mark - 密码相关
/*-------------------------------------------------------*/
#pragma mark 查询接口
+ (void)loadAllPassWordWithResult:(returnResultBlock)resultBlock;

#pragma mark 密码详情页
//添加密码详情页
+ (void)addNewPassWordDetailWithModel:(PassWordModel *)model
                               typeId:(int )type_id
                             complish:(accomplishBlock)accomplish;

//编辑密码详情页
+ (void)editNewPassWordDetailWithModel:(PassWordModel *)model
                              complish:(accomplishBlock)accomplish;

//删除密码详情页
+ (void)deleteNewPassWordDetailWithModel:(PassWordModel *)model
                                complish:(accomplishBlock)accomplish;

#pragma mark 设置密码类型
//添加密码类型
+ (void)addNewPassWordTypeWithModel:(PassWordTitleModel *)model
                           complish:(accomplishBlock)accomplish;

//编辑密码类型
+ (void)upDatePassWordTitleWithModel:(PassWordTitleModel *)model
                            complish:(accomplishBlock)accomplish;

//编辑密码置顶
+ (void)topPassWordTitleTypeWithMidStr:(NSString *)midStr
                                topStr:(NSString *)topStr
                              complish:(accomplishBlock)accomplish;


//删除密码类型
+ (void)deletePassWordTitleTypeWithMidStr:(NSString *)midStr
                                 complish:(accomplishBlock)accomplish;



#pragma mark 设置密码
+ (void)setPassWordWithStr:(NSString *)passWordStr
                  complish:(accomplishBlock)accomplish;

//更改密码
+ (void)changePassWordWithStr:(NSString *)passWordStr
                     complish:(accomplishBlock)accomplish;




//查询扫描文件列表
+ (void)queryAllDoucments:(CompletedBlock)block;

//新建文件
+ (void)uploadNewFile:(ScanUploadModel *)model complete:(CompletedBlock)block;

//创建目录
+ (void)createNewDirectory:(NSString *)dirName complete:(CompletedBlock)block;

+ (void)updateFile:(ScanFile *)file complete:(CompletedBlock)block;

//更新目录名
+ (void)updateDirectoryWithDirId:(NSInteger)did name:(NSString *)newName complete:(CompletedBlock)block;

//删除目录
+ (void)deleteDirectoriesWithDirIdStr:(NSString *)didStr complete:(CompletedBlock)block;
//删除文件
+ (void)deleteFilesWithFileIdStr:(NSString *)fidStr complete:(CompletedBlock)block;

//解除绑定
+ (void)unbindWithStr:(NSString *)type_str complish:(accomplishBlock)block;

//ocr识别
+ (void)queryOcr:(UIImage *)image complete:(CompletedBlock)block;

//查询天气
+ (void)queryWeatherDataWithCity:(JYCity *)city completed:(CompletedBlock)block;

/*
+ (void)queryWeatherWithCity:(JYCity *)city completed:(CompletedBlock)block;
//用中文城市名请求天气数据
+ (void)queryWeatherWithCityNameCN:(NSString *)cityNameCN completed:(CompletedBlock)block;
*/
//查询宜忌
+ (void)queryGoodBadDaysWith:(NSString *)yjName from:(NSDate *)startDate to:(NSDate *)endDate  completed:(CompletedBlock)block;

//账号数据合并
+ (void)mergeDataFromOldId:(NSInteger)oldId complete:(CompletedBlock)block;

//上传记事
+ (void)uploadNote:(JYNote *)note complete:(CompletedBlock)block;
+ (void)uploadNotes:(NSArray *)notes complete:(CompletedBlock)block;
+ (void)deleteNotesWithTidStr:(NSString *)tidStr complete:(CompletedBlock)block;
+ (void)queryAllNotesCompleted:(CompletedBlock)block;
@end
