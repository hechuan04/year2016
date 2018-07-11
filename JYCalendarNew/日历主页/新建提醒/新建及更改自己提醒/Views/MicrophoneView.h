//
//  MicrophoneView.h
//  RecordDemo
//
//  Created by Gaolichao on 16/5/5.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class MicrophoneView;

@protocol MicrophoneViewDelegate<NSObject>

/**
 *  录音结束回调
 *
 *  @param microponeView MicrophoneView
 *  @param path          录音保存路径
 *  @param duration      录音时长(秒)
 */
- (void)microphoneViewDidFinishRecording:(MicrophoneView *)microponeView audioPath:(NSString *)path duration:(CGFloat)duration;

@end

@interface MicrophoneView : UIView<AVAudioRecorderDelegate>

@property (nonatomic,strong) UIButton *recordButton;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,assign) CGFloat ratio;
@property (nonatomic,readonly) BOOL isRecording;

//@property (nonatomic,assign) NSInteger voiceLimitCount;//可录音限制数量

@property (nonatomic,weak) id<MicrophoneViewDelegate> delegate;


@end
