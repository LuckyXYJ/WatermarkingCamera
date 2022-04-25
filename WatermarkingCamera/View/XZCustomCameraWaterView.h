//
//  XZCustomCameraWaterView.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import <UIKit/UIKit.h>
#define WaterWidth 210
#define WaterHeight 114

typedef NS_ENUM(NSUInteger, JYBCameraWaterType) {
    JYBCameraWaterTypeProject, //项目
    JYBCameraWaterTypePatrol, //巡检
    JYBCameraWaterTypeAttendance, //考勤
    JYBCameraWaterTypeWork, //巡检
};


NS_ASSUME_NONNULL_BEGIN

@interface XZCustomCameraWaterView : UIView

@property(nonatomic, copy)void(^waterViewTap)(void);

- (void)showWaterWithDetail:(id)detail;

- (void)showWaterWithDetail:(id)detail isNormer:(BOOL)isNormer;

@end

NS_ASSUME_NONNULL_END
