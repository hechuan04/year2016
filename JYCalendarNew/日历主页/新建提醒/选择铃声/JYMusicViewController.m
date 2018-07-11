//
//  JYMusicViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/1.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYMusicViewController.h"
#import "MusicTableViewCell.h"

#import <AVFoundation/AVFoundation.h>


static NSString *strForMusicCell = @"strForMusicCell";

@interface JYMusicViewController ()

{
  
  @private  NSArray *_arrForMusic;
    AVAudioPlayer *_audioPlayer;
    
}

@end

@implementation JYMusicViewController

- (void)actionForLeft:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _arrForMusic = @[@"幻觉",@"科技",@"蓝调",@"女声",@"月光",@"别动",@"喂哎",@"无声"];
    _arrForMusic = @[@"科技",@"月光",@"电动",@"古筝",@"铃铛",@"小号",@"洋琴",@"无声"];
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    self.navigationItem.leftBarButtonItem = item;

    self.title = @"铃声选择";
    //创建tb
    [self _creatTableView];
    
}
- (void)dealloc
{
    _audioPlayer = nil;
}
- (void)_creatTableView
{
    
    _musicTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _musicTabelView.delegate = self;
    _musicTabelView.dataSource = self;
    [self.view addSubview:_musicTabelView];
    
    //注册单元格
    [_musicTabelView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:strForMusicCell];

    UIView *viewBg = [UIView new];
    viewBg.backgroundColor = [UIColor whiteColor];
    
    
    [_musicTabelView setTableFooterView:viewBg];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isClock) {
        return _arrForMusic.count - 1;
    }else{
        return _arrForMusic.count;
    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForMusicCell];
    
    if (!cell) {
        
        cell = [[MusicTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForMusicCell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    cell.musicLabel.text = _arrForMusic[indexPath.row];
    
    cell.musicSelect.hidden = YES;
    
    if (indexPath.row == _model.musicName - 1) {
        
        cell.musicSelect.hidden = NO;
        
    }else{
    
        cell.musicSelect.hidden = YES;
    }
    
    return cell;
    
}

//点击选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_audioPlayer.isPlaying){
        [_audioPlayer stop];
    }

    _model.musicName = (int )indexPath.row + 1;
    
    //选中即赋值
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row + 1 forKey:kDefaultMusic];
    [self.musicTabelView reloadData];
    
    NSString *musicName = [NSString stringWithFormat:@"%@-长",_arrForMusic[indexPath.row]];

    
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"mp3"];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error){
        NSLog(@"error:%@",error.localizedDescription);
    }
    
    [_audioPlayer prepareToPlay];
    
    [_audioPlayer play];
    
    _actionForMusicName((int)indexPath.row + 1);
    //JYLog(@"选择音乐");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 49;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
