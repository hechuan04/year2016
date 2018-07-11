 //
//  PassWordVC.m
//  PassWord
//
//  Created by 吴冬 on 16/5/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PassWordVC.h"
#import "SecretView.h"

#import "ChangeSecretAlert.h"
#import "EveryEnterAlert.h"
#import "NotBindTelAlert.h"
#import "FirstEnterAlert.h"


#import "PasswordCell.h"
#import "PassWordDetailVC.h"
#import "PassWordDetail.h"
#import "AFNetworking.h"
#import "BackSecretVC.h"
#import "BindPhoneView.h"
#import <objc/runtime.h>

#import "EditPassWordTitleView.h"


static NSString *passWord = @"passWord";
static NSString *cellIdentifier = @"cellIdentifier";
static void *deleteAlertView = "deleteAlertView";

static NSInteger x_ImageTag = 1001;
static NSInteger bg_view    = 1002;

#define titleColor     [UIColor colorWithRed:255 / 255.0 green:104 / 255.0 blue:97 / 255.0  alpha:1]
#define lineColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1]



@interface PassWordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *editBtn;

    PassWordDetail *_detailV;
    CGFloat _widthForText;
    UITextField *_selectTextField;
    
    NSMutableArray *_selectData;
    NSMutableArray *_mutableData;
    
    bool flag[1000];
    
    void (^changeView)(CGFloat keyboardHeight);
    void (^isEqualNumber)();
    
    UITableView *_tableView;
    UIView      *_bgView;
    NSString *userPassWord;
}
@end

@implementation PassWordVC



- (void)dealloc
{
 

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"总密码页移除了");
    
}



- (void)actionForSetLeftBtn
{
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    btnForLeft.tag = 2008;
    self.navigationItem.leftBarButtonItem = item;
    
}


- (void)backAction
{
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 左按钮方法
- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSecret
{
 
    userPassWord = [[NSUserDefaults standardUserDefaults]objectForKey:passWord];
}

- (void)changeList{

    if (_tableView) {
        [_tableView reloadData];
    }
}

- (NSString *)time
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmm"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSecret) name:kNotificationForChangeSecret object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSecret) name:kNotificationForChangeSecretList object:nil];
    
    [self actionForSetLeftBtn];
    _isEdit = NO;
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(0, 0, 40, 20);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.title = @"password";
    _mutableData = [NSMutableArray arrayWithObjects:@"", nil];
    [_mutableData addObjectsFromArray:_dataArr];
    _selectData = [NSMutableArray array];

    PassWordModel *model = [[PassWordModel alloc] init];
    _detailV = [[PassWordDetail alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 435 / 2.0) model:model index:1];
    
    [self.view addSubview:_detailV];
    _detailV.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self _creatTableView];
    [self _createChangeSecretBtn];
    [self _bottomBtn];
    
    //监测键盘弹出、收起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //密码方法
    userPassWord = [[NSUserDefaults standardUserDefaults] objectForKey:passWord];
    NSString *timeStr = [[NSUserDefaults standardUserDefaults]objectForKey:kTimeInterval];
    
    //5分钟验证一次
    if (timeStr == nil || [timeStr isEqualToString:@""]) {
        
        [self performSelector:@selector(_createPassWordView) withObject:nil afterDelay:0.2];
    }else{
       
        NSString *timeStrNow = [self time];
        if ([timeStrNow integerValue] - [timeStr integerValue] > 5) {
             [self performSelector:@selector(_createPassWordView) withObject:nil afterDelay:0.2];
        }
    }
}

