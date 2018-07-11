//
//  JYPersonCentreViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYPersonCentreViewController.h"
#import "TableViewCell.h"
#import "JYSetUpViewController.h"
#import "JYPersonMeansViewController.h"
#import "JYGroupViewController.h"
#import "JYFriendListVC.h"
#import "NowLoginViewController.h"
#import "AppDelegate.h"


#import "JYTalkMoreVC.h" //话唠
#import "JYCollectionVC.h" //收藏
#import "JYPhotoVC.h"  //相册
#import "JYSkinVC.h"   //换肤


#define heightForBtn 84 / 1334.0 * kScreenHeight
#define xForBtn      20 / 750.0 * kScreenWidth
#define yForBtn      1160 / 1334.0 * kScreenHeight

static NSString *cellForSet = @"cellForSet";

@interface JYPersonCentreViewController ()
{
    
    UITableView *_setTableView;
    JYGroupViewController *_jyGroupVc;
    JYFriendListVC        *_jyFriendVC;
    NSArray     *_arrForCellText;
    NSArray     *_arrForPic;
    UIButton    *_btnForZhuxiao;
    JYMainViewController *jyMain;
}
@property (nonatomic,strong) UIButton *leftBtn;

@end


@interface JYPersonCentreViewController (tableView)<UITableViewDataSource,UITableViewDelegate>


- (void)_createTableView;

@end


@implementation JYPersonCentreViewController

- (void)actionForReloadTabeView:(id)isReload
{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [_setTableView reloadData];
        
    });
    
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)actionForLeft:(UIButton *)sender
{

    _actionForHiddenToday();

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    imageView.image = _imageForBg;
    [self.navigationController.view addSubview:imageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.navigationController.view.origin = CGPointMake(-kScreenWidth, 0);
        //imageView.origin = CGPointMake(0, 0);
        
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
        self.navigationController.view.origin = CGPointMake(0, 0);

        [self.navigationController popViewControllerAnimated:NO];
    }];
    
}

//- (void)popAction
//{
//    [self.navigationController popViewControllerAnimated:NO];
//}

- (void)changeSkinAction:(NSNotification *)notification
{
    _arrForPic = [notification.userInfo objectForKey:@"arr"];
    [_setTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadTabeView:) name:kNotificationForAcceptFriend object:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkinAction:) name:kNotificationForPersonSkin object:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    
//    _arrForCellText = @[@"话唠榜",@"收藏",@"相册",@"换肤",@"设置"];
    _arrForCellText = @[@"收藏",@"相册",@"换肤",@"设置"];
    _arrForPic = [skinManager actionForReturnSelectPersonImage:[[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin]];
    //获取数组改变图片
    skinManager.arrForPersonImage = _arrForPic;
    
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    self.navigationItem.title = @"个人中心";
  
    [self _createTableView];
    
    UIView *whiteView = [UIView new];
    
    [_setTableView setTableFooterView:whiteView];

    //导航
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.leftBtn setImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [self.leftBtn addTarget:self action:@selector(actionForBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.setTableView reloadData];
}
- (void)actionForBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//换皮肤
- (void)changeSkin:(NSNotification *)notice
{
    self.leftBtn.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
}
@end




@implementation JYPersonCentreViewController (tableView)


- (void)actionForSetLeftBtn
{
    
}


- (void)_createTableView
{

    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    [self.view addSubview:_setTableView];
    [_setTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:cellForSet];

  


}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.row == 0) {
        
        return 100;
        
    }else{
      
        return 49;
    }
    
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        return [_arrForCellText count]+1;

}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellForSet];
 
    if (!cell) {
        
        cell  = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForSet];
        cell.translatesAutoresizingMaskIntoConstraints = NO;

    }
    //cell.userHead.backgroundColor = [UIColor orangeColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        cell.userName.text = [defaults objectForKey:kUserName];
        
        [cell.userHead sd_setImageWithURL:[defaults objectForKey:kUserHead] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        cell.userHead.layer.masksToBounds = YES;
        cell.userHead.layer.cornerRadius = cell.userHead.width / 2.0;
        cell.userNumber.text = [NSString stringWithFormat:@"小秘号:  %@",[defaults objectForKey:kUserXiaomiID]];
        cell.userHead.hidden = NO;
        cell.userName.hidden = NO;
        cell.userNumber.hidden = NO;
        cell.imageForSet.hidden = YES;
        cell.setLabel.hidden = YES;
        cell.barImage.hidden = NO;
        cell.barImage.image = [UIImage imageNamed:@"二维码.png"];
        
    }else{
      
        cell.userHead.hidden = YES;
        cell.userName.hidden = YES;
        //跳过第一个"话唠榜"
        cell.imageForSet.image = [UIImage imageNamed:_arrForPic[indexPath.row]] ;
        cell.userNumber.hidden = YES;
        cell.imageForSet.hidden = NO;
        cell.setLabel.hidden = NO;
        cell.barImage.hidden = YES;
        cell.setLabel.text = _arrForCellText[indexPath.row - 1];
        
    }
    
    
    return cell;
    
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
 
 
        JYPersonMeansViewController *meansVC = [[JYPersonMeansViewController alloc] init];
        
        //隐藏tb
        meansVC.hidesBottomBarWhenPushed = YES;
        
        NSString *strForXiaomiId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        NSString *xiaomiStr = [NSString stringWithFormat:@"xiaomi%@",strForXiaomiId];
        self.barImage = [QRCodeGenerator qrImageForString:xiaomiStr imageSize:162];
        meansVC.name = self.userName.text;
        meansVC.userHead = self.userHead.image;
        meansVC.bar = self.barImage;
        

        [meansVC setAcitonForReloadTb:^(UIImage *imageForCell , NSString *nameStr){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                if (imageForCell == nil) {
                    
                    NSString *userHead = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
                    [cell.userHead sd_setImageWithURL:[NSURL URLWithString:userHead]];
                    
                }else {
                    
                    cell.userHead.image = imageForCell;
                }
                
                cell.userName.text = nameStr;
                [[NSUserDefaults standardUserDefaults]setObject:nameStr forKey:kUserName];
                
            });
            
        }];
        
        [self.navigationController pushViewController:meansVC animated:YES];
        
    }else{
       
//        if (indexPath.row == 1) {
//            
//            JYTalkMoreVC *jytalkMor = [[JYTalkMoreVC alloc] init];
//            
//            jytalkMor.title = @"话唠榜";
//            
//            jytalkMor.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:jytalkMor animated:YES];
//        
//            
//        }else
            if(indexPath.row == 1){
        
            //监测查看收藏
            [RequestManager actionForHttp:@"query_save"];
                
            JYCollectionVC *jycoll = [[JYCollectionVC alloc] init];
            
            jycoll.title = @"收藏";
            
            jycoll.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:jycoll animated:YES];
       
            
        }else if (indexPath.row == 2){
        
            //监测查看相册
            [RequestManager actionForHttp:@"query_picture"];
            
            JYPhotoVC *jyphoto = [[JYPhotoVC alloc] init];
            
            jyphoto.title = @"相册";
            
            jyphoto.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:jyphoto animated:YES];
            
        }else if (indexPath.row == 3){
            
            //监测换肤
            [RequestManager actionForHttp:@"change_skin"];
            
            JYSkinVC *jyskin = [[JYSkinVC alloc] init];
            
            jyskin.title = @"换肤";
            
            jyskin.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:jyskin animated:YES];
     
        }else if (indexPath.row ==  4){
        
            JYSetUpViewController *setVC = [[JYSetUpViewController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:setVC animated:YES];
        }
    
    }
    
}


@end
