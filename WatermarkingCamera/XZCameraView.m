//
//  XZCameraView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import "XZCameraView.h"
#import "CustomCameraView.h"
#import <CoreMotion/CoreMotion.h>
#import <Photos/Photos.h>
//#import "ImageUtil.h"
//#import "AppDelegate+UI.h"
#import "AppDelegate.h"
#import "XZSystemUtil.h"
#import "XZCameraHeader.h"

#define CameraTopHeight (kSaveTopSpace + 64)
#define CameraBottowHeight (kSaveBottomSpace + 156)

#define CameraWidth SCREEN_WIDTH
#define CameraHeight (SCREEB_HEIGHT - CameraTopHeight - CameraBottowHeight)

@interface XZCameraView()<UIGestureRecognizerDelegate>

@property(nonatomic, assign)CGFloat cameraWidth;
@property(nonatomic, assign)CGFloat cameraHeight;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureSession* session;

@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

@property (nonatomic, strong) AVCaptureDevice             *device;

@property (nonatomic, strong) NSData                      *imageData;
@property (nonatomic, strong) UIImage                     *originalImage;
@property (nonatomic, strong) UIImage                     *watermarkImage;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property(nonatomic,assign)CGFloat beginGestureScale;

@property(nonatomic,assign)CGFloat effectiveScale;

@property(nonatomic, assign)BOOL isCameraRun;

@property(nonatomic, assign)BOOL isOpenDraw; // 开启绘制, 默认关闭

@property(nonatomic, assign)BOOL isResetMotion; // 重置重力传感器

@end

@implementation XZCameraView{
    BOOL isUsingFrontFacingCamera;
    NSInteger _index;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _index=0;
        [self p_config];
    }
    return self;
}



//(superview)
- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    NSLog(@"willMoveToSuperview ====== 1 ");
}

- (void)didMoveToSuperview {
 
    [super didMoveToSuperview];
    NSLog(@"didMoveToSuperview ====== 1 ");
}

//(window)
- (void)willmovetowindow:(nullable UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSLog(@"willMoveToWindow ====== 1 ");
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    NSLog(@"didMoveToWindow ====== 1 ");
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self stopCamera];
    NSLog(@"removeFromSuperview ====== 1 ");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSLog(@"layoutSubviews ====== 1 ");
}

- (void)runCamera {
    self.isCameraRun = YES;
    if (self.session) {
        
        [self.session startRunning];
    }
//    [self p_startMotionManager];
}

- (void)stopCamera {
    self.isCameraRun = NO;
    
    if (self.session) {
        [self.session stopRunning];
    }
//    [self p_stopMonotionManager];
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark private method
- (void)p_config{
    
    _isOpenDraw = NO;
    isUsingFrontFacingCamera = NO;
    
    [self p_initAVCaptureSession];
    [self p_configOverLayView];
    
    [self p_configWaterView];
    [self p_configGesture];
    
    [self p_configActions];
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
    if (![XZSystemUtil cameraAuthority]) {
        [XZSystemUtil showCameraAuthorityRequest:@"需要访问您的相机。\n请启用设置-隐私-相机" withBlock:^{
            // TODO:
            NSLog(@"无权限，返回");
        }];
        return;
    }
    [self runCamera];
}

- (void)p_configOverLayView {
    self.preview = [[CustomCameraView alloc] init];
    self.preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.preview.isOpenDraw = self.isOpenDraw;
    [self addSubview:self.preview];
    WS(wSelf, self);
    self.preview.waterViewTap = ^{
        [wSelf waterEditAction];
    };
    
    //设置闪关灯模式
    if(self.device.isFlashAvailable)
        [self.preview setFlashModel:self.device.flashMode];
    else{
        self.preview.flashButton.hidden = YES;
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CameraTopHeight - CameraBottowHeight);
    [self.preview.videoPreView.layer addSublayer:self.previewLayer];
    
}

- (void)p_configWaterView {
    _waterView = [[XZCustomCameraWaterView alloc]init];
    _waterView.frame = CGRectMake(10, SCREEN_HEIGHT - CameraBottowHeight - 124, 210, 114);
    WS(wSelf, self);
    _waterView.waterViewTap = ^{
        [wSelf waterEditAction];
    };
    [self addSubview:_waterView];

}


- (void)p_initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
   
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
}

- (void)p_configGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.preview.videoPreView addGestureRecognizer:pinch];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(focusAction:)];
    [self.preview.videoPreView addGestureRecognizer:tap];
}