//设置密码取消
- (void)cancelAction:(UIButton *)sender
{
   
    for (UIView *subView in _bgView.subviews) {
        if ([subView isKindOfClass:[SecretView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    
    [_bgView removeFromSuperview];
    _bgView = nil;
  
    [editBtn removeFromSuperview];
    editBtn = nil;
    
    [_mutableData removeAllObjects];
    _mutableData = nil;
    
    [_selectData removeAllObjects];
    _selectData = nil;

    changeView = nil;
    isEqualNumber = nil;
    
//    [editBtn removeFromSuperview];
//    editBtn = nil;
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)changeCanacelAction:(UIButton *)sender
{
 
    [_bgView removeFromSuperview];

}

//创建密码弹窗
- (void)_createPassWordView
{
    //第一次进入，有密码
    if (userPassWord == nil || [userPassWord isEqualToString:@""]) {
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.navigationController.view addSubview:bgView];
        
        bgView.tag = bg_view;
        
        _bgView = bgView;
        
        //是否绑定手机
        SecretView *selectView;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kTiUpTel]) {
          
            
            selectView = [self _createSecretViewWithBottom:337.0 andTop:327.0 andBgView:bgView secretView:[FirstEnterAlert new]];

            //改变中间输入框位置
            __weak PassWordVC *vc = self;
            [selectView setCancelBtn:^(BOOL isDis) {
                
                if (isDis) {
                    [vc cancelAction:nil];
                }else{
                    [vc changeCanacelAction:nil];
                }
            }];
            changeView = ^(CGFloat keyboardHeight){
                
                if (keyboardHeight == 0) {
                    
                    [vc changeSecretFrame:selectView top:337.0 bottom:327.0 bgView:bgView];
                    
                }else{
                    
                    [vc changeSecretFrame:selectView top:137.0 bottom:527.0 bgView:bgView];
                    
                }
                
                [selectView layoutIfNeeded];
            };
            
            //点击确认按钮
            [selectView setConfirmBlock:^{
                
                isEqualNumber();
            }];
            //确认是否输入相同
            isEqualNumber = ^(){
                
                if ([selectView.textField1.text isEqualToString:selectView.textField2.text]) {
                    
                    if (selectView.textField1.text.length <= 5) {
                        
                        [vc showAlertWithVC:vc andtext:@"您输入的密码过短，请重新输入"];
                        
                        selectView.textField2.text = @"";
                        selectView.textField3.text = @"";
                        
                    }else{
                        
                        //设置密码回调
                        [RequestManager setPassWordWithStr:[selectView md5:selectView.textField1.text] complish:^(BOOL success, int mid) {
                            
                            if (success) {
                                
                                //设置密码
                                [[NSUserDefaults standardUserDefaults] setObject:[selectView md5:selectView.textField1.text] forKey:passWord];
                                
                                [vc showAlertWithVC:vc andtext:@"设置密码成功！"];
                                
                                [selectView.textField1 resignFirstResponder];
                                [selectView.textField2 resignFirstResponder];
                                
                                
                                
                                [bgView removeFromSuperview];
                                
                            }else{
                                
                                NSLog(@"设置密码失败");
                            }
                            
                        }];
                        
                    }
                    
                }else{
                    
                    [vc showAlertWithVC:vc andtext:@"您俩次输入的密码不同，请重试"];
                    
                    selectView.textField2.text = @"";
                    selectView.textField3.text = @"";
                }
                
            };
            
        }else{
           
            selectView = [self _createSecretViewWithBottom:337.0 andTop:377.0 andBgView:bgView secretView:[NotBindTelAlert new]];
            //[selectView firstEntranceNotBindTel:titleColor];
            
            __weak typeof(self) weekSelf = self;
            [selectView setConfirmBlock:^{
                
                BindPhoneView *bind = [[BindPhoneView alloc] init];
                bind.present = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bind];
                [weekSelf presentViewController:nav animated:YES completion:nil];
                [bind setBind:^{
                    
                    [bgView removeFromSuperview];
                    
                }];
                
            }];
            __weak PassWordVC *vc = self;
            [selectView setCancelBtn:^(BOOL isDis) {
                
                if (isDis) {
                    [vc cancelAction:nil];
                }else{
                    [vc changeCanacelAction:nil];
                }
            }];
        }
        
      
      
        
 
        
        //取消按钮
        UIButton *cancelBtn = [UIButton new];
        [bgView insertSubview:cancelBtn belowSubview:selectView];
        
        [cancelBtn addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bgView.mas_top);
            make.bottom.equalTo(bgView.mas_bottom);
            make.left.equalTo(bgView.mas_left);
            make.right.equalTo(bgView.mas_right);
        }];
 
    }else{
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.navigationController.view addSubview:bgView];
        
        bgView.tag = bg_view;

        _bgView = bgView;
     
        NSLog(@"%@",_bgView);
        //0x170173800
        //0x17816ea00
        SecretView *selectView = [self _createSecretViewWithBottom:428.0 andTop:410.0 andBgView:bgView secretView:[EveryEnterAlert new]];
        //[selectView everyEntrance:titleColor];
        
      
        
        //取消按钮
        UIButton *cancelBtn = [UIButton new];
        [bgView insertSubview:cancelBtn belowSubview:selectView];
        
        [cancelBtn addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bgView.mas_top);
            make.bottom.equalTo(bgView.mas_bottom);
            make.left.equalTo(bgView.mas_left);
            make.right.equalTo(bgView.mas_right);
        }];
        
        __weak PassWordVC *vc = self;
        changeView = ^(CGFloat keyboardHeight){
            
            if (keyboardHeight == 0) {
                
                [vc changeSecretFrame:selectView top:410.0 bottom:428.0 bgView:bgView];
                
            }else{
                
                [vc changeSecretFrame:selectView top:210.0 bottom:628.0 bgView:bgView];
                
            }
            
            [selectView layoutIfNeeded];
        };
        [selectView setCancelBtn:^(BOOL isDis) {
            
            if (isDis) {
                [vc cancelAction:nil];
            }else{
                [vc changeCanacelAction:nil];
            }
        }];
        //点击确认按钮
        [selectView setConfirmBlock:^{
            
            isEqualNumber();
        }];
        
        //点击找回密码按钮
        [selectView setBackSecretBlock:^{
            
            
            BackSecretVC *secretVC = [[BackSecretVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:secretVC];
            [self presentViewController:nav animated:YES completion:nil];
            
        }];
        
        
        //是否相等
        __weak typeof(self) weekSelf = self;
        isEqualNumber = ^(){
    
            NSString *inputStr = [selectView md5:selectView.textField1.text];
            if ([inputStr isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:passWord]]) {
                
                [vc showAlertWithVC:vc andtext:@"登陆成功"];
                
                [selectView.textField1 resignFirstResponder];
            
                [bgView removeFromSuperview];
         
                NSString *timeStr = [weekSelf time];
                [[NSUserDefaults standardUserDefaults] setObject:timeStr forKey:kTimeInterval];
                [GuideView showGuideWithImageName:@"新手引导页8"];
            }else{
  
                [vc showAlertWithVC:vc andtext:@"密码错误,请重新输入"];
                selectView.textField1.text = @"";
       
            }
            
        };
        
        [GuideView showGuideWithImageName:@"新手引导页7"];
    }

}

