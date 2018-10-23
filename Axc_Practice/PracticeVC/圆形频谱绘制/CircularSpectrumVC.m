//
//  CircularSpectrumVC.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/23.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "CircularSpectrumVC.h"
#import "AxcSpectrumView.h"
#import "AxcAudioPlayer.h"

@interface CircularSpectrumVC ()<EZAudioPlayerDelegate>
@property(nonatomic , strong)AxcSpectrumView *spectrumView;
@property(nonatomic , strong)AxcAudioPlayer *audioPlayer;
@property(nonatomic , assign)BOOL isPlayer;
@end

@implementation CircularSpectrumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    [self AxcBase_addBarButtonItem:AxcBaseBarButtonItemLocationRight title:@"播放/暂停" handler:^(UIButton *barItemBtn) {
        if (!self.isPlayer) {
            [self.audioPlayer play];
        }else{
            [self.audioPlayer pause];
        }
        self.isPlayer = !self.isPlayer;
    }];
    [self.spectrumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
        make.width.height.mas_equalTo(300);
    }];
}
#pragma mark - 代理回调
- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spectrumView updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

#pragma mark - 懒加载
- (AxcAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [AxcAudioPlayer new];
        _audioPlayer.delegate = self;
        _audioPlayer.fileName = @"觉醒.wav";
    }
    return _audioPlayer;
}
- (AxcSpectrumView *)spectrumView{
    if (!_spectrumView) {
        _spectrumView = [AxcSpectrumView new];
        _spectrumView.backgroundColor = kBackColor;
        _spectrumView.spectrumNum = 100;
//        [_spectrumView.bufferLayer addAnimation:[AxcCAAnimation AxcRotatingDuration:10] forKey:nil];
        [self.view addSubview:_spectrumView];
    }
    return _spectrumView;
}

@end
