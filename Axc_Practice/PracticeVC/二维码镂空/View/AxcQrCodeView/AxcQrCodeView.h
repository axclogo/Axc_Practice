//
//  AxcQrCodeView.h
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AxcQrCodeView;

@protocol AxcQrCodeViewDelegate <NSObject>

@optional
/**
 识别到二维码或者条形码回调
 @param qrCodeView 视图
 @param captureOutput 输出
 @param metadataObjects 对象类型
 @param connection 连接
 */
- (void)qrCodeView:(AxcQrCodeView *)qrCodeView
     captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
    fromConnection:(AVCaptureConnection *)connection;

/**
 直接获取扫描结果
 @param qrCodeView 视图
 @param result 结果
 */
- (void)qrCodeView:(AxcQrCodeView *)qrCodeView
            result:(NSString *)result;

@end

@interface AxcQrCodeView : UIView<AVCaptureMetadataOutputObjectsDelegate>
// 会话层
@property(nonatomic , strong)AVCaptureSession *session;
// 输出
@property(nonatomic , strong)AVCaptureMetadataOutput *captureOutput;
// Layer展示层
@property(nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;
// 扫描类型
@property(nonatomic, copy, null_resettable) NSArray<AVMetadataObjectType> *metadataObjectTypes;
// 代理
@property(nonatomic , weak)id <AxcQrCodeViewDelegate >delegate;

- (void)startRunning;

- (void)stopRunning;

@end

NS_ASSUME_NONNULL_END