- (void)p_configActions{
    
    [self.preview.cameraSwitchButton addTarget:self action:@selector(switchCameraSegmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.takePictureButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.photoWaterButton addTarget:self action:@selector(waterSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.editWaterButton addTarget:self action:@selector(waterSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.cancelButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editBackButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editBackButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.nextStepButton addTarget:self action:@selector(nextStepMark:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.lastStepButton addTarget:self action:@selector(lastStepMark:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editShareButton addTarget:self action:@selector(shareImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editMarkButton addTarget:self action:@selector(clickMarkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editSaveButton addTarget:self action:@selector(saveImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.editSubmitButton addTarget:self action:@selector(useImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)p_startMotionManager{
    _isResetMotion = YES;
    self.deviceOrientation = UIDeviceOrientationPortrait;
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        __weak typeof(self) weakSelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [weakSelf performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
    }
}

- (void)p_stopMonotionManager{
    _isResetMotion = YES;
    [_motionManager stopDeviceMotionUpdates];
}

- (void)handleDeviceMotion:(CMDeviceMotion *)motion {
    double x = motion.gravity.x;
    double y = motion.gravity.y;

    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            //Down
            if (self.deviceOrientation != UIDeviceOrientationPortraitUpsideDown || _isResetMotion) {
                self.deviceOrientation = UIDeviceOrientationPortraitUpsideDown;

                CGAffineTransform transform = CGAffineTransformIdentity;
                self.waterView.transform = CGAffineTransformTranslate(transform, SCREEN_WIDTH - WaterWidth - 20, -(CameraHeight - WaterHeight - 20));
                self.waterView.transform = CGAffineTransformRotate(self.waterView.transform, M_PI);
                _isResetMotion = NO;
            }
        }
        else{
            //Portrait
//            self.deviceOrientation = UIDeviceOrientationPortrait;
            
            if (self.deviceOrientation != UIDeviceOrientationPortrait || _isResetMotion) {
                self.deviceOrientation = UIDeviceOrientationPortrait;
                
                CGAffineTransform transform = CGAffineTransformIdentity;
                self.waterView.transform = CGAffineTransformTranslate(transform,0,0);
                self.waterView.transform = CGAffineTransformRotate(self.waterView.transform, 0);
                _isResetMotion = NO;
            }
        }
    }
    else
    {
        if (x >= 0){
            //Right
//            self.deviceOrientation = UIDeviceOrientationLandscapeRight;
            
            if (self.deviceOrientation != UIDeviceOrientationLandscapeRight || _isResetMotion) {
                self.deviceOrientation = UIDeviceOrientationLandscapeRight;
                
                CGAffineTransform transform = CGAffineTransformIdentity;
                self.waterView.transform = CGAffineTransformTranslate(transform, (CameraWidth - 20 - WaterWidth/2 - WaterHeight/2), WaterHeight/2 - WaterWidth/2);
                self.waterView.transform = CGAffineTransformRotate(self.waterView.transform, - M_PI_2 );
                _isResetMotion = NO;
            }
        }
        else{
            //Left
//            self.deviceOrientation = UIDeviceOrientationLandscapeLeft;
            
            if (self.deviceOrientation != UIDeviceOrientationLandscapeLeft || _isResetMotion) {
                self.deviceOrientation = UIDeviceOrientationLandscapeLeft;

                CGAffineTransform transform = CGAffineTransformIdentity;
                self.waterView.transform = CGAffineTransformTranslate(transform, - (WaterWidth/2 - WaterHeight/2), -(CameraHeight - WaterWidth/2 - WaterHeight/2 - 20));
                self.waterView.transform = CGAffineTransformRotate(self.waterView.transform, M_PI_2 );
                _isResetMotion = NO;
            }
        }
    }
}

#pragma mark Actions

- (void)focusAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.preview];
    CGPoint pointInsect = CGPointMake(location.x / self.width, location.y / self.height);
    
    [self.preview.focusView setCenter:location];
    self.preview.focusView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.preview.focusView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.preview.focusView.alpha = 0.0;
        }completion:^(BOOL finished) {
            self.preview.focusView.hidden = YES;
        }];
    }];
    
    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.device lockForConfiguration:&error])
        {
            if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.device setFocusPointOfInterest:pointInsect];
            }
            
            if([self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.device setExposurePointOfInterest:pointInsect];
                [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            
            [self.device unlockForConfiguration];
        }
    }

}

