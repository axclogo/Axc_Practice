//
//  AxcQrCodeView.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "AxcQrCodeView.h"

@implementation AxcQrCodeView
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
    self.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                AVMetadataObjectTypeEAN13Code,
                                AVMetadataObjectTypeEAN8Code,
                                AVMetadataObjectTypeCode128Code,
                                AVMetadataObjectTypeAztecCode];
    // 添加转屏监听通知
    [[NSNotificationCenter notificationCenter] addObserver:self
                                                  selector:@selector(previewOrientation:)
                                                      name:UIApplicationDidChangeStatusBarOrientationNotification
                                                    object:nil];
}
#pragma mark - 重载
- (void)layoutSubviews{
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
}
#pragma mark - 执行函数
- (void)startRunning {
    [self.session startRunning];
}
- (void)stopRunning {
    [self.session stopRunning];
}
// 屏幕翻转监听就会调用
- (void)previewOrientation:(NSNotification *)notification{
    [self changePreviewOrientation:[UIApplication sharedApplication].statusBarOrientation];
}
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (!self.previewLayer)  return;
    [CATransaction begin];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:{
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }break;
        case UIInterfaceOrientationLandscapeLeft:{
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }break;
        case UIDeviceOrientationPortrait:{
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        }break;
        case UIDeviceOrientationPortraitUpsideDown:{
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        }break;
        default: break;
    }
    [CATransaction commit];
}
#pragma mark - 代理回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        __weak typeof(self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(qrCodeView:captureOutput:didOutputMetadataObjects:fromConnection:)]) {
            [self.delegate qrCodeView:weakSelf captureOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection];
        }
        if ([self.delegate respondsToSelector:@selector(qrCodeView:result:)]) {
            AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
            [self.delegate qrCodeView:weakSelf result:obj.stringValue];
        }
    }
}
#pragma mark - SET
- (void)setMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes{
    _metadataObjectTypes = metadataObjectTypes;
    if ([_session canAddOutput:self.captureOutput]) {
        self.captureOutput.metadataObjectTypes = _metadataObjectTypes;
    }
}
#pragma mark - 懒加载
- (AVCaptureMetadataOutput *)captureOutput{
    if (!_captureOutput) {
        _captureOutput = [AVCaptureMetadataOutput new];
        [_captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _captureOutput;
}
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [AVCaptureSession new];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        if ([_session canAddInput:deviceInput]) {
            [_session addInput:deviceInput];
        }
        if ([_session canAddOutput:self.captureOutput]) {
            [_session addOutput:self.captureOutput];
            if (self.captureOutput.availableMetadataObjectTypes.count) {
                self.captureOutput.metadataObjectTypes = self.metadataObjectTypes;
            }
        }
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:_previewLayer];
    }
    return _previewLayer;
}
#pragma mark - 销毁
- (void)dealloc{
    [self stopRunning];
    [[NSNotificationCenter notificationCenter] removeObserver:self
                                                         name:UIApplicationDidChangeStatusBarOrientationNotification
                                                       object:nil];
}
@end
