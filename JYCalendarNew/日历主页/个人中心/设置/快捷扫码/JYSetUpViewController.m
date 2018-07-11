//
//  JYSetUpViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYSetUpViewController.h"
#import "JYMainViewController.h"
#import "JYSetView.h"

#import "JYAboutSecret.h"
#import "AboutUsView.h"
#import "NowLoginViewController.h"
#import "CamerManager.h"

#define SCANVIEW_EdgeTop kScreenHeight/5
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.7     //浅色透明度
#define DARKCOLOR_ALPHA 0.5     //深色透明度

#define heightForBtn 84 / 1334.0 * kScreenHeight
#define xForBtn      20 / 750.0 * kScreenWidth
#define yForBtn      1160 / 1334.0 * kScreenHeight

#define kAlertTagForExit 200
@interface JYSetUpViewController () {
   
    JYSetView *_jySetView;
    UIView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;

}
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation JYSetUpViewController


//返回上个页面
- (void)actionForLeft:(UIButton *)sender
{

    [self.readerView stop];
    
    [self.readerView removeFromSuperview];
    
    [_timer invalidate];

    //是否消失二维码还是返回上个页面
    if (_isBack) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        self.navigationItem.rightBarButtonItem = nil;
      
        _isBack = YES;
    }
    
}

/**
 *  生命周期
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _isBack = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    //创建tableView
    [self createTabelView];
    
    //创建注销
    //[self createZhuxiaoBtn];
}

- (void)createZhuxiaoBtn
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(actionForZhuxiao:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE_4_SCREEN) {
        
        btn.frame = CGRectMake(xForBtn, yForBtn - 64, kScreenWidth - 2 * xForBtn, 40);
        
    }else if(IS_IPHONE_6_SCREEN){
        
         btn.frame = CGRectMake(xForBtn, yForBtn - 64, kScreenWidth - 2 * xForBtn, heightForBtn + 3);
       
    }else{
     
         btn.frame = CGRectMake(xForBtn, yForBtn - 64, kScreenWidth - 2 * xForBtn, heightForBtn + 5);
    }
    
    
    [btn setImage:[UIImage imageNamed:@"退出账号"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
}

//注销方法
- (void)actionForZhuxiao:(UIButton *)sender
{
    
    //监测注销方法
    [RequestManager actionForHttp:@"quit_xiaomi"];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确认退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = kAlertTagForExit;
    [alertView show];
    
}
/**
 *  创建tableView
 */