//切换镜头
- (void)switchCameraSegmentedControlClick:(id)sender {
    
    //NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    
    if (isUsingFrontFacingCamera){
        
        if(self.device.isFlashAvailable) self.preview.flashButton.hidden = NO;
        desiredPosition = AVCaptureDevicePositionBack;
        
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
        self.preview.flashButton.hidden = YES;
    }
    
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)flashButtonClick:(void(^)(NSInteger flashModel))block {
    
    NSLog(@"=================闪光灯");
    //修改前必须先锁定
    [self.device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
    
        AVCaptureFlashMode flashMode = (self.device.flashMode + 1)%3;
        [self.device setFlashMode:flashMode];
        [self.preview setFlashModel:flashMode];
    } else {

        NSLog(@"设备不支持闪光灯");
    }
    [self.device unlockForConfiguration];
}

- (CGFloat)photoRatio {
    return SCREEN_WIDTH / (SCREEN_HEIGHT - CameraTopHeight - CameraBottowHeight);
}


- (UIImage *)waterMarkImage:(UIImage *)originalImage {
    
    if (originalImage.size.width == 0.0 || originalImage.size.height == 0.0) return nil;

    UIImage *defaultImage = nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;

    CGSize newSize = CGSizeMake(originalImage.size.width/scale, originalImage.size.height/scale);
    
    
    UIImage *passSignatureImage = [self.preview.imagePreiew.signatureView markImage];
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [originalImage drawInRect:CGRectMake(0, 0.0, newSize.width, newSize.height)];
    
    [passSignatureImage drawInRect:CGRectMake(0, 0.0, newSize.width, newSize.height)];
    
    if (originalImage.size.width < originalImage.size.height) {
        
        
        CGFloat scale1 = (newSize.width / SCREEN_WIDTH);
        CGFloat space = 10 * scale1;
        UIImage *waterMarkImage1 = [self jyb_imageByRenderingView:self.preview.imagePreiew.waterView withScale:scale1];
        [waterMarkImage1 drawInRect:CGRectMake(space, newSize.height - waterMarkImage1.size.height - space, waterMarkImage1.size.width, waterMarkImage1.size.height)];
        
    }else {
        
        CGFloat scale1 = (newSize.height / SCREEN_WIDTH);
        CGFloat space = 10 * scale1;
        UIImage *waterMarkImage1 = [self jyb_imageByRenderingView:self.preview.imagePreiew.waterView withScale:scale1];
        [waterMarkImage1 drawInRect:CGRectMake(space, newSize.height - waterMarkImage1.size.height - space, waterMarkImage1.size.width, waterMarkImage1.size.height)];
    }

    
    CGContextRestoreGState(context);
    
    defaultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return defaultImage;
}

- (UIImage *)jyb_imageByRenderingView:(UIView *)view withScale:(CGFloat)scale {
    CGFloat oldAlpha = view.alpha;
    view.alpha = 1;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width*scale, view.bounds.size.height*scale) , NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.alpha = oldAlpha;
    return resultingImage;
}

- (UIImage *)originalImageFixed:(UIImage *)originalImage {
    
    if (originalImage.size.width == 0.0 || originalImage.size.height == 0.0) return nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if(scale >= 3) scale = 2;
    
    CGFloat originalImageH = 0;
    CGFloat originalImageW = 0;
    
    //判断是否是横拍
    if (originalImage.size.width < originalImage.size.height) {
        
        //更宽。需要切割宽度
        originalImageH = originalImage.size.height;
        originalImageW = [self photoRatio] * originalImageH;

        originalImage = [self croppedImage:originalImage rect:CGRectMake(0, (originalImage.size.width-originalImageW)/2, originalImageH, originalImageW)];
    }else {
        originalImageW = originalImage.size.width;
        originalImageH = [self photoRatio] * originalImageW;
        originalImage = [self croppedImage:originalImage rect:CGRectMake(0, (originalImage.size.height-originalImageH)/2, originalImageW, originalImageH)];
    }
    return originalImage;
}

// 图片切割
- (UIImage *)croppedImage:(UIImage *)image rect:(CGRect )rect {
    if (image)
    {
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRectMake(0, 1000, rect.size.width, rect.size.height), subImageRef);
        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef scale:0 orientation:image.imageOrientation];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        return viewImage;
    }
    
    return nil;
}

- (void)takePhotoButtonClick:(id)sender {
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:self.deviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    __weak typeof(self) weakSelf = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        weakSelf.imageData = jpegData;
        UIImage *image = [UIImage imageWithData:jpegData];
        weakSelf.originalImage = [weakSelf originalImageFixed:image];
        [weakSelf changeEditStatus];
    }];
}

