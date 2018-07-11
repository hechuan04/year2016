//
//  ScanDirectoryCell.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/16.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanDirectoryCell.h"
#import "Masonry.h"
#import "ScanUtil.h"
#import "UIImageView+WebCache.h"

@implementation ScanDirectoryCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        
        _countInfoView = [UIButton new];
        [_countInfoView setTitle:@"15" forState:UIControlStateNormal];
        _countInfoView.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        _countInfoView.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_countInfoView setBackgroundImage:[UIImage imageNamed:@"文件夹标识"] forState:UIControlStateNormal];
        [self.contentView addSubview:_countInfoView];
        
        [_countInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.coverView.mas_right).offset(-5);
            make.bottom.equalTo(self.coverView.mas_bottom).offset(-5.f);
            make.width.greaterThanOrEqualTo(@(20.f));
            make.height.equalTo(@(20.f));
        }];
        
    }
    return self;
}

#pragma mark - Custom Accessors
- (void)setDirectory:(ScanDirectory *)directory
{
    _directory = directory;
    
    self.titleLabel.text = directory.name;
    self.dateLabel.text = [[ScanUtil sharedInstance].dateFormatterForDirectoryCell stringFromDate:directory.createdTime];
    [self.countInfoView setTitle:[NSString stringWithFormat:@"%ld",directory.fileCount] forState:UIControlStateNormal];
    
    if([directory.thumbUrlStr length]>0){
        
        self.coverView.contentMode = UIViewContentModeScaleAspectFill;
        
        if([directory.thumbUrlStr isEqualToString:@"<null>"]){
            
            self.coverView.image = [UIImage imageNamed:@"text_placeholder"];
        }else{
            
            [self.coverView sd_setImageWithURL:[NSURL URLWithString:directory.thumbUrlStr] placeholderImage:[UIImage imageNamed:@"相册默认图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //            if(!image){
                //                self.coverView.contentMode = UIViewContentModeScaleAspectFit;
                //            }
            }];
        }
    }else{
        self.coverView.contentMode = UIViewContentModeCenter;
        self.coverView.image = [UIImage imageNamed:@"扫描_空文件夹"];
    }
}

@end
