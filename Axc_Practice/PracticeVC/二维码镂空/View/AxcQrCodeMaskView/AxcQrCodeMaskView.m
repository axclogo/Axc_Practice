//
//  AxcQrCodeMaskView.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "AxcQrCodeMaskView.h"
@interface AxcQrCodeMaskView ()<CALayerDelegate>
@property(nonatomic , strong)CAShapeLayer *maskLayer;
@property(nonatomic , strong)CAShapeLayer *gridLayer;
@property(nonatomic , strong)CAGradientLayer *gradientLayer;
@property(nonatomic , strong)NSTimer *timer;
@property(nonatomic , assign)CGFloat location;
@property(nonatomic , assign)BOOL gradientLayerAnimationSwitch;
@end
@implementation AxcQrCodeMaskView
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
    self.sideLength =20;
    self.location = 0.1;
}
#pragma mark - SET
- (void)setLayoutBlock:(AxcLayoutBlock)layoutBlock{
    _layoutBlock = layoutBlock;
    [self layoutSubviews];
}
#pragma mark - 重载
- (void)layoutSubviews{
    [super layoutSubviews];
    self.maskLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(-1, -1, self.bounds.size.width+2, self.bounds.size.height+2)];
    CGRect hollowOutRect;
    if (self.layoutBlock){
        hollowOutRect = self.layoutBlock();
        [bezierPath appendPath:[UIBezierPath bezierPathWithRect:hollowOutRect]];
    }
    [bezierPath bezierPathByReversingPath];
    self.maskLayer.path = bezierPath.CGPath;
    // 设置装饰
    self.decorationLayer.frame = self.bounds;
    NSMutableArray *points = @[].mutableCopy;
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x, hollowOutRect.origin.y+self.sideLength)]];
    [points addObject:[NSValue valueWithCGPoint:hollowOutRect.origin]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+self.sideLength, hollowOutRect.origin.y)]];
    [points addObject:[NSNull null]]; // 左上角
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width-self.sideLength,
                                                            hollowOutRect.origin.y)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width,
                                                            hollowOutRect.origin.y)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width,
                                                            hollowOutRect.origin.y+self.sideLength)]];
    [points addObject:[NSNull null]]; // 右上角
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height-self.sideLength)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+hollowOutRect.size.width-self.sideLength,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height)]];
    [points addObject:[NSNull null]]; // 右下角
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x+self.sideLength,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(hollowOutRect.origin.x,
                                                            hollowOutRect.origin.y+hollowOutRect.size.height-self.sideLength)]];
    [points addObject:[NSNull null]]; // 左下角
    UIBezierPath *bezierPath_2 = [AxcDrawPath AxcDrawLineArray:points];
    self.decorationLayer.path = bezierPath_2.CGPath;
    // 网格扫描效果
    self.gridLayer.frame = self.bounds;
    UIBezierPath *bezierPath_3 = [AxcDrawPath AxcDrawRectangularGridRect:hollowOutRect gridCount:AxcAE_GridMake(50, 50)];
    self.gridLayer.path = bezierPath_3.CGPath;
    // 渐变
    self.gradientLayer.frame = self.bounds;
}

- (void)startTimer{
    CGFloat granularity = 0.005;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.location += granularity;
            self.gradientLayer.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1-self.location].CGColor ,
                                          (id)[[UIColor whiteColor] colorWithAlphaComponent:self.location].CGColor ];
        self.gradientLayer.locations = @[[NSNumber numberWithFloat:self.location],
                                         [NSNumber numberWithFloat:self.location]];
        if (self.location > 1) {
            self.location = -0.5;
        }
    }];
}
- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event{
    return [NSNull null];
}

#pragma mark - 懒加载
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
        _gradientLayer.delegate = self;
        self.gridLayer.mask = _gradientLayer;
    }
    return _gradientLayer;
}
- (CAShapeLayer *)gridLayer{
    if (!_gridLayer) {
        _gridLayer = [CAShapeLayer new];
        _gridLayer.lineWidth = 0.5;
        _gridLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_gridLayer];
    }
    return _gridLayer;
}
- (CAShapeLayer *)decorationLayer{
    if (!_decorationLayer) {
        _decorationLayer = [CAShapeLayer new];
        _decorationLayer.strokeColor = [UIColor whiteColor].CGColor;
        _decorationLayer.lineWidth = 5;
        _decorationLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_decorationLayer];
    }
    return _decorationLayer;
}
- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer new];
        _maskLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _maskLayer.strokeColor = [UIColor whiteColor].CGColor;
        _maskLayer.lineWidth = 1;
        _maskLayer.fillRule = kCAFillRuleEvenOdd; // 设置填充规则
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
