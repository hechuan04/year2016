//
//  FestivalDetailViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/8.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FestivalDetailViewController.h"
#import "ReferenceDBManager.h"

@interface FestivalDetailViewController ()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) FestivalType festType;
@property (nonatomic,copy) NSString *festivalName;
@end

@implementation FestivalDetailViewController

- (instancetype)initWithFestivalType:(FestivalType)type name:(NSString *)name
{
    self = [super init];
    if(self){
        self.festType = type;
        self.festivalName = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"festival_bg" ofType:@"jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 414, 736)];
    bgImageView.image = bgImg;
    [self.view addSubview:bgImageView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [leftBtn addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.textContainerInset = UIEdgeInsetsMake(20, 17, 50, 17);
    if(IS_IPHONE_6P_SCREEN){
        textView.textContainerInset = UIEdgeInsetsMake(20, 15, 50, 15);
    }
    [self.view addSubview:textView];
    self.textView = textView;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //navigationBar透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)loadData
{
    self.navigationItem.title = self.festivalName;
    NSString *txt = @"";
    if(self.festType==FestivalTypeFoLi){
        txt = [[ReferenceDBManager sharedManager]queryFoDetailWithName:self.festivalName];
    }else{
        txt = [[ReferenceDBManager sharedManager]queryFestivalDetailWithName:self.festivalName];
    }
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 8.f;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:txt attributes:@{NSParagraphStyleAttributeName:para,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    self.textView.attributedText = attrStr;
}
- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
