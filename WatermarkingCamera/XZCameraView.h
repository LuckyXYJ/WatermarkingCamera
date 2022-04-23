//
//  XZCameraView.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import <UIKit/UIKit.h>
#import "XZCameraView.h"
#import <UIKit/UIKit.h>
#import "CustomCameraView.h"
#import "XZCustomCameraWaterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCameraView : UIView

@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, strong) CustomCameraView   *preview;
@property (nonatomic, strong) XZCustomCameraWaterView *waterView;

//@property (nonatomic, strong) JYBCustomCameraWaterView *editWaterView;

@property (nonatomic, assign) BOOL isSaveAlbum;

//- (void)p_config;
//- (void)p_configOverLayView;
//
//- (void)flashButtonClick:(void(^)(NSInteger flashModel))block;
//- (void)takePhotoButtonClick:(id )sender;
//- (void)retakeButtonClick:(id )sender;
//- (void)useImageButtonClick:(id )sender;


/// 录入发票 takePhotoButtonClick 后照片处理完成 调用
- (void)configPickerPhoto;


//@property (nonatomic, copy) RCTBubblingEventBlock onBack;
//
//@property (nonatomic, copy) RCTBubblingEventBlock onWaterSelect;
//
//@property (nonatomic, copy) RCTBubblingEventBlock onWaterEdit;
//
//@property (nonatomic, copy) RCTBubblingEventBlock onShare;
//
//@property (nonatomic, copy) RCTBubblingEventBlock onSubmit;


@end

NS_ASSUME_NONNULL_END
