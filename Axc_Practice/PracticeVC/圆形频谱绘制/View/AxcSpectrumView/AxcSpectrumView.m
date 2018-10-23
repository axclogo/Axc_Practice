//
//  AxcSpectrumView.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/23.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "AxcSpectrumView.h"

const float kAxcTimerDelay = 1/60.0; // 改变这个，或多或少地绘制
const UInt32 kAxcMaxFrames = 2048;
const Float32 kAxcAdjust0DB = 1.5849e-13;

@interface AxcSpectrumView (){
    size_t bufferCapacity;
    size_t index;
    float sampleRate;
    float *dataBuffer;
    COMPLEX_SPLIT A;
    int log2n, n, nOver2;
    FFTSetup fftSetup;
}

@property(nonatomic , strong)NSMutableArray *buffer_3;
@property(nonatomic , strong)NSMutableArray *buffer_4;

@end
@implementation AxcSpectrumView
#pragma mark - init&ParentClass
- (instancetype)init{
    self = [super init];
    if (self) [self configuration];
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) [self configuration];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) [self configuration];
    return self;
}
#pragma mark - 初始化参数
- (void)configuration{
    self.maxFrequency = 10000;
    self.minFrequency = 1200;
    self.gravity = 10*kAxcTimerDelay;
    self.spectrumNum = 50;
    self.levelCoefficient = 4.f;
    self.drawRadius = 50;
    self.gain = 10;

    // ftt 设置
    bufferCapacity = kAxcMaxFrames;
    index = 0;
    // 配置音频会话
    dataBuffer = (float*)malloc(kAxcMaxFrames * sizeof(float));
    AVAudioSession *session = [AVAudioSession sharedInstance];
    sampleRate = session.sampleRate;
    // 分割点
    log2n = log2f(kAxcMaxFrames);
    n = 1 << log2n;
    nOver2 = kAxcMaxFrames/2;
    A.realp = (float *)malloc(nOver2 * sizeof(float));
    A.imagp = (float *)malloc(nOver2 * sizeof(float));
    // fft
    fftSetup = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    self.style = AxcSpectrumViewSytleBuffer;
    self.buffer_3 = @[].mutableCopy;
    self.buffer_4 = @[].mutableCopy;
}
#pragma mark - 重载
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bufferLayer.frame = self.bounds;
    self.bufferInternalLayer.frame = self.bounds;
}
- (void)updateBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize {
    [self setSampleData:buffer length:bufferSize];
}
#pragma mark 更新 Buffers
- (void)setSampleData:(float *)data
               length:(int)length {
    NSMutableArray *buffers_1 = @[].mutableCopy;
    NSMutableArray *buffers_2 = @[].mutableCopy;

    // 用采样数据填充缓冲区。如果我们填满缓冲区，运行fft。
    int inNumberFrames = length;
    int read = (int)(bufferCapacity - index);
    if (read > inNumberFrames) {
        memcpy((float *)dataBuffer + index, data, inNumberFrames*sizeof(float));
        index += inNumberFrames;
    } else {
        memcpy((float *)dataBuffer + index, data, read*sizeof(float));
        // 重置标记
        index = 0;
        // fft
        vDSP_ctoz((COMPLEX*)dataBuffer, 2, &A, 1, nOver2);
        vDSP_fft_zrip(fftSetup, &A, 1, log2n, FFT_FORWARD);
        vDSP_ztoc(&A, 1, (COMPLEX *)dataBuffer, 2, nOver2);
        // 转换为 dB分贝
        Float32 one = 1, zero = 0;
        vDSP_vsq(dataBuffer, 1, dataBuffer, 1, inNumberFrames);
        vDSP_vsadd(dataBuffer, 1, &kAxcAdjust0DB, dataBuffer, 1, inNumberFrames);
        vDSP_vdbcon(dataBuffer, 1, &one, dataBuffer, 1, inNumberFrames, 0);
        vDSP_vthr(dataBuffer, 1, &zero, dataBuffer, 1, inNumberFrames);
        
        float mul = (sampleRate/bufferCapacity)/2;
        int minFrequencyIndex = self.minFrequency/mul;
        int maxFrequencyIndex = self.maxFrequency/mul;
        int numDataPointsPerColumn = (maxFrequencyIndex-minFrequencyIndex)/self.spectrumNum;
        float maxHeight = 0;
        float internalMaxHeight = 0;

        for(NSUInteger i=0;i<self.spectrumNum;i++) {
            // 计算新柱高
            float avg = 0;
            vDSP_meanv(dataBuffer+minFrequencyIndex+i*numDataPointsPerColumn, 1, &avg, numDataPointsPerColumn);
            CGFloat columnHeight = MIN(avg*self.gain, CGRectGetHeight(self.bounds));
//            maxHeight = MAX(maxHeight, columnHeight);
            maxHeight = columnHeight;
                if (i < self.spectrumNum/2) { // 这块得自己调
                    CGFloat showSolumnHeight = columnHeight/self.levelCoefficient;
                    [buffers_1 addObject:@(showSolumnHeight)]; // 除以系数
                    [buffers_2 addObject:@(showSolumnHeight/self.levelCoefficient)]; // 除以系数
                }else{
                    [buffers_1 addObject:@(fabs(columnHeight))];
                    [buffers_2 addObject:@(fabs(columnHeight)/2)];
                }
        }
        if (maxHeight > self.drawRadius) {
            maxHeight = self.drawRadius;
        }
        maxHeight = fabsf(maxHeight);
        internalMaxHeight = maxHeight;
        if (internalMaxHeight > self.drawRadius/2) {
            internalMaxHeight = (self.drawRadius/4);
        }
        
        [self.buffer_3 insertObject:@(maxHeight) atIndex:0];
        [self.buffer_4 insertObject:@(internalMaxHeight/2) atIndex:0];
        if (self.buffer_3.count > self.spectrumNum) {
            [self.buffer_3 removeLastObject];
            [self.buffer_4 removeLastObject];
        }
    }
    if (self.style == AxcSpectrumViewSytleBuffer) {
        if (!buffers_1.count) return;
        UIBezierPath *bezierPath = [AxcDrawPath AxcDrawCircularRadiationCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                        radius:self.drawRadius
                                                                   lineHeights:buffers_1
                                                                       outside:YES
                                                                    startAngle:-90
                                                                  openingAngle:0
                                                                     clockwise:NO];
        self.bufferLayer.path = bezierPath.CGPath;
        
        UIBezierPath *bezierPath2 = [AxcDrawPath AxcDrawCircularRadiationCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                         radius:self.drawRadius - 1
                                                                    lineHeights:buffers_2
                                                                        outside:NO
                                                                     startAngle:90
                                                                   openingAngle:0
                                                                      clockwise:NO];
        self.bufferInternalLayer.path = bezierPath2.CGPath;
    }else{
        UIBezierPath *bezierPath = [AxcDrawPath AxcDrawCircularRadiationCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                        radius:self.drawRadius
                                                                   lineHeights:self.buffer_3
                                                                       outside:YES
                                                                    startAngle:-90
                                                                  openingAngle:0
                                                                     clockwise:NO];
        self.bufferLayer.path = bezierPath.CGPath;
        
        UIBezierPath *bezierPath2 = [AxcDrawPath AxcDrawCircularRadiationCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                         radius:self.drawRadius - 1
                                                                    lineHeights:self.buffer_4
                                                                        outside:NO
                                                                     startAngle:90
                                                                   openingAngle:0
                                                                      clockwise:NO];
        self.bufferInternalLayer.path = bezierPath2.CGPath;
        
    }
    
}
#pragma mark - 懒加载
- (CAShapeLayer *)bufferLayer{
    if (!_bufferLayer) {
        _bufferLayer = [CAShapeLayer new];
        _bufferLayer.lineWidth = 2;
        _bufferLayer.strokeColor = KScienceTechnologyBlue.CGColor;
        [self.layer addSublayer:_bufferLayer];
    }
    return _bufferLayer;
}
- (CAShapeLayer *)bufferInternalLayer{
    if (!_bufferInternalLayer) {
        _bufferInternalLayer = [CAShapeLayer new];
        _bufferInternalLayer.lineWidth = 2;
        _bufferInternalLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_bufferInternalLayer];
    }
    return _bufferInternalLayer;
}

//#pragma mark - 内存释放
//- (void)freeBuffersIfNeeded {
//    if (heightsByFrequency) {free(heightsByFrequency);}
//    if (speeds) {free(speeds);}
//    if (times) {free(times);}
//    if (tSqrts) {free(tSqrts);}
//    if (vts) {free(vts);}
//    if (deltaHeights) {free(deltaHeights);}
//}

@end