- (void)createTabelView {
   
    _jySetView = [[JYSetView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66) style:UITableViewStylePlain];
    [self.view addSubview:_jySetView];

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    
    [_jySetView setTableFooterView:bgView];
    
    __block JYSetUpViewController *setVC = self;
    [_jySetView setPushAction:^void(NSInteger row){
    
        if (row == 2) {
            
            //监测关于我们页面
            [RequestManager actionForHttp:@"xiaomi_about_us"];
            
            AboutUsView *vc = [[AboutUsView alloc] init];
            vc.title = @"关于小秘";
            vc.view.backgroundColor = [UIColor whiteColor];
            [setVC.navigationController pushViewController:vc animated:YES];
        
        }
        
        if (row == 1) {
            
            [[CamerManager shareInstance] showCameraWithBlock:^{
                //右上导航添加相册按钮
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
                [btn setTitle:@"相册" forState:UIControlStateNormal];
                [btn addTarget:setVC action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
                setVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
                
                //监测扫一扫点击
                [RequestManager actionForHttp:@"new_friend_sao"];
                
                [setVC setScanView];
                setVC.readerView = [[ZBarReaderView alloc] init];
                setVC.readerView.frame = CGRectMake ( 0 , 0 , setVC.view.frame.size.width, setVC.view.frame.size.height );
                setVC.readerView.tracksSymbols = NO;
                setVC.readerView.readerDelegate = setVC;
                [setVC.readerView addSubview:setVC->_scanView];
                //关闭闪光灯
                setVC.readerView.torchMode = 0;
                [setVC.view addSubview:setVC.readerView];
                //扫描区域
                [setVC.readerView start];
                [setVC createTimer];
                
                _isBack = NO;
            }];
            
        }
        
        if (row == 3) {
            
            //NSLog(@"进入appStore");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id1073540859"]];
        }
        
        if (row == 4) {
  
            //监测意见反馈页面
            [RequestManager actionForHttp:@"xiaomi_feedback"];
            
            JYAboutSecret *vc = [[JYAboutSecret alloc] init];
            vc.title = @"意见反馈";
            vc.view.backgroundColor = [UIColor whiteColor];
            [setVC.navigationController pushViewController:vc animated:YES];
        }
        
        if (row == 5) {
            
            [setVC actionForZhuxiao:nil];
        }
    }];
    
}
- (void)rightBarButtonClicked:(id)sender {
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.readerDelegate = self;
    reader.navigationBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    reader.showsHelpOnFail = NO;
    if([ZBarReaderController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:reader animated:YES completion:nil];
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"打开相册失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }
}
#pragma mark 快捷扫码
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
////    id<NSFastEnumeration> result = [info objectForKey:ZBarReaderControllerResults];
////    
////    ZBarSymbol *symbol;
////    
////    for (symbol in result) {
////        
////        //break;
////        
////       // _myimage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
////        
////        
////        
////        [picker dismissViewControllerAnimated:YES completion:nil];
////        
////        NSString *strForUrl = [NSString stringWithFormat:@"%@",symbol.data];
////        
////        NSURL *url = [NSURL URLWithString:strForUrl];
////        
////        [[UIApplication sharedApplication] openURL:url];
////        
////        //_mylabe.text = symbol.data;
////    }
//    
//    
//}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol* symbol = nil;
    NSString *qrResult;
    NSString *subString;
    for(symbol in results) {
        qrResult = symbol.data ;
        NSLog(@"====%@",qrResult);
        break;
    }
    if(qrResult.length > 6){
        
        subString = [qrResult substringWithRange:NSMakeRange(0, 6)];
        if([subString isEqualToString:@"xiaomi"]){
            NSString *xiaomiID = [qrResult substringWithRange:NSMakeRange(6, qrResult.length - 6)];
            [self addFriends:xiaomiID];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show ];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }
    
    [reader dismissViewControllerAnimated:YES completion:^{}];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"未能从该图片中识别到二维码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
    [alertView show ];
}

/**
 *  内存警告
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark zb代码
-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image {
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols.zbarSymbolSet );
    NSString *symbolStr = [NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    NSString *subString = @"";
    if(symbolStr.length > 6){
        
        subString = [symbolStr substringWithRange:NSMakeRange(0, 6)];
        
        if([subString isEqualToString:@"xiaomi"]){
            
            NSString *xiaomiID = [symbolStr substringWithRange:NSMakeRange(6, symbolStr.length - 6)];
            
            [self addFriends:xiaomiID];
            
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show ];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    //确认退出
    if(alertView.tag==kAlertTagForExit){
        if(buttonIndex==1){
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForLeave object:nil];
            [self.navigationController popViewControllerAnimated:NO];
            [kAppDelegate logoutIfRequestServer:YES];
        }
    }
    
    //扫码alert
    else{
        [self.readerView stop];
        
        [self.readerView removeFromSuperview];
        
        [_timer invalidate];
        self.navigationItem.rightBarButtonItem = nil;

    }

}

//添加好友
- (void)addFriends:(NSString *)fid {
    //显示菊花
    [ProgressHUD show:@"添加好友中…"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@addFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:fid forKey:@"fid"];
    [dic setObject:[_defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        //移除菊花
        [ProgressHUD dismiss];
        
//        //发送好友申请的推送
//        [RequestManager actionForNewPushFriend:fid type:@"2"];
//        
//        
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
//        [alertView show ];
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
            BOOL isfriend = [[responseObject objectForKey:@"isfriend"] boolValue];
            if(!isfriend){
                //发送好友申请的推送
                [RequestManager actionForNewPushFriend:fid type:@"2"];
                //刷新数据
                [RequestManager actionForReloadData];
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show ];
                
            }else{
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"您已申请添加过该好友！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show ];
                
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        //移除菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"申请添加好友失败，请检查网路！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

//二维码的扫描区域
- ( void )setScanView {
    _scanView =[[UIView alloc] initWithFrame : CGRectMake ( 0 , 0 , self.view.frame.size.width, self.view.frame.size.height )];
    _scanView.backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[UIView alloc] initWithFrame : CGRectMake ( 0 , 0 , self.view.frame.size.width , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    scanCropView. layer.borderColor = [UIColor greenColor].CGColor ;
    scanCropView. layer.borderWidth = 2.0 ;
    scanCropView. backgroundColor =[UIColor clearColor];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake ( self.view.frame.size.width - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA;
    rightView. backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , self.view.frame.size.width , self.view.frame.size.height - ( self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop ) )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , self.view.frame.size.width , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline . backgroundColor = [ UIColor greenColor ];
    [ _scanView addSubview : _QrCodeline ];
}
- ( void )openLight {
    if ( _readerView . torchMode == 0 ) {
        _readerView . torchMode = 1 ;
    } else {
        _readerView . torchMode = 0 ;
    }
}
- ( void )viewWillDisappear:( BOOL )animated {
    [super viewWillDisappear :animated];
//    if ( _readerView.torchMode == 1 ) {
//        _readerView.torchMode = 0;
//    }
//    [self stopTimer];
//    [_readerView stop];
}

//二维码的横线移动
- ( void )moveUpAndDownLine {
    CGFloat Y= _QrCodeline.frame.origin.y;
    if (self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}
- ( void )createTimer {
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer {
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
