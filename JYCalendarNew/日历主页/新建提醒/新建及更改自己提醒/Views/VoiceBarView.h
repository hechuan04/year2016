//
//  VoiceBarView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/6.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioModel.h"

@class VoiceBarView;

@protocol VoiceBarDelegate<NSObject>

- (void)voiceBarBeginPlay:(VoiceBarView *)bar;
- (void)voiceBarEndPlay:(VoiceBarView *)bar;
- (void)voiceBarDeleteButtonClicked:(VoiceBarView *)bar;

@end


@interface VoiceBarView : UIView

@property (nonatomic,strong) UIView *barView;//语音条
@property (nonatomic,strong) UIImageView *speakerView;//小喇叭
@property (nonatomic,strong) UIButton *deleteButton;//删除
@property (nonatomic,strong) UILabel *durationLabel;//时长
@property (nonatomic,strong) UILabel *serialLabel;//序号

@property (nonatomic,assign,readonly) BOOL isPalying;
@property (nonatomic,weak) id<VoiceBarDelegate> delegate;

@property (nonatomic,strong) AudioModel *audio;
@property (nonatomic,copy) NSString *serialString;//序号
@property (nonatomic,assign) BOOL canEdit;

- (void)play;
- (void)stop;

@end
