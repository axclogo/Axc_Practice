//
//  AxcQrCodeMaskView.h
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGRect (^AxcLayoutBlock )(void);


@interface AxcQrCodeMaskView : UIView

@property(nonatomic , copy)AxcLayoutBlock layoutBlock;

/** 装饰Layer */
@property(nonatomic , strong)CAShapeLayer *decorationLayer;

/** 角边长 默认20 */
@property(nonatomic , assign)CGFloat sideLength;

/** 开始扫描动画 */
- (void)startTimer;

@end

NS_ASSUME_NONNULL_END