- (void)changeEditStatus {
    [self stopCamera];
    
    [self.preview changeImageViewFrameIfNeeded:self.deviceOrientation];
    [self.preview showPreEditImage:self.originalImage];
    [self.preview changeViewStatus:JYBCameraPreviewStatusEdit];
    
    self.waterView.hidden = YES;
}

/// 返回按钮
/// @param sender 返回
- (void)backButtonClick:(id )sender{
    if (_onBack) {
        _onBack(@{});
    }
}

/// 重新拍摄
/// 返回拍摄状态，重置标记按钮状态，清空绘制内容
/// @param sender sender description
- (void)retakeButtonClick:(id )sender{
    NSLog(@"重新拍摄");
    [self runCamera];
    [self.preview changeViewStatus:JYBCameraPreviewStatusCustom];
    
    
    self.isOpenDraw = NO;
    self.preview.isOpenDraw = self.isOpenDraw;
    self.waterView.hidden = NO;
}

/// 水印按钮
/// @param sender 水印
- (void)waterSelectButton:(id)sender {
    NSLog(@"水印按钮");
    if (_onWaterSelect) {
        _onWaterSelect(@{});
    }
}

/// 水印编辑事件
- (void)waterEditAction {
    NSLog(@"水印编辑按钮");
    if (_onWaterEdit) {
        _onWaterEdit(@{});
    }
}

/// 标记按钮
/// @param sender sender description
- (void)clickMarkButton:(id)sender {
    
    self.isOpenDraw = !self.isOpenDraw;
    self.preview.isOpenDraw = self.isOpenDraw;
}

/// 标记 -- 上一笔
/// @param sender sender
- (void)lastStepMark:(id)sender {
    
    [self.preview undoLastDraw];
}

/// 标记 -- 下一笔
/// @param sender sender
- (void)nextStepMark:(id)sender {
    [self.preview redoLastDraw];
}

/// 分享
/// @param sender 分享按钮
- (void)shareImageButton:(id)sender {
    NSLog(@"分享");
    
    if (_onShare) {
        UIImage *image = [self waterMarkImage:self.originalImage];
        
        NSString *originalImagePath = [ImageUtil getImageFilePath:self.originalImage];
        NSString *waterMarkImagePath = [ImageUtil getImageFilePath:image];
        
        double currentTime =  [[NSDate date] timeIntervalSince1970];
        NSString *strTime = [NSString stringWithFormat:@"%.0f000",currentTime];
        
        NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
        [response setObject:originalImagePath forKey:@"originalPath"];
        [response setObject:waterMarkImagePath forKey:@"uri"];
        [response setObject:waterMarkImagePath forKey:@"path"];
        [response setObject:strTime forKey:@"lastModified"];
        
        _onShare(response);
    }
}

/// 保存按钮
/// @param sender savebutton
- (void)saveImageButton:(id)sender {
    NSLog(@"保存");
    
    UIImage *image = [self waterMarkImage:self.originalImage];

    // 这里放异步执行任务代码
    WS(wSelf, self);
    [JYBCameraTool jyb_saveImage:image completionHandle:^(NSError *error, NSString *localIdentifier) {
        if (error) {
            [wSelf jyb_showToastWithText:@"保存失败，请确认是否开启相册权限"];
        } else {
            [wSelf jyb_showCompleteHud:@"保存成功"];
        }
    }];
}

- (void)useImageButtonClick:(id )sender{
    if (_onSubmit) {
        
        UIImage *image = [self waterMarkImage:self.originalImage];
        
        NSString *originalImagePath = [ImageUtil getImageFilePath:self.originalImage];
        NSString *waterMarkImagePath = [ImageUtil getImageFilePath:image];
        
        double currentTime =  [[NSDate date] timeIntervalSince1970];
        NSString *strTime = [NSString stringWithFormat:@"%.0f000",currentTime];
        
        NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
        [response setObject:originalImagePath forKey:@"originalPath"];
        [response setObject:waterMarkImagePath forKey:@"uri"];
        [response setObject:waterMarkImagePath forKey:@"path"];
        [response setObject:strTime forKey:@"lastModified"];
        
        _onSubmit(response);
    }
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.preview];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}


- (void)dealloc {
    
    NSLog(@"相机View 跑路了");
}

#pragma mark rn传参
- (void)setData:(NSDictionary *)data {
    
    [self.waterView showWaterWithDetail:data];
    [self.preview testWaterView:data];
}

- (void)setFromType:(NSInteger)type {
    [self.preview showPreEditFromType:type];
}

- (void)setResetCamera:(BOOL)reset {
    if (reset) {
        [self retakeButtonClick:[NSNull null]];
    }
}


@end
