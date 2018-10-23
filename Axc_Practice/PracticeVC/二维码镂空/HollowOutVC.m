//
//  HollowOutVC.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "HollowOutVC.h"
#import "AxcQrCodeView.h"
#import "AxcQrCodeMaskView.h"


@interface HollowOutVC ()<AxcQrCodeViewDelegate>
// 扫码相机
@property(nonatomic , strong)AxcQrCodeView *qrCodeView;
// 遮罩视图
@property(nonatomic , strong)AxcQrCodeMaskView *qrCodeMaskView;

@end

@implementation HollowOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.qrCodeView.frame = self.view.bounds;
    self.qrCodeMaskView.frame = self.view.bounds;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.qrCodeView startRunning];
    [self settingScanningArea];
    [self.qrCodeMaskView startTimer];
}
// 设置扫描区
- (void)settingScanningArea{
     // 被动触发重置布局后
    __weak typeof(self)weakSelf = self;
    self.qrCodeMaskView.layoutBlock = ^CGRect{  // 镂空区
        CGRect mainRect = [UIScreen mainScreen].bounds;
        CGFloat mainRectWidth = mainRect.size.width;
        CGFloat mainRectHeight = mainRect.size.height;
        CGRect rect = CGRectMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3, 2*mainRectWidth/3, 2*mainRectWidth/3);
        
        CGRect interestRect = CGRectMake(rect.origin.x/mainRect.size.width,
                                         rect.origin.y/mainRect.size.height,
                                         rect.size.height/mainRect.size.height,
                                         rect.size.width/mainRect.size.width);//参照坐标是横屏左上角
        weakSelf.qrCodeView.captureOutput.rectOfInterest = interestRect; // 识别区
        
        return rect;
    };
}
#pragma mark - 回调代理
- (void)qrCodeView:(AxcQrCodeView *)qrCodeView result:(NSString *)result{
    [self.qrCodeView stopRunning];  // 停止
    [self AxcBase_popPromptAlentWithMsg:result handler:^(UIAlertAction *action) {
        [self.qrCodeView startRunning]; // 点击后继续
    }]; // 弹框
}
#pragma mark - 懒加载
- (AxcQrCodeMaskView *)qrCodeMaskView{
    if (!_qrCodeMaskView) {
        _qrCodeMaskView = [AxcQrCodeMaskView new];
        [self.view addSubview:_qrCodeMaskView];
    }
    return _qrCodeMaskView;
}
- (AxcQrCodeView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView = [AxcQrCodeView new];
        _qrCodeView.delegate = self;
        [self.view addSubview:_qrCodeView];
    }
    return _qrCodeView;
}

@end
