//
//  WaveView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/6.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WaveView.h"
@interface WaveView()
@property (nonatomic,strong) NSMutableArray *waveViews;
@end
@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _waveViews = [NSMutableArray arrayWithCapacity:8];
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        CGFloat rowHeight = 5.f;
        CGFloat margin = (height-rowHeight*8)/7.f;
        for(int i=0;i<8;i++){
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0,i*(margin+rowHeight),width,5)];
            UIImage *image = [UIImage imageNamed:@"voice_wave"];
            iv.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
//            iv.image = image;
//            iv.contentMode = UIViewContentModeTopRight;
            iv.clipsToBounds = YES;
            [self addSubview:iv];
            width -= 3.f;
            [_waveViews addObject:iv];
        }
    }
    return self;
}
- (void)refreshWave:(CGFloat)ratio
{
    //正常思路反应不够灵敏
//    int maxRatio = floor(ratio*[self.waveViews count]);
//    NSLog(@"------%d",maxRatio);
//    for(int i=0;i<[self.waveViews count];i++){
//        UIImageView *iv = self.waveViews[i];
//        iv.hidden = [self.waveViews count]-i>=maxRatio;
//    }
    
    ((UIImageView *)self.waveViews[0]).hidden = ratio<0.95;
    ((UIImageView *)self.waveViews[1]).hidden = ratio<0.9;
    ((UIImageView *)self.waveViews[2]).hidden = ratio<0.87;
    ((UIImageView *)self.waveViews[3]).hidden = ratio<0.82;
    ((UIImageView *)self.waveViews[4]).hidden = ratio<0.8;
    ((UIImageView *)self.waveViews[5]).hidden = ratio<0.75;
    ((UIImageView *)self.waveViews[6]).hidden = ratio<0.5;
    ((UIImageView *)self.waveViews[7]).hidden = ratio<=0;
}

- (void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    [self refreshWave:ratio];
}
@end
