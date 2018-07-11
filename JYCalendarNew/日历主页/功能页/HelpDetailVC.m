//
//  HelpDetailVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "HelpDetailVC.h"

@interface HelpDetailVC ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UIScrollView *bgScrollView;
@end

#define picWidth 231

@implementation HelpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助说明";

    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight )];;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.delegate = self;
    [_bgScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight * 8)];
    [self.view addSubview:_bgScrollView];
    
    [_bgScrollView setContentOffset:CGPointMake(0, _index * kScreenHeight)];
    
    for (int i = 0 ; i < 8; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * kScreenHeight, kScreenWidth, kScreenHeight)];
        //bgView.backgroundColor = RANDOM_COLOR;
        [_bgScrollView addSubview:bgView];
        
        [self _createView:bgView index:i];
    }
    
   // self.imageView.image = [UIImage imageNamed:@"小秘版本1.0"];
}

- (void)_createView:(UIView *)bg index:(int )i{
    
    switch (i) {
    case 0:
    {
        [self index1:bg];
    }
        break;
    case 1:
    {
        [self index2:bg];
        
    }
        break;
    case 2:
    {
        [self index3:bg];
        
    }
        break;
    case 3:
    {
        [self index4:bg];
    }
        break;
    case 4:
    {
        [self index5:bg];
    }
        break;
    case 5:
    {
        [self index6:bg];
    }
        break;
    case 6:
    {
        [self index7:bg];
    }
        break;
    case 7:
    {
        [self index8:bg];
        
    }
        break;
        
    default:
        break;
}
}

- (void)index1:(UIView *)bg{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"共享按钮可以“全选，共享”提醒列表中的信息。"]];
    UILabel *label = [self _createTitleLabel:bg text:str];
    
    [self _createImage1WithWidth:picWidth height:898/2.0 top:25 image:@"用户说明_index1" label:label superView:bg];
    
}

- (void)index2:(UIView *)bg{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"新建提醒功能\n\n1、点击    "]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [JYSkinManager shareSkinManager].addImage;
    attach.bounds = CGRectMake(0, -15, 47, 41);
    NSAttributedString *str1 = [NSAttributedString attributedStringWithAttachment:attach];
    [str appendAttributedString:str1];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"   新建提醒功能。\n\n2、点击下面的图标可以依次添加语音、图片、位置信息。"]];
    UILabel *label = [self _createTitleLabel:bg text:str];;
    
    [self _createImage1WithWidth:picWidth height:369 / 2.0 top:25 image:@"用户说明_index2" label:label superView:bg];
}


- (void)index3:(UIView *)bg{
    
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"编辑按钮的作用\n\n1、编辑按钮可以“全选、删除、置顶”提醒列表中的信息"]];
    UILabel *label = [self _createTitleLabel:bg text:str];;
    UIImageView *imageV1 = [self _createImage1WithWidth:picWidth height:434 / 2.0 top:25 image:@"用户说明_index3_1" label:label superView:bg];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"2、也可左滑可收藏或删除信息。";
    [bg addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV1.mas_bottom).offset(25.f);
        make.left.equalTo(bg.mas_left).offset(25.f);
        make.right.equalTo(bg.mas_right).offset(-25.f);
        
    }];
    
    UIImageView *iamgeV2 = [UIImageView new];
    //_imageView2.backgroundColor = [UIColor orangeColor];
    iamgeV2.image = [UIImage imageNamed:@"用户说明_index3_2"];
    [bg addSubview:iamgeV2];
    
    [iamgeV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(25.f);
        make.centerX.equalTo(bg.mas_centerX);
        make.width.mas_equalTo(picWidth);
        make.height.mas_equalTo(279 / 2.0);
        
    }];
}

- (void)index4:(UIView *)bg{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"工具栏-密码\n\n密码是小秘针对用户安全信息存储是定的，用户可通过密码来记录私密信息。"]];
    UILabel *label = [self _createTitleLabel:bg text:str];;

    [self _createImage1WithWidth:picWidth height:580 / 2.0 top:25 image:@"用户说明_index4" label:label superView:bg];
    
}

- (void)index5:(UIView *)bg{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"工具栏-择吉\n\n择吉可以帮助您推算出一年中有多少日子适合举行何种仪式，例如婚丧嫁娶等。"]];
    UILabel *label = [self _createTitleLabel:bg text:str];;
    
    [self _createImage1WithWidth:picWidth height:407 / 2.0 top:25 image:@"用户说明_index5" label:label superView:bg];
}

- (void)index6:(UIView *)bg{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"个人中心放置在日历页左上角，包含“个人信息、收藏、相册、换肤、设置”五个功能。"]];
    UILabel *label = [self _createTitleLabel:bg text:str];;
    
    [self _createImage1WithWidth:picWidth height:888 / 2.0 top:25 image:@"用户说明_index6" label:label superView:bg];
}

- (void)index7:(UIView *)bg{

   NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"通话时闹钟能否不发出声音？\n\n由于"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"{iOS系统限制}" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
     [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"，所有通知都会在通话时发出声音，包括系统短信，给您带来不便，我们深感歉意。"]];
    [self _createTitleLabel:bg text:str];;

}

- (void)index8:(UIView *)bg{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"关机是否能正常响铃？\n\n由于"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"{iOS系统限制}" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"，关机后，手机所有功能无法使用。\n\n您可以"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"{开启飞行模式}" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"，在飞行模式下，小秘闹钟可以正常响铃，并且也可以减少手机辐射。"]];
    
    UILabel *label = [self _createTitleLabel:bg text:str];;
    [self _createImage1WithWidth:picWidth height:421 / 2.0 top:25 image:@"用户说明_index8" label:label superView:bg];
}

- (UIImageView *)_createImage1WithWidth:(CGFloat )width
                        height:(CGFloat )height
                           top:(CGFloat )top
                         image:(NSString *)image
                         label:(UILabel *)label
                     superView:(UIView *)superView
{
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:image];
    [superView addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(top);
        make.centerX.equalTo(superView.mas_centerX);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        
    }];
    
    return imageV;
}

- (UILabel *)_createTitleLabel:(UIView *)bgView text:(NSAttributedString *)text
{
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.attributedText = text;
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(25.f);
        make.left.equalTo(bgView.mas_left).offset(25.f);
        make.right.equalTo(bgView.mas_right).offset(-25.f);
    }];
    

    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
