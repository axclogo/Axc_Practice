//
//  AxcAudioPlayer.h
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/23.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import <EZAudio.h>

NS_ASSUME_NONNULL_BEGIN


@interface AxcAudioPlayer : NSObject
// 音频文件
@property(nonatomic , strong)EZAudioFile *audioFile;
// 播放器
@property(nonatomic , strong)EZAudioPlayer *player;
// 代理
@property(nonatomic , weak)id <EZAudioPlayerDelegate>delegate;
// 文件名称
@property(nonatomic , strong)NSString *fileName;


- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
