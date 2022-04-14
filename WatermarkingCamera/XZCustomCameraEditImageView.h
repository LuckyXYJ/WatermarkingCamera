//
//  XZCustomCameraEditImageView.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"
#import "XZCustomCameraWaterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCustomCameraEditImageView : UIView

@property(nonatomic, copy)void(^waterViewTap)(void);

@property (nonatomic, copy) void (^drawLineBlock)(BOOL showUndo, BOOL showRedo);

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) SignatureView *signatureView;
@property (nonatomic, strong) XZCustomCameraWaterView *waterView;

@property(nonatomic, assign)BOOL isOpenDraw;

- (void)changeImageViewFrameIfNeeded:(UIDeviceOrientation)orientation;

/**
 撤销上一步绘制
 */
- (void)undoLastDraw;

/**
 恢复上次撤销操作
 */
- (void)redoLastDraw;

/**
 清除所有操作
 */
- (void)clearSignature;


- (void)testWaterView:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
