//
//  MyWeiboListController.m
//  JYCalendarNew
//
//  Created by 何川 on 15-12-23.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "MyWeiboListController.h"

@interface MyWeiboListController ()

@property (strong, nonatomic) NSArray *List;
@property (strong, nonatomic) NSArray *timeList;
@property (strong, nonatomic) UITableView *DataTable;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation MyWeiboListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _defaults = [NSUserDefaults standardUserDefaults];
    
    //抬头
    self.navigationItem.title=@"微博好友";
    
    //返回键
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;
    
    //添加表格
    self.DataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.DataTable setDelegate:self];
    [self.DataTable setDataSource:self];
    [self.view addSubview:_DataTable];
    //去掉底部多余的表格线
    [self.DataTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //增加顶部横线
    UIImageView *topline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
    [topline setBackgroundColor:[UIColor grayColor]];
    topline.alpha = 0.8;
    [self.view addSubview:topline];
    
    //显示菊花
    [ProgressHUD show:@"同步中…"];
    
    //同步微博好友
    [self findWeiboFriend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 20, 100, 15)];
        [nameLabel setTag:1];
        
        UIImageView *addBtn = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-60-20, 15, 60, 30)];
        [addBtn setTag:3];
        
        //Datalabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:addBtn];
    }
    
    //NSUInteger row = [indexPath row];
    //cell.textLabel.text = [self.list objectAtIndex:row];
    
    //姓名
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:18]];
    nameLabel.text = [[self.List objectAtIndex:indexPath.row] objectForKey:@"userName"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //右侧按钮
    UIImageView *addBtn = (UIImageView *)[cell.contentView viewWithTag:3];
    addBtn.userInteractionEnabled = YES;
    if([[[self.List objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"1"]){
        addBtn.image = [UIImage imageNamed:@"添加朋友"];
        addBtn.tag = [[[self.List objectAtIndex:indexPath.row] objectForKey:@"uid"] intValue];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriends:)];
        [addBtn addGestureRecognizer:singleTap];
    }else if([[[self.List objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]){
        addBtn.image = [UIImage imageNamed:@"已添加"];
    }else if([[[self.List objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"3"]){
        addBtn.image = [UIImage imageNamed:@"等待验证"];
    }else{
        addBtn.hidden = YES;
    }
    
    //头像
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *cellImageLayer = cell.imageView.layer;
    [cellImageLayer setCornerRadius:23];
    [cellImageLayer setMasksToBounds:YES];
    [cell.imageView sd_setImageWithURL:[[self.List objectAtIndex:indexPath.row] objectForKey:@"head"] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    cell.imageView.image = [self createRoundedRectImage:cell.imageView.image size:CGSizeMake(48,48) radius:23];
    
    //分割线
    [self.DataTable setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
    //去掉右侧剪头
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.List.count;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//得到当前微博用户双向关注uid列表
- (void)findWeiboFriend {
    
    NSString *uid = _weiboBindOpenId;//[_defaults objectForKey:kThirdOpenID];
    NSString *token = _weiboBindToken;//[_defaults objectForKey:kWeiboToken];
    NSString *mid = [_defaults objectForKey:kUserXiaomiID];

    int pageNumber = 2000;
    NSString *urlStr =[NSString stringWithFormat:@"https://api.weibo.com/2/friendships/friends/bilateral/ids.json?uid=%@&access_token=%@&count%d",uid,token,pageNumber];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        //拼接微博三方id
        NSString *openIDStr = @"";
        for(NSString *str in dict[@"ids"]){
            if([openIDStr isEqual: @""]){
                openIDStr = str;
            }else{
                openIDStr = [NSString stringWithFormat:@"%@,%@",openIDStr,str];
            }
        }
        [self queryWeiboFriend:mid openIdParam:openIDStr];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

//确认微博好友状态
- (void)queryWeiboFriend:(NSString*)mid openIdParam:(NSString*)openid {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"uid":mid, @"weiboStr":openid};
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:[kXiaomiUrl stringByAppendingString:@"synWeiboFri"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]){
            self.List = responseObject[@"data"];
            [self.DataTable reloadData];
        }
        
        //移除菊花
        [ProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //移除菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

//添加好友
- (void)addFriends:(id)sender {
    //显示菊花
    [ProgressHUD show:@"请求中…"];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@addFriend",kXiaomiUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)view.tag] forKey:@"fid"];
    [dic setObject:[_defaults objectForKey:kUserXiaomiID] forKey:@"uid"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        UIImageView *addBtn = (UIImageView *)[_DataTable viewWithTag:view.tag];
        addBtn.image = [UIImage imageNamed:@"等待验证"];

        //移除菊花
        [ProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation * operation, NSError * err) {
        //移除菊花
        [ProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"申请添加微博好友失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)actionForLeft:(UIButton *)sender {
    NSArray *arr = self.navigationController.viewControllers;
    
    UIViewController *popVC = nil;
    for (int i = 0; i < arr.count; i ++) {
        
        UIViewController *vc = arr[i];
        
        if ([vc isKindOfClass:[NewFriendViewController class]]) {
            popVC = vc;
            
            break;
        }
        
    }
    
    [self.navigationController popToViewController:popVC animated:YES];
}

//图片转圆角
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                          float ovalHeight) {
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
- (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

@end