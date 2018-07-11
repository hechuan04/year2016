//
//  JYSignVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSignVC.h"

@interface JYSignVC ()<UITextViewDelegate>
{
 
//    UITextView *textView;
    
}
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UILabel *placeholderLabel;
@property (nonatomic,assign) BOOL isAlerted;
@end

@implementation JYSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;

    [self setupSubviews];
}
- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255. blue:240 / 255. alpha:1];
    //内容
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:20];
    textView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    textView.returnKeyType = UIReturnKeyDefault;
    textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSign];
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.contentTextView = textView;
    
    UILabel *placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.backgroundColor= [UIColor clearColor];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.textColor = UIColorFromRGB(0xc2c2c2);
    placeholderLabel.font= textView.font;
    if(textView.text.length>0){
        placeholderLabel.text = @"";
    }else{
        placeholderLabel.text = @"最多可编辑150个字";
    }
    
    [self.view addSubview:placeholderLabel];
    self.placeholderLabel= placeholderLabel;
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10.f);
        make.height.equalTo(@240.f);
    }];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTextView).offset(13.f);
        make.top.equalTo(self.contentTextView).offset(5.f);
        
    }];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.contentTextView becomeFirstResponder];
}

//- (void)_creatTableView
//{
//    
// 
//    
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    
//    tableView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255. blue:240 / 255. alpha:1];
//    
//    UIView *viww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
//    viww.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255. blue:240 / 255. alpha:1];
//    [tableView addSubview:viww];
//    
//    [Tool actionForHiddenMuchTable:tableView];
//    
//  
//}
//
- (void)rightAction{
 
    [[NSUserDefaults standardUserDefaults] setObject:self.contentTextView.text forKey:kUserSign];
    _actionForSign(self.contentTextView.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionForLeft:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//    return 150.0;
//}
//
////行数
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return 1;
//    
//}
//
////创建单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *textViewIdentifier = @"textViewIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewIdentifier];
//    
//    if (!cell) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewIdentifier ];
//        
//        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150.)];
//        [textView becomeFirstResponder];
//        textView.font = [UIFont systemFontOfSize:20];
//        textView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);
//        textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSign];
//        textView.delegate = self;
//        [cell addSubview:textView];
//        
//        
//    }
//    
//    return cell;
//    
//}
- (void)textViewDidChange:(UITextView *)txtView
{
    //占位便签
    if (txtView.text.length == 0) {
        self.placeholderLabel.text = @"最多可编辑150个字";
    }else{
        self.placeholderLabel.text = @"";
    }

    if (txtView.text.length > 150) {
        txtView.text = [txtView.text substringToIndex:150];
        if(!self.isAlerted){
            self.isAlerted = YES;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"签名最多为150字!" message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
