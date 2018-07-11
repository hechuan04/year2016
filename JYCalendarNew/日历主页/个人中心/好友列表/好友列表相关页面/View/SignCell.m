//
//  SignCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SignCell.h"
#define kDescWidth 80.f

@implementation SignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        
        _signDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _signDescLabel.text = @"个性签名";
        _signDescLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_signDescLabel];
        
        _signContentLabel = [[UILabel alloc]init];
        _signContentLabel.textColor = [UIColor lightGrayColor];
        _signContentLabel.numberOfLines = 0;
        _signContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        _signContentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_signContentLabel];
        
    }
    return  self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
   
    _signDescLabel.frame = CGRectMake(15, 0, kDescWidth, 60);
    _signContentLabel.frame = CGRectMake(35+kDescWidth, 0, width-kDescWidth-50, height);
   
}

+ (CGFloat)heightForSign:(NSString *)sign
{
    if(!sign||[sign isEqualToString:@""]){
        return 60;
    }
    
    CGRect rect = [sign boundingRectWithSize:CGSizeMake(kScreenWidth-kDescWidth-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} context:nil];
    return MAX(60.f, rect.size.height+40);
}

@end
