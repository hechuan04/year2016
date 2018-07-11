//
//  JYSkinVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSkinVC.h"
#import "SkinCell.h"

static NSString *skinCellIdentifier = @"skinCellIdentifier";

@interface JYSkinVC ()
{
 
    UITableView *_skinTableView;
    
}
@end

@implementation JYSkinVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _userDefault = [NSUserDefaults standardUserDefaults];
    
    _selectColor = [_userDefault objectForKey:kUserSkin];
    
  
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;

    
    [self _creatTableView];
   
}

//确认方法
- (void)rightAction
{
 
    //设置主题
    [_userDefault setObject:_selectColor forKey:kUserSkin];
    
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    
    [skinManager actionForChangeSkin:_selectColor];
    
    //换肤更新
    [RequestManager actionForPassNameAndUserHead:nil name:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)_creatTableView
{
    
    _skinTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _skinTableView.delegate = self;
    _skinTableView.dataSource = self;
    [self.view addSubview:_skinTableView];
    
    [_skinTableView registerNib:[UINib nibWithNibName:@"SkinCell" bundle:nil] forCellReuseIdentifier:skinCellIdentifier];
    
    [Tool actionForHiddenMuchTable:_skinTableView];
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SkinCell *cell = [tableView dequeueReusableCellWithIdentifier:skinCellIdentifier];
    
    if (!cell) {
        
        cell = [[SkinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:skinCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectImage.hidden = YES;
    cell.selectLabel.hidden = YES;
    
    if (indexPath.row == 0) {
        
        cell.selectText.hidden = YES;
        cell.selectLabel.hidden = NO;
        cell.selectColor.hidden = YES;
        
    }else if(indexPath.row == 1) {
        
        cell.selectColor.backgroundColor = bgRedColor;
        
        cell.selectText.text = @"红色";
        
        [self _actionForHiddenSelect:cell text:@"红色"];
        
    }else if(indexPath.row == 2){
     
        cell.selectColor.backgroundColor = bgGreenColor;
        
        cell.selectText.text = @"绿色";
       
        [self _actionForHiddenSelect:cell text:@"绿色"];
        
    }else if(indexPath.row == 3){
    
        cell.selectColor.backgroundColor = bgPinkColor;
        
        cell.selectText.text = @"粉色";

        [self _actionForHiddenSelect:cell text:@"粉色"];
        
    }else if(indexPath.row == 4){
    
        cell.selectColor.backgroundColor = bgBlueColor;
       
        cell.selectText.text = @"蓝色";
        
        [self _actionForHiddenSelect:cell text:@"蓝色"];

    }else{
        
        cell.selectColor.backgroundColor = bgOrangeColor;
        
        cell.selectText.text = @"橙色";
        
        [self _actionForHiddenSelect:cell text:@"橙色"];
    
    }
    
  
    
    
    return cell;
    
}

- (void)_actionForHiddenSelect:(SkinCell *)cell text:(NSString *)color
{
 
    if ([_selectColor isEqualToString:color]) {
        
        cell.selectImage.hidden = NO;
    }
    
}


//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    if (indexPath.row == 1) {
        
        _selectColor = @"红色";
        
        [_skinTableView reloadData];
        
    }else if(indexPath.row == 2){
     
        _selectColor = @"绿色";
        
        [_skinTableView reloadData];
        
    }else if(indexPath.row == 3){
     
        _selectColor = @"粉色";
        
        [_skinTableView reloadData];
        
    }else if(indexPath.row == 4){
     
        _selectColor = @"蓝色";
        
        [_skinTableView reloadData];
        
    }else if(indexPath.row == 5){
    
        _selectColor = @"橙色";
        
        [_skinTableView reloadData];
    }
 
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 0) {
        
        return 44;
        
    }else{
     
        return 49;
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
