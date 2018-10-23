//
//  AxcSpectrumView.h
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/23.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import <EZAudio.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AxcSpectrumViewSytle) {
    AxcSpectrumViewSytleBuffer,
    AxcSpectrumViewSytleLevel,
};

@interface AxcSpectrumView : EZAudioPlot

// 默认 10000Hz
@property (nonatomic) float maxFrequency;

// 默认 1200Hz
@property (nonatomic) float minFrequency;

// 默认 10 pixel/s^2
@property (nonatomic) float gravity;

// 绘制Layer
@property(nonatomic , strong)CAShapeLayer *bufferLayer;
@property(nonatomic , strong)CAShapeLayer *bufferInternalLayer;

// 频谱数量 默认50
@property(nonatomic , assign)NSInteger spectrumNum;

// 电平数值系数 默认4
@property(nonatomic , assign)CGFloat levelCoefficient;

// 内圆半径 默认50
@property(nonatomic , assign)CGFloat drawRadius;

// 样式 默认AxcSpectrumViewSytleBuffer
@property(nonatomic , assign)AxcSpectrumViewSytle style;

@end

NS_ASSUME_NONNULL_END
