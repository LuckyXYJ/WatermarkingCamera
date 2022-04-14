//
//  CustomCameraView.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XZCustomCameraBotton.h"
#import "XZCustomCameraEditImageView.h"

typedef NS_ENUM(NSUInteger, XZCameraPreviewStatus) {
    XZCameraPreviewStatusCustom, //默认
    XZCameraPreviewStatusEdit, //编辑状态
};

NS_ASSUME_NONNULL_BEGIN

@interface CustomCameraView : UIView

// 拍照状态顶部按钮
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *cameraSwitchButton;

// 拍照状态底部按钮
@property (nonatomic, strong) UIButton *takePictureButton;
@property (nonatomic, strong) XZCustomCameraBotton *photoWaterButton;

// 编辑状态顶部按钮
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *lastStepButton;
@property (nonatomic, strong) UIButton *nextStepButton;

// 编辑状态底部按钮
@property (nonatomic, strong) XZCustomCameraBotton *editBackButton;
@property (nonatomic, strong) XZCustomCameraBotton *editWaterButton;
@property (nonatomic, strong) XZCustomCameraBotton *editShareButton;
@property (nonatomic, strong) XZCustomCameraBotton *editMarkButton;
@property (nonatomic, strong) XZCustomCameraBotton *editSaveButton;


// 业务跳转编辑状态底部按钮
@property (nonatomic, strong) UIButton *editSubmitButton;


// 聚焦按钮
@property (nonatomic, strong) UIImageView   *focusView;


@property (nonatomic, assign) BOOL      isHiddenFlashButtons;

/// 是否开启绘制，默认关闭
@property(nonatomic, assign)BOOL isOpenDraw;

@property (nonatomic, strong) UIView *videoPreView;

@property (nonatomic, strong) XZCustomCameraEditImageView *imagePreiew;

@property(nonatomic, copy)void(^waterViewTap)(void);

@property(nonatomic, copy)void(^clickFlashModel)(void);

- (void)setFlashModel:(AVCaptureFlashMode)mode;

- (void)changeViewStatus:(XZCameraPreviewStatus)stutus;

- (void)changeImageViewFrameIfNeeded:(UIDeviceOrientation)orientation;

- (void)showPreEditImage:(UIImage *)image;

- (void)showPreEditFromType:(NSInteger)type;
/**
 撤销上一步绘制
 */
- (void)undoLastDraw;

/**
 恢复上次撤销操作
 */
- (void)redoLastDraw;


- (void)testWaterView:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
