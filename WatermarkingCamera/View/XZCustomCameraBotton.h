//
//  XZCustomCameraBotton.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZCustomCameraBotton : UIButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageName:(NSString *)imageName isBig:(BOOL)isBig;

- (void)changeImage:(NSString *)imageName;


@end

NS_ASSUME_NONNULL_END