#pragma mark 密码视图
//********************************密码视图方法*************************************//
//改变密码视图位置
- (void)changeSecretFrame:(SecretView *)secretView
                      top:(CGFloat )top
                   bottom:(CGFloat )bottom
                   bgView:(UIView *)bgView
{
  
    NSLog(@"%@",bgView);
    //0x170173800
    //0x170173800
    
  //  [UIView animateWithDuration:0.25 animations:^{
        [secretView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bgView.mas_top).offset(top/ kIphone6_Height * kScreenHeight);
            make.bottom.equalTo(bgView.mas_bottom).offset(-bottom / kIphone6_Height * kScreenHeight);
        }];
    
   // }];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    editBtn.hidden = [_mutableData count]<=1;
    [self changeSecret];

}
- (void)viewDidAppear:(BOOL)animated
{
 
    [super viewDidAppear:animated];
  
    UIView *bgv = [[_detailV viewWithTag:123] viewWithTag:234];
    _widthForText = bgv.width;
    
    [_detailV removeFromSuperview];
}

//显示视图
- (void)showAlertWithVC:(UIViewController *)vc
                andtext:(NSString *)text
{
 
    if (kSystemVersion > 9.0) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:text message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [vc presentViewController:alert animated:YES completion:^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
   
}

#pragma mark 键盘通知方法
- (void)keyboardShow:(NSNotification *)aNotification
{
    CGRect rect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = rect.size.height;
   // NSLog(@"%@",aNotification.userInfo);
    if (changeView) {
        changeView(height);
    }
}

- (void)keyboardHidden:(NSNotification *)aNotification
{
    if (changeView) {
        changeView(0);
    }
}

#pragma mark 根据类型创建secretView
- (SecretView *)_createSecretViewWithBottom:(CGFloat )bottom andTop:(CGFloat)top andBgView:(UIView *)bgView secretView:(SecretView *)secretView
{
    UIColor *selectColor = titleColor;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navigationController.view.mas_top);
        make.left.equalTo(self.navigationController.view.mas_left);
        make.right.equalTo(self.navigationController.view.mas_right);
        make.bottom.equalTo(self.navigationController.view.mas_bottom);
    }];
    
    SecretView *selectView = secretView;
    selectView.layer.borderWidth = 1;
    selectView.layer.borderColor = selectColor.CGColor;
    selectView.layer.masksToBounds = YES;
    selectView.layer.cornerRadius = 15.0;
    selectView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:selectView];
    
    
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(top / 1334.0 * kScreenHeight);
        make.bottom.equalTo(bgView.mas_bottom).offset(-bottom / 1334.0 * kScreenHeight);
        make.right.equalTo(bgView.mas_right).offset(-125.0 / 750.0 * kScreenWidth);
        make.left.equalTo(bgView.mas_left).offset(125.0 / 750.0 * kScreenWidth);
    }];
    
    [selectView createAlert:titleColor];
    
    return selectView;
    
}

#pragma mark 创建更改密码按钮
- (void)_createChangeSecretBtn
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    


    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(60.0);
        
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = lineColor;
    [bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomView.mas_top);
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(bottomView.mas_left);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(changeSecret:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[JYSkinManager shareSkinManager].keyImage forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.0);
        make.right.equalTo(self.view.mas_right).offset(-15.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(30.0);
        
    }];
    
 
    
}

#pragma mark 更改密码方法
- (void)changeSecret:(UIButton *)sender
{
 
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.navigationController.view addSubview:bgView];
    
    _bgView = bgView;

    
    SecretView *selectView = [self _createSecretViewWithBottom:330.0 andTop:330.0 andBgView:bgView secretView:[ChangeSecretAlert new]];

