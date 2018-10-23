//
//  AxcAudioPlayer.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/23.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "AxcAudioPlayer.h"

@implementation AxcAudioPlayer
#pragma mark - init&ParentClass
- (instancetype)init{
    self = [super init];
    if (self) [self configuration];
    return self;
}
- (void)configuration{
    
}

- (void)play{
    [self.player setAudioFile:self.audioFile];
    [self.player play];
}
- (void)pause{
    [self.player pause];
}
- (void)setDelegate:(id<EZAudioPlayerDelegate>)delegate{
    _delegate = delegate;
    self.player = [[EZAudioPlayer alloc] initWithDelegate:_delegate];
}
- (void)setFileName:(NSString *)fileName{
    _fileName = fileName;
    NSString *path = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    self.audioFile = [EZAudioFile audioFileWithURL:fileUrl];
}


@end
