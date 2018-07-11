//
//  MicrophoneView.m
//  RecordDemo
//
//  Created by Gaolichao on 16/5/5.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "MicrophoneView.h"
#import "WaveView.h"
#import <AVFoundation/AVFoundation.h>
@interface MicrophoneView(){
    CGFloat _timeCounter;
}

@property (nonatomic,strong) UIView          *containerView;
@property (nonatomic,strong) UIImageView     *micView;
@property (nonatomic,strong) WaveView        *waveView;
@property (nonatomic,copy  ) NSString        *audioPath;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) NSTimer         *timer;//录音声波监控
@property (nonatomic,strong) NSDictionary    *audioSetting;//录音设置

@end

@implementation MicrophoneView

#pragma mark - Life Cycle
- (void)awakeFromNib
{
    [self setupSubviewsWithFrame:self.frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}
- (void)setupSubviewsWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat containerWidth = 175.f;
    CGFloat containerHeight = 175.f;
    CGFloat micWidth = 50.f;
    CGFloat micHeight = 70.f;
    CGFloat waveWidth =  30.f;
    CGFloat btnWidth = 130.f;
    CGFloat btnHeight = 35.f;
    CGFloat lblHeight = 20.f;
    
    _containerView = [[UIView alloc]initWithFrame:CGRectMake((width-containerWidth)/2.f,(height-containerHeight)/2.f,containerWidth,containerHeight)];
    _containerView.backgroundColor = [UIColor colorWithRGBIntRed:52 green:52 blue:52 alpha:0.6];
    _containerView.layer.cornerRadius = 5.f;
    _containerView.layer.masksToBounds = YES;
    [self addSubview:_containerView];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10.f,containerWidth,lblHeight)];
    _stateLabel.font = [UIFont systemFontOfSize:14.f];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.text = @"手指上划，取消录音";
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_stateLabel];

    _micView = [[UIImageView alloc]initWithFrame:CGRectMake(40.f,CGRectGetMaxY(_stateLabel.frame)+15.f,micWidth, micHeight)];
    _micView.image = [UIImage imageNamed:@"microphone"];
    _micView.contentMode = UIViewContentModeScaleAspectFit;
    [_containerView addSubview:_micView];
    
    _waveView = [[WaveView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_micView.frame)+15.f,_micView.frame.origin.y+10,waveWidth, micHeight-10)];
    [_containerView addSubview:_waveView];
    
    _recordButton = [[UIButton alloc]initWithFrame:CGRectMake((containerWidth-btnWidth)/2.f,(containerHeight-btnHeight)-10.f,btnWidth,btnHeight)];
    _recordButton.layer.cornerRadius = 5.f;
    _recordButton.layer.masksToBounds = YES;
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_recordButton setTitle:@"长按说话 (60秒内)" forState:UIControlStateNormal];
    _recordButton.backgroundColor = [UIColor colorWithRGBIntRed:242 green:242 blue:242];
    [_recordButton setTitleColor:[UIColor colorWithRGBIntRed:51 green:51 blue:51] forState:UIControlStateNormal];
    
    //按下button
    [_recordButton addTarget:self action:@selector(startRecordVoice:) forControlEvents:UIControlEventTouchDown];
    //button内抬起手
    [_recordButton addTarget:self action:@selector(confirmRecordVoice:) forControlEvents:UIControlEventTouchUpInside];

    //button外抬起手
    [_recordButton addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside];
    
    //移到button外
    [_recordButton addTarget:self action:@selector(recordButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    //移到button内
    [_recordButton addTarget:self action:@selector(recordButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    
    [_containerView addSubview:_recordButton];
    
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];

}
#pragma mark - Public

#pragma mark - Private

- (void)tapEvent:(UIGestureRecognizer *)recongnizer
{
    if(!self.isRecording){
        [self removeFromSuperview];
    }
}
- (void)startRecordVoice:(UIButton *)sender
{
//    if(self.voiceLimitCount<=0){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录音失败" message:@"已达录音条数上限（3条）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        return;
//    }
    self.stateLabel.text = @"手指上划，取消录音";
    sender.backgroundColor = [UIColor lightGrayColor];
    [self startRecord];
}

- (void)confirmRecordVoice:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRGBIntRed:242 green:242 blue:242];
//    if(_timeCounter<1){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录音失败" message:@"录音时间太短请重新录制！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        self.audioPath = nil;
//        [self endRecord];
//        return;
//    }
    [self endRecord];
    [self dismissAndReset];
}
- (void)cancelRecordVoice:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRGBIntRed:242 green:242 blue:242];
    [self cancelRecord];
    [self dismissAndReset];
}
- (void)recordButtonTouchDragExit:(UIButton *)sender
{
    self.stateLabel.text = @"松手取消录音";
}
- (void)recordButtonTouchDragEnter:(UIButton *)sender
{
    self.stateLabel.text = @"手指上划，取消录音";
}
- (void)dismissAndReset
{
    self.stateLabel.text = @"手指上划，取消录音";
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }

    [self removeFromSuperview];
    
}

//录音逻辑
- (void)startRecord
{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord  error:nil];
    NSError *error;
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if(!success){
        NSLog(@"error doing outputaudioportoverride - %@", [error localizedDescription]);
    }
    [audioSession setActive:YES error:nil];
    
    [self generateNewAudioRecorder];
    if(![self.audioRecorder isRecording]){
        [self.audioRecorder record];
         _isRecording = YES;
        self.timer.fireDate=[NSDate distantPast];
    }
}
- (void)endRecord
{
    self.ratio = 1;
    _timeCounter = 0;
    _isRecording = NO;
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    
}
- (void)cancelRecord
{
    [self endRecord];
    [self.audioRecorder deleteRecording];
    self.audioPath = nil;
}

- (void)generateNewAudioRecorder
{
    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSFileManager *fileManager=[NSFileManager defaultManager];
    path = [path stringByAppendingPathComponent:@"audio"];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",[formatter stringFromDate:date]]];
    self.audioPath = fullPath;
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    NSAssert(url!=nil, @"文件路径生成失败！");
    
    //创建录音机
    NSError *error=nil;
    _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:self.audioSetting error:&error];
    _audioRecorder.delegate=self;
    _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
    if (error) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
    }
    
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)audioSetting
{
    if(!_audioSetting){
        NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
        //设置录音格式
        [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        [dicM setObject:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [dicM setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [dicM setObject:@(NO) forKey:AVLinearPCMIsFloatKey];
        
        _audioSetting = [NSDictionary dictionaryWithDictionary:dicM];
    }
    return _audioSetting;
}
/**
 *  计时超过60秒停止录音
 */
- (void)increaseTime
{
    _timeCounter += 0.1;
    if(_timeCounter>=60){
        [self confirmRecordVoice:nil];
    }
}
/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self increaseTime];
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    self.ratio = progress;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:recorder.url options:nil];
    CMTime time = asset.duration;
    double durationInSeconds = CMTimeGetSeconds(time);
    
    if([self.delegate respondsToSelector:@selector(microphoneViewDidFinishRecording:audioPath:duration:)]){
        if(flag&&self.audioPath){
            [self.delegate microphoneViewDidFinishRecording:self audioPath:self.audioPath duration:durationInSeconds];
        }
    }

    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.audioPath error:nil] fileSize];
    NSLog(@"audioRecorderDidFinishRecording====%fkb====%f",fileSize/1024.f,durationInSeconds);

}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur=====%@",error.localizedDescription);
}

#pragma mark - Custom Accessors
- (void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    self.waveView.ratio = ratio;
//    NSLog(@"====%f",ratio);
}
/**
 *  录音声(波监控/计时)定时器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