//    [selectView changeSecret:titleColor];
    
    userPassWord = [[NSUserDefaults standardUserDefaults] objectForKey:passWord];
    
    __block SecretView *selectView1 = selectView;
    __weak PassWordVC *vc = self;
    [selectView setConfirmBlock:^{
   
        
        if ([userPassWord isEqualToString:[selectView1 md5:selectView1.textField1.text]]) {
            
            if ([selectView1.textField2.text isEqualToString:selectView1.textField3.text]) {
                
                if (selectView.textField2.text.length <= 5) {
                    
                    [vc showAlertWithVC:vc andtext:@"您输入的密码过短，请重新输入"];

                    selectView1.textField2.text = @"";
                    selectView1.textField3.text = @"";

                }else{
                    
                    [RequestManager changePassWordWithStr:[selectView1 md5:selectView1.textField2.text] complish:^(BOOL success, int mid) {
                        
                        if (success) {
                            //设置密码
                            [[NSUserDefaults standardUserDefaults] setObject:[selectView1 md5:selectView1.textField2.text] forKey:passWord];
                            
                            [vc showAlertWithVC:vc andtext:@"设置密码成功！"];
                            
                            [selectView1.textField1 resignFirstResponder];
                            [selectView1.textField2 resignFirstResponder];
                            [selectView1.textField3 resignFirstResponder];
                            
                            
                            [bgView removeFromSuperview];
                            
                        }else{
                        
                            NSLog(@"设置密码失败");
                        }
                        
                    }];
                  
                    
                }

                
                
            }else{
             
                [vc showAlertWithVC:vc andtext:@"您俩次输入的密码不同，请重试"];

                selectView1.textField3.text = @"";
            }
            
            
        }else{
         
         
            [vc showAlertWithVC:vc andtext:@"您输入的原始密码有误，请重新输入"];

            selectView1.textField1.text = @"";
            selectView1.textField2.text = @"";
            selectView1.textField3.text = @"";
        }
        
        
    }];
    [selectView setCancelBtn:^(BOOL isDis) {
        
        if (isDis) {
            [vc cancelAction:nil];
        }else{
            [vc changeCanacelAction:nil];
        }
    }];
    
    changeView = ^(CGFloat keyboardHeight){
        
        if (keyboardHeight == 0) {

            [vc changeSecretFrame:selectView top:330.0 bottom:330.0 bgView:bgView];
            
        }else{
        
            [vc changeSecretFrame:selectView top:130.0 bottom:530.0 bgView:bgView];

        }
        
        //[selectView layoutIfNeeded];
    };
    
    //X
    UIImageView *xImage = [UIImageView new];
    xImage.image = [UIImage imageNamed:@"X.png"];
    [bgView addSubview:xImage];
    xImage.tag = x_ImageTag;
    
    [xImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(selectView.mas_centerX);
        make.top.equalTo(selectView.mas_bottom).offset(20.f);
        make.height.mas_equalTo(40.f);
        make.width.mas_equalTo(40.f);
        
    }];

    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    [bgView insertSubview:cancelBtn belowSubview:selectView];
    
    [cancelBtn addTarget:self  action:@selector(changeCanacelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top);
        make.bottom.equalTo(bgView.mas_bottom);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
    }];
    
}

- (void)_changeBtn:(UIButton *)sender
{
    //NSArray *picArr = @[@"all.png",@"delete.png",@"share.png",@"top.png"];
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    
    UILabel *label = nil;
    for (id subView in sender.subviews) {
        
        if ([subView isKindOfClass:[UILabel class]]) {
            
            label = (UILabel *)subView;
            
            break;
        }
    }
    
    if (sender.selected) {
        
        label.textColor = skinManager.colorForDateBg;
        sender.backgroundColor = skinManager.btnBackGroundColor;
        
    }else{
        
        sender.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    }
    
    
    for (id subView in sender.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageV = (UIImageView *)subView;
            
            imageV.image = [UIImage imageNamed:skinManager.arrForListImage[sender.tag - 1000]];
            
            break;
        }
    }
    
}

//*************************************************************************//
#pragma mark 底部按钮
- (void)_bottomBtn
{
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    CGFloat width = kScreenWidth / 3.0;
    
    _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight, width, 60)];
    [_selectAllBtn addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectAllBtn.backgroundColor = [UIColor whiteColor];
    _selectAllBtn.tag = 1000;
    [self.view addSubview:_selectAllBtn];
    
    UIView *top1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    top1.backgroundColor = lineColor;
    [_selectAllBtn addSubview:top1];
    
    UIImageView *allImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    allImage.image = [UIImage imageNamed:skinManager.arrForListImage[_selectAllBtn.tag-1000]];
    [_selectAllBtn addSubview:allImage];
    
    
    UILabel *selectAll = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    selectAll.text = @"全选";
    selectAll.font = [UIFont systemFontOfSize:12];
    selectAll.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    selectAll.textAlignment = NSTextAlignmentCenter;
    [_selectAllBtn addSubview:selectAll];
    
    
    /*
//    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
//    [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    _shareBtn.backgroundColor = [UIColor whiteColor];
//    _shareBtn.tag = 1002;
//    [self.view addSubview:_shareBtn];
//    
//    UIView *top3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
//    top3.backgroundColor = lineColor;
//    [_shareBtn addSubview:top3];
//    
//    UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
//    shareImage.image =  [UIImage imageNamed:@"share.png"];
//    [_shareBtn addSubview:shareImage];
//    
//    
//    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
//    shareLabel.text = @"共享";
//    shareLabel.font = [UIFont systemFontOfSize:12];
//    shareLabel.textAlignment = NSTextAlignmentCenter;
//    shareLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
//    [_shareBtn addSubview:shareLabel];
    */
    
    _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
    [_topBtn addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    _topBtn.backgroundColor = [UIColor whiteColor];
    _topBtn.tag = 1003;
    [self.view addSubview:_topBtn];
    
    UIView *top4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    top4.backgroundColor = lineColor;
    [_topBtn addSubview:top4];
    
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    topImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_topBtn.tag-1000]];
    [_topBtn addSubview:topImage];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    topLabel.text = @"置顶";
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_topBtn addSubview:topLabel];
    
    
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topBtn.right, kScreenHeight, width, 60)];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.tag = 1001;
    [self.view addSubview:_deleteBtn];
    
    UIView *top2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    top2.backgroundColor = lineColor;
    [_deleteBtn addSubview:top2];
    
    UIImageView *deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    deleteImage.image = [UIImage imageNamed:skinManager.arrForListImage[_deleteBtn.tag-1000]];
    [_deleteBtn addSubview:deleteImage];
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    deleteLabel.text = @"删除";
    deleteLabel.font = [UIFont systemFontOfSize:12];
    deleteLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    [_deleteBtn addSubview:deleteLabel];

}

