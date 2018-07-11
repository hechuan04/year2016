//
//  JYSetView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYSetView.h"
#import "SetTableViewCell.h"


static NSString *strForSetCell = @"strForSetCell";

@implementation JYSetView
{
   
    NSArray *_arrForBtn;  //设置按钮上
    NSArray *_arrForPic;  //图片

}

- (void)dealloc
{
 
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kNotificationForSetSkin];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)actionForChangeSkin:(NSNotification *)notification
{
    _arrForPic = [notification.userInfo objectForKey:@"arr"];
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForChangeSkin:) name:kNotificationForSetSkin object:@""];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:strForSetCell];
        
        _arrForBtn = @[@"夜间防扰 (23:00 - 6:00)",@"快捷扫码",@"关于小秘",@"去评分",@"意见反馈",@"退出账号"];
        _arrForPic = [[JYSkinManager shareSkinManager] actionForReturnSelectSetImage:[[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin]];
        
        
    }

    return self;
    
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 49;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrForBtn.count;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForSetCell];
    if (!cell) {
        
        cell = [[SetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForSetCell];
 
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleImage.image = [UIImage imageNamed:_arrForPic[indexPath.row]];
    
    if (indexPath.row == 0) {
        
        cell.switchBtn.hidden = NO;
        cell.trigonometryImage.hidden = YES;
    }else{
    
        cell.switchBtn.hidden = YES;
        cell.trigonometryImage.hidden = NO;

    }
    
    
    if (indexPath.row == _arrForBtn.count - 1) {
        
        
        cell.titleLabel.text = _arrForBtn[indexPath.row];
        cell.changeLabel.hidden = YES;
        cell.changeLabel.text = @"让我们更好";
        cell.changeLabel.textColor = [UIColor grayColor];

    }else{
    
        cell.titleLabel.text = _arrForBtn[indexPath.row];
        cell.changeLabel.hidden = YES;


    }
    
    
    cell.isOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isDistrubation"] boolValue];
    if (cell.isOpen) {
        
        cell.switchBtn.on = YES;
        
    }else{
        
        cell.switchBtn.on = NO;
    }
    
  //******************打开关闭方法**************************//
    [cell setIsDistrubation:^void(BOOL isDis){
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:isDis forKey:kisDistrubation];
        
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        
        LocalListManager    *locManager = [LocalListManager shareLocalListManager];
        
        MusicListManager *musList = [MusicListManager shareMusicListManager];
        
        
        int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        NSArray *arrForLocal = [locManager selectAllLocalDataWithUserID:xiaomiID];
        NSArray *arrForInc = [manager searchWithStr:@""];
        
        
        //当天年月日
        //查询所有的任务

        
        //是否打开防打扰模式
        if (isDis) {
            
            [self actionForChangeIsOn:arrForInc manager:musList];
            [self actionForChangeIsOn:arrForLocal manager:locManager];
            
            
        }else{
      
            [self actionForChangeIsNowOn:arrForInc manager:musList];
            [self actionForChangeIsNowOn:arrForLocal manager:locManager];
    
        }
        

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
        
    }];
    
    return cell;
    
}

- (void)actionForChangeIsNowOn:(NSArray *)arrForModel
                       manager:(id )manager
{
    for (int i = 0; i < arrForModel.count; i++) {
        
        RemindModel *model = arrForModel[i];
        
        if (model.hour >= 23 || model.hour <= 6) {
            
            model.isOn = 1;
      
            if ([manager isKindOfClass:[LocalListManager class]]) {
                
                [manager upDataWithModel:model];

            }else{
             
                [manager deleteDataWithModel:model];
                [manager insertDataWithModel:model musicName:model.musicName];
            }
  
        }
    
    }

}

- (void)actionForChangeIsOn:(NSArray *)arrForModel
                    manager:(id )manager
{

    for (int i = 0; i < arrForModel.count; i++) {
        
        RemindModel *model = arrForModel[i];
        
        if (model.hour >= 23 || model.hour <= 6) {
            
            model.isOn = 0;
            
            if ([manager isKindOfClass:[LocalListManager class]]) {
                
                [manager upDataWithModel:model];
                
            }else{
                
                [manager deleteDataWithModel:model];
                [manager insertDataWithModel:model musicName:model.musicName];
            }
            

        }
        
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    _pushAction(indexPath.row);

}



@end
