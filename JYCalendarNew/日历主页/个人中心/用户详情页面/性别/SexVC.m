//
//  SexVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SexVC.h"
#import "SexCell.h"
static NSString *sexCell = @"sexCell";

@interface SexVC ()
{
 
    NSString *userSex;
    
}
@end

@implementation SexVC

- (void)viewDidLoad {
    [super viewDidLoad];

    userSex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];

    [self _createTable];

}


- (void)_createTable
{
 
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue: 240 / 255.0 alpha:1];
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"SexCell" bundle:nil] forCellReuseIdentifier:sexCell];
    
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue: 240 / 255.0 alpha:1];
    
    [tableView setTableFooterView:footView];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        
        return 15.f;

    }else{
    
        return 49.f;

    }
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"男" forKey:kUserSex];
        
        _actionForLoadTableView();
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(indexPath.row == 2){
     
        [[NSUserDefaults standardUserDefaults] setObject:@"女" forKey:kUserSex];
        
        _actionForLoadTableView();

        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SexCell *cell = [tableView dequeueReusableCellWithIdentifier:sexCell];
    
    if (!cell) {
        
        cell = [[SexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sexCell];
        
    }
    
    if (indexPath.row == 0) {
        
        cell.selectImage.hidden = YES;
        cell.sexLabel.hidden = YES;
        cell.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        
    }else{
     
        cell.backgroundColor = [UIColor whiteColor];
        
        if (userSex != nil) {
            
            if (indexPath.row == 1) {
                
                if ([userSex isEqualToString:@"男"]) {
                    
                    cell.selectImage.hidden = NO;
                    
                }else{
                    
                    cell.selectImage.hidden = YES;
                }
                
            }else if(indexPath.row == 2){
                
                if ([userSex isEqualToString:@"女"]) {
                    
                    cell.selectImage.hidden = NO;
                    
                }else{
                    
                    cell.selectImage.hidden = YES;
                }
                
            }
            
        }else{
            
            cell.selectImage.hidden = YES;
        }
    }
    
   
    
    
    
    if (indexPath.row == 1) {
        
        cell.sexLabel.text = @"男";
        
    }else if(indexPath.row == 2){
     
        cell.sexLabel.text = @"女";

    }
    
    return cell;
    
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