//删除方法
- (void)deleteAction:(UIButton *)sender
{
    _topBtn.selected = NO;
    _selectAllBtn.selected = NO;
    sender.selected = YES;
    [self _changeBtn:sender];
    [self _changeBtn:_topBtn];
    [self _changeBtn:_selectAllBtn];
    
    if (_selectData.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择要删除的条目" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定删除吗？删除将不可恢复" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
    void (^deleteBlcok)(BOOL delete) = ^(BOOL delete){
        if (delete) {
            
            PassWordTitleList *titleList = [PassWordTitleList sharePassWordTitleList];
            PassWordList      *list = [PassWordList sharePassList];
            
            NSMutableString *midStr = [NSMutableString string];
            NSInteger count = _mutableData.count;

            for (PassWordTitleModel *model in _selectData) {
                
                if (![model isEqual:@""]) {
                    
                    [midStr appendFormat:@"%d,",model.mid];
                    
                    [titleList deleteWithModel:model];
                    [_mutableData removeObject:model];
                }
            }
    
            NSString *passMidStr = @"";
            if (midStr.length > 0) {
                
                passMidStr = [midStr substringWithRange:NSMakeRange(0, midStr.length - 1)];
                
            }
            //删除passWordTitle
            [RequestManager deletePassWordTitleTypeWithMidStr:passMidStr complish:^(BOOL success, int mid) {
                
                if (success) {
                    
                    for (PassWordTitleModel *model in _selectData) {
                        
                        if (![model isEqual:@""]) {
                            
                            [titleList deleteWithModel:model];
                            [_mutableData removeObject:model];
                        }
                    }
                    
                    for (int i = 0; i < _selectData.count; i++) {
                        PassWordTitleModel *model = _selectData[i];
                        if (![model isEqual:@""]) {
                            
                            [list deletedataWithType:model.mid completionBlock:^(BOOL isDelete) {
                                
                                if (isDelete) {
                                    NSLog(@"整个列表删除成功");
                                }else{
                                    NSLog(@"删除失败");
                                }
                            }];
                        }
                        
                    }
                    
                    for (int i = 0; i < count; i++) {
                        
                        flag[i] = NO;
                    }
                    
                    NSLog(@"先刷新了");
                    //[self cancelAction];
                    [_selectData removeAllObjects];
                    [_tableView reloadData];
                    //取消编辑
                    editBtn.selected = YES;
                    [self editAction:editBtn];
                    editBtn.hidden = [_mutableData count]<=1;
                }else{
                    
                    
                }
                
            }];

        }else{
        
        }
    };
    
    objc_setAssociatedObject(alert, deleteAlertView, deleteBlcok, OBJC_ASSOCIATION_COPY);

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    void (^block)(BOOL DELETE) = objc_getAssociatedObject(alertView, deleteAlertView);
    
    if (block) {
        
        if (buttonIndex == 0) {
            
            NSLog(@"删除");
            block(YES);
        }else{
         
            block(NO);
        }
    }
    
}

//全选方法
- (void)selectAllAction:(UIButton *)sender
{
    
    
    sender.selected = !sender.selected;
    _topBtn.selected = NO;
    _deleteBtn.selected = NO;
    [self _changeBtn:_topBtn];
    [self _changeBtn:_deleteBtn];
    [self _changeBtn:sender];
    
    if (sender.selected) {
       
        for (int i = 0 ; i < _mutableData.count; i++) {
            
            flag[i] = YES;
        }
        
        [_selectData removeAllObjects];
        [_selectData addObjectsFromArray:_mutableData];
        //第一个为空
        [_selectData removeObjectAtIndex:0];
        [_tableView reloadData];

    }else{
     
        for (int i = 0 ; i < _mutableData.count; i++) {
            
            flag[i] = NO;
        }
        
        [_selectData removeAllObjects];
        [_tableView reloadData];

    }
    
}

//置顶方法
- (void)topAction:(UIButton *)sender
{
    sender.selected = YES;
    _selectAllBtn.selected = NO;
    _deleteBtn.selected = NO;
    [self _changeBtn:sender];
    [self _changeBtn:_selectAllBtn];
    [self _changeBtn:_deleteBtn];
    
    if (_selectData.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择要置顶的条目" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddhhmmss"];
    
    NSInteger topTime =[[dateformatter stringFromDate:senddate] integerValue];

    int i = 0;
    NSMutableString *midStr = [NSMutableString string];
    NSMutableString *topStr = [NSMutableString string];
    
    PassWordTitleList *titleList = [PassWordTitleList sharePassWordTitleList];
    int arrCount = (int )_selectData.count;
 
    //排序
    for (int i = 0; i < arrCount; i++) {
        
        for (int j = 0; j < arrCount - i; j++) {
            
            if (j+1 < arrCount) {
                
                PassWordTitleModel *model1 = _selectData[j];
                PassWordTitleModel *model2 = _selectData[j+1];

                if ([model1 isKindOfClass:[PassWordTitleModel class]] && [model2 isKindOfClass:[PassWordTitleModel class]]) {
                    
                    if (model1.index > model2.index) {
                        
                        [_selectData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }
              
                
            }
        }
    }
    
    for (PassWordTitleModel *model in _selectData) {
        
        if (![model isEqual:@""]) {
            
            topTime -= i;
            
            [midStr appendFormat:@"%d,",model.mid];
            [topStr appendFormat:@"%@,",[NSString stringWithFormat:@"%ld",topTime]];
            
            i++;
        }
    }
    
    NSString *passMidStr = @"";
    NSString *passTopStr = @"";
    if (midStr.length > 0) {
        
        passMidStr = [midStr substringWithRange:NSMakeRange(0, midStr.length - 1)];
        passTopStr = [topStr substringWithRange:NSMakeRange(0, topStr.length -1)];
        
    }

    
    //置顶
    [RequestManager topPassWordTitleTypeWithMidStr:passMidStr topStr:passTopStr complish:^(BOOL success, int mid) {
        
        if (success) {
            
            NSArray *arrForTop = [passTopStr componentsSeparatedByString:@","];
            
            for (int i = 0; i < _selectData.count; i++) {
               
                PassWordTitleModel *model =_selectData[i];
                if ([model isKindOfClass:[PassWordTitleModel class]]) {
                    
                    model.top = arrForTop[i];
                    [titleList upWithModel:model];
                }
                
            }
            
            [_mutableData removeAllObjects];
            _mutableData = nil;
            NSArray *arr = [titleList selectData];
            
            _mutableData = [NSMutableArray arrayWithObjects:@"", nil];
            [_mutableData addObjectsFromArray:arr];
            
            NSInteger number = 0;
            number = _selectData.count;
            //置顶选中状态
            for (int i = 0; i < _mutableData.count; i++) {
                if (i < _selectData.count) {
                    
                    flag[i+1] = YES;
                }else{
                    flag[i+1] = NO;
                }
            }
            
            
            [_selectData removeAllObjects];
            _selectData = nil;
            _selectData = [NSMutableArray array];
            //不是同一个model
            for (int i = 0; i < number; i++) {
                
                [_selectData addObject:_mutableData[i+1]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                //取消编辑
                editBtn.selected = YES;
                [self editAction:editBtn];
                
                [self cancelAction];
                [_tableView reloadData];
            });
            
        }else{
         
            if (mid == notNetWork) {
                
                [Tool showAlter:self title:@"置顶失败,服务器网络异常"];
                NSLog(@"网络问题");
                
            }else{
                
                [Tool showAlter:self title:@"置顶失败,服务器网络异常"];
                NSLog(@"服务器fali");
            }
        }
        
    }];
    
    
    
   
}

- (void)cancelAction
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _selectAllBtn.origin = CGPointMake(_selectAllBtn.origin.x, kScreenHeight );
        _deleteBtn.origin = CGPointMake(_deleteBtn.origin.x, kScreenHeight );
        _shareBtn.origin = CGPointMake(_shareBtn.origin.x, kScreenHeight );
        _topBtn.origin = CGPointMake(_topBtn.origin.x, kScreenHeight );
    }];
    
    _isEdit = NO;
    
    _selectAllBtn.selected = YES;
    [self selectAllAction:_selectAllBtn];
}

