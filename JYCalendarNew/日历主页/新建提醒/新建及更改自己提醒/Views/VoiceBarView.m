//
//  VoiceBarView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/6.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "VoiceBarView.h"
#import <AVFoundation/AVFoundation.h>

#define kInitBarWidth 65.f
@interface VoiceBarView()<UIAlertViewDelegate>{
    NSInteger _animationCounter;
    NSInteger _voiceBarWidth;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) NSTimer *timer;

@end
@implementation VoiceBarView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviewsInRect:frame];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat speekerWidth = 15.f;
    CGFloat speekerHeight = 17.f;
    CGFloat deleteWidth = 15.f;
    CGFloat serialLabelHeight = 15.f;
    CGFloat serialLabelWidth = 35.f;
    
    _barView.frame = CGRectMake(0, 0, _voiceBarWidth,height);
    _speakerView.frame = CGRectMake(10,(height-speekerHeight)/2.f,speekerWidth,speekerHeight);
    _deleteButton.frame = CGRectMake(CGRectGetMaxX(_barView.frame)-deleteWidth,0,deleteWidth,deleteWidth);
    _serialLabel.frame = CGRectMake(CGRectGetMaxX(_barView.frame)+7.f,height-serialLabelHeight,serialLabelWidth,serialLabelHeight);
    _durationLabel.frame = CGRectMake(CGRectGetMaxX(_barView.frame)+7.f,0,serialLabelWidth,serialLabelHeight);
    _deleteButton.hidden = !self.canEdit;
}
- (void)dealloc
{
    NSLog(@"VoiceBarView===dealloc");
}
#pragma mark - Public

- (void)play
{
    if(!_isPalying){
        NSLog(@"=========%@",self.audio.relativePath);
        AVAudioSession*audioSession=[AVAudioSession sharedInstance];
        NSError*err=nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        if([self.delegate respondsToSelector:@selector(voiceBarBeginPlay:)]){
            [self.delegate voiceBarBeginPlay:self];
        }
        _isPalying = YES;
        [self.player play];
        self.timer.fireDate = [NSDate distantPast];
    }else{
        [self stop];
    }

   
}
- (void)stop
{
    if(_isPalying){
        self.speakerView.image = [UIImage imageNamed:@"voice3"];
        self.timer.fireDate = [NSDate distantFuture];
        if([self.delegate respondsToSelector:@selector(voiceBarEndPlay:)]){
            [self.delegate voiceBarEndPlay:self];
        }
        _isPalying = NO;
        [self removeObserverFromPlayerItem:self.player.currentItem];
        [self removeNotification];
        self.player = nil;
        self.playerItem = nil;
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];

    }
}

#pragma mark - Private
/**
 *  小喇叭播放动画
 */
- (void)speakerPlay
{
    _animationCounter++;
    if(_animationCounter>3){
        _animationCounter = 1;
    }
    self.speakerView.image = [UIImage imageNamed:[NSString stringWithFormat:@"voice%ld",_animationCounter]];
}
- (void)deleteButtonClicked:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否确认删除该条录音?" message:@""delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)setupSubviewsInRect:(CGRect)rect
{
    _voiceBarWidth = kInitBarWidth;
    _barView = [[UIView alloc]init];
    _barView.backgroundColor = [UIColor colorWithRGBIntRed:255 green:105 blue:98];
    _barView.layer.cornerRadius = 3.f;
    _barView.layer.masksToBounds = YES;
    
    [self addSubview:_barView];
    _barView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
    [_barView addGestureRecognizer:tap];
    
    _speakerView = [[UIImageView alloc]init];
    _speakerView.image = [UIImage imageNamed:@"voice3"];
    _speakerView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_speakerView];
    
    _deleteButton = [[UIButton alloc]init];
    _deleteButton.layer.cornerRadius = 3.f;
    _deleteButton.layer.masksToBounds = YES;
    [_deleteButton setImage:[UIImage imageNamed:@"voice_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_deleteButton];

    _durationLabel = [[UILabel alloc]init];
    _durationLabel.font = [UIFont systemFontOfSize:13];
    _durationLabel.textColor = [UIColor colorWithRGBIntRed:255 green:105 blue:98];
//    _durationLabel.text = @"20''";
    [self addSubview:_durationLabel];
    
    _serialLabel = [[UILabel alloc]init];
//    _serialLabel.text = @"1/3";
    _serialLabel.font = [UIFont systemFontOfSize:10.f];
    _serialLabel.textColor = [UIColor colorWithRGBIntRed:179 green:179 blue:179];
    _serialLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_serialLabel];
    
}
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [self.player removeObserver:self forKeyPath:@"status"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if (object == self.player && [keyPath isEqualToString:@"status"]) {
//        if (self.player.status == AVPlayerStatusFailed) {
//            NSLog(@"AVPlayer Failed");
//        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
//        } else if (self.player.status == AVPlayerItemStatusUnknown) {
//            NSLog(@"AVPlayer Unknown");
//        }
//    }
    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem=object;
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerItemStatusReadyToPlay){
            NSLog(@"==========%f",CMTimeGetSeconds(self.playerItem.duration));
            NSLog(@"正在播放...，长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }else if (status == AVPlayerItemStatusFailed) {
            NSLog(@"------player item failed:%@",self.playerItem.error);
        }
    }else if(object == self.playerItem && [keyPath isEqualToString:@"loadedTimeRanges"]){
        AVPlayerItem *playerItem=object;
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        
    }
}
#pragma mark - Protocol
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        NSFileManager *manager = [NSFileManager defaultManager];
        if([manager fileExistsAtPath:self.audio.absolutePath]){
            NSError *error;
            [manager removeItemAtPath:self.audio.absolutePath error:&error];
            if(error){
                NSLog(@"删除录音文件失败！");
            }else{
                [self removeFromSuperview];
            }
        }
        if([self.delegate respondsToSelector:@selector(voiceBarDeleteButtonClicked:)]){
            [self.delegate voiceBarDeleteButtonClicked:self];
        }
    }
}

#pragma mark - Custom Accessors
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.35f target:self selector:@selector(speakerPlay) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)setSerialString:(NSString *)serialString
{
    _serialString = [serialString copy];
    self.serialLabel.text = serialString;
}
-(AVPlayer *)player{
    if (!_player) {
        _player=[AVPlayer playerWithPlayerItem:self.playerItem];
        _player.volume = 1;
        [self addObserverToPlayerItem:self.playerItem];
        [self addNotification];
        
    }
    return _player;
}
-(AVPlayerItem *)playerItem{
    
    if(!_playerItem){
        NSURL *url = nil;
        //寻址顺序：网络->绝对地址->相对地址
        if(self.audio.remoteUrlPath){
            url =[NSURL URLWithString:self.audio.remoteUrlPath];
        }
        if(!url&&self.audio.absolutePath){
            url = [NSURL fileURLWithPath:self.audio.absolutePath];
        }
        if(!url&&self.audio.relativePath){
            NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:self.audio.relativePath]];
        }
        _playerItem=[AVPlayerItem playerItemWithURL:url];
    }
    return _playerItem;
}
- (void)setAudio:(AudioModel *)audio
{
    _audio = audio;
    NSInteger duration = ceilf([audio.duration floatValue]);
    duration = MIN(duration, 60);
    self.durationLabel.text = [NSString stringWithFormat:@"%ld＂",duration];
    _voiceBarWidth = kInitBarWidth+2*duration;
//    [self setNeedsLayout];
}
@end