- (void)editAction
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _selectAllBtn.origin = CGPointMake(_selectAllBtn.origin.x, kScreenHeight - 64 - 60);
        _deleteBtn.origin = CGPointMake(_deleteBtn.origin.x, kScreenHeight - 64 - 60);
        _shareBtn.origin = CGPointMake(_shareBtn.origin.x, kScreenHeight  - 64 - 60);
        _topBtn.origin = CGPointMake(_topBtn.origin.x, kScreenHeight - 64 - 60);
    }];
    
    _isEdit = YES;
    [_tableView reloadData];
}

#pragma mark 创建tb
- (void)_creatTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 60)];
    _tableView.rowHeight = 30;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:whiteView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PasswordCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
}

#pragma mark 编辑方法
- (void)editAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self editAction];
    }else{
        [self cancelAction];
    }
    
    NSLog(@"开始编辑了哦");
}

#pragma mark tb代理方法
//行高
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 50;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _mutableData.count;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        
        cell = [[PasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    //开始编辑(标题)
    __weak typeof(self) weekSelf = self;
    __block UITextField *weekTextField = _selectTextField;
    __block void (^weekBlock)(CGFloat keyboardHeight) = changeView;
    [cell setBeginEditBlock:^(UITextField *textField,CGRect rect,PasswordCell *selectCell) {
        
        [textField resignFirstResponder];
        
        //无弹框时计算cell高度，以免键盘挡住输入框
        /*
        NSIndexPath *indexP = [tableView indexPathForCell:selectCell];
        weekTextField = textField;
        NSLog(@"%lf",rect.origin.y);
        NSLog(@"table %lf",tableView.frame.origin.y);
        if (indexP.row >= 5) {
            
            [tableView setContentOffset:CGPointMake(0,(indexP.row - 4) * 50.0+50) animated:YES];
        }
        
        
        weekBlock = ^(CGFloat height){
            
            tableView.contentSize = CGSizeMake(0, tableView.contentSize.height + height);
        };
        */
        
        EditPassWordTitleView *titleView = [[EditPassWordTitleView alloc]initWithFrame:CGRectZero andTitle:@"重新命名文件夹" content:@"请为此文件夹输入新名称"];
        [weekSelf.navigationController.view addSubview:titleView];
        
        [titleView.textField becomeFirstResponder];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weekSelf.navigationController.view.mas_top);
            make.left.equalTo(weekSelf.navigationController.view.mas_left);
            make.right.equalTo(weekSelf.navigationController.view.mas_right);
            make.bottom.equalTo(weekSelf.navigationController.view.mas_bottom);
            
        }];
        
        titleView.text = textField.text;
        titleView.textField.text = textField.text;
        __weak EditPassWordTitleView *titleView1 = titleView;
        //确定
        [titleView setConfirmBlock:^(NSString *text) {
            
            textField.text = text;
            selectCell.finishEditBlock(textField,selectCell);
            [textField resignFirstResponder];
            [titleView1 removeFromSuperview];

        }];
        
        //取消
        [titleView setCancelBlock:^{
            
            [textField resignFirstResponder];
            [titleView1 removeFromSuperview];
        }];
        
    }];
    
    //结束编辑(标题)
    __block NSMutableArray *weekArr = _mutableData;
    [cell setFinishEditBlock:^(UITextField *textField ,PasswordCell *selectCell) {
        
        NSIndexPath *_indexPath = [tableView indexPathForCell:selectCell];
        
        PassWordTitleModel *model = weekArr[_indexPath.row];
        PassWordTitleList *titleList = [PassWordTitleList sharePassWordTitleList];
        
        NSString *beforeChange = model.title;
        
        PassWordTitleModel *selectModel = [[PassWordTitleModel alloc] init];
        selectModel.mid = model.mid;
        selectModel.title = textField.text;
        //修改passWordTitle
        [RequestManager upDatePassWordTitleWithModel:selectModel complish:^(BOOL success, int mid) {
            
            if (success) {
                //不能直接赋textFiled.text,当点击取消按钮刷新textFiled改变
                //可以改成点击取消后编辑失效
                model.title = selectModel.title;
                [titleList upWithModel:model];
   
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });

            }else{
             
                if (mid == notNetWork) {
                    NSLog(@"网络问题");
                }else{
                    NSLog(@"服务器fali");
                }
                
                textField.text = beforeChange;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            }
        }];
    }];
    
    
    //是否选中状态
    [cell selectCell:flag[indexPath.row]];
    
    //是否为最后一个
    if (indexPath.row == 0) {
        [cell hiddenLast];
        [cell createAddBtn];
        
        cell.editNamebTN.userInteractionEnabled = NO;
        
    }else{
        
        PassWordTitleModel *model = _mutableData[indexPath.row];
        model.index = (int )indexPath.row;
        cell.titleLabel.text = model.title;
        cell.titleField.text = model.title;
        cell.numberLabel.text = model.number;
        
        cell.numberLabel.hidden = NO;
        [cell removeAddImage];
        
        
        if (_isEdit) {
            
            cell.editNamebTN.userInteractionEnabled = YES;
            
        }else{
        
            cell.editNamebTN.userInteractionEnabled = NO;
        }
    }
    
    //是否编辑状态
    [cell editType:_isEdit];
    
    NSLog(@"%@",cell.numberLabel.text);
    //宽度
    if ([cell.numberLabel.text intValue] >= 100) {
        
        [cell changeLabelWidth];
        
    }else{
     
        [cell normalWidth];
    }
    
    return cell;
    
}

- (NSString *)_timeStr
{
 
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    
    return [formatter stringFromDate:date];
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_selectTextField resignFirstResponder];

    //编辑装填
    if (_isEdit) {

        //编辑状态不能添加新主题
        if (indexPath.row == 0) {
            return;
        }
        
        PasswordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        flag[indexPath.row] = !flag[indexPath.row];
        
        if (flag[indexPath.row]) {
            [_selectData addObject:_mutableData[indexPath.row]];
        }else{
            [_selectData removeObject:_mutableData[indexPath.row]];
        }
        
        [cell selectCell:flag[indexPath.row]];
        
        if (_selectData.count == _mutableData.count-1) {
            
            _selectAllBtn.selected = NO;
            [self selectAllAction:_selectAllBtn];
            
        }else{
            
            _selectAllBtn.selected = NO;
             [self _changeBtn:_selectAllBtn];
        }
        
        return;
    }
    
    //添加新题型
    if (indexPath.row == 0) {
        
        EditPassWordTitleView *titleView = [[EditPassWordTitleView alloc] initWithFrame:CGRectZero andTitle:@"给文件夹命名" content:@"请为此文件夹输入名称"];
        NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor grayColor]};
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"储存" attributes:dic1];
       
        [titleView.confirm setAttributedTitle:str1 forState:UIControlStateNormal];
        titleView.confirm.userInteractionEnabled = NO;
        [self.navigationController.view addSubview:titleView];
        
        [titleView.textField becomeFirstResponder];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.navigationController.view.mas_top);
            make.left.equalTo(self.navigationController.view.mas_left);
            make.right.equalTo(self.navigationController.view.mas_right);
            make.bottom.equalTo(self.navigationController.view.mas_bottom);
            
        }];

        __weak typeof(self)weekSelf = self;
        __weak EditPassWordTitleView *titleView1 = titleView;

        [titleView setCancelBlock:^{
            
            
            [titleView1 removeFromSuperview];
        }];
        
        [titleView setConfirmBlock:^(NSString *passWordTitle) {
            
            [weekSelf addPassWordWithText:passWordTitle tb:tableView];
            [titleView1 removeFromSuperview];
        }];
        
        
        
    }else{
     
        PassWordDetailVC *vc = [PassWordDetailVC new];
        vc.arrIndex = (int )_mutableData.count - 1;
        PassWordList *list = [PassWordList sharePassList];
        
        //指向同一个model,所以在另一个页面对Model的值进行修改，这个页面Model的number值也更改了
        PassWordTitleModel *model = _mutableData[indexPath.row];
        vc.titleModel = model;
        //刷新数据
        __block UITableView *table = tableView;
        [vc setReloadDataBlock:^(int index,NSArray *modelArr){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [table reloadData];
                    
                });
                
            });
    
        }];
        
        vc.title = model.title;
        NSArray *arrForModel = [list selectModelWithType:model.mid];
        
        vc.widthForText = _widthForText;
        if (arrForModel.count > 0 && arrForModel != nil) {
            
            vc.arrForModel = [NSMutableArray arrayWithArray:arrForModel];
            
        }else{
            
            vc.arrForModel = [@[] mutableCopy];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (void)addPassWordWithText:(NSString *)text tb:(UITableView *)tableView
{
    PassWordTitleList *list = [PassWordTitleList sharePassWordTitleList];
    
    /*
    NSMutableArray *arrForNumber = [NSMutableArray array];
    int beforeNumber = 0;
    for (PassWordTitleModel *model in _mutableData) {
        
        if (![model isEqual: @""] && model.title.length >= 4.0) {
            NSString *name = [model.title substringWithRange:NSMakeRange(0, 3)];
            
            if ([name isEqualToString:@"文件夹"]) {
                
                NSString *number = [model.title substringWithRange:NSMakeRange(3, model.title.length - 3)];
                if ([number intValue] != 0 && [number intValue] != beforeNumber) {
                    
                    [arrForNumber addObject:number];
                    beforeNumber = [number intValue];
                }
                
            }
        }
    }
    //对序号排序
    for (int i = 0; i < arrForNumber.count; i++) {
        
        for (int j = 0; j < arrForNumber.count - i; j++) {
            if (j+1 < arrForNumber.count - i) {
                
                NSInteger left = [arrForNumber[j]integerValue];
                NSInteger right = [arrForNumber[j+1]integerValue];
                
                if (left > right) {
                    
                    [arrForNumber exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
        
    }
    
    //筛选序号
    NSInteger selectIndex = 1;
    for (int i = 1; i < arrForNumber.count+1; i++) {
        
        NSInteger index = [arrForNumber[i-1]integerValue];
        
        if (index != i && index != 0) {
            selectIndex = i;
            break;
        }else{
            //最后一个+1
            if (i == arrForNumber.count) {
                selectIndex = i+1;
            }
        }
    }
    
    if (arrForNumber.count > 0) {
        
        if (arrForNumber.count == 1 && [arrForNumber[0]integerValue] == 1) {
            selectIndex = 2;
        }
    }
    */
    
    PassWordTitleModel *model = [[PassWordTitleModel alloc] init];
    model.number = @"0";
    
    
    model.title = text;
    
    
    //model.title = @"文件夹";
    model.top = @"0";
    
    //新增passWordTitle
    [RequestManager addNewPassWordTypeWithModel:model complish:^(BOOL success,int mid) {
        
        if (success) {
            
            model.mid = mid;
            [list insertDataWithModel:model];
            
            [_mutableData addObject:[[list selectData] lastObject]];
            
            PassWordDetailVC *vc = [PassWordDetailVC new];
            vc.arrIndex = (int )_mutableData.count - 1;
            vc.titleModel = _mutableData.lastObject;
            //刷新数据
            __block UITableView *table = tableView;
            [vc setReloadDataBlock:^(int index,NSArray *modelArr){
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [table reloadData];
                        
                    });
                    
                });
                
            }];
            
            vc.title = model.title;
            vc.widthForText = _widthForText;
            
            vc.arrForModel = [@[] mutableCopy];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            if (mid == notNetWork) {
                
                [Tool showAlter:self title:@"服务器网络异常"];
                
            }else{
                
                [Tool showAlter:self title:@"服务器网络异常"];
                NSLog(@"服务器fali");
            }
        }
        
    }];
    
    NSLog(@"添加新的");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
