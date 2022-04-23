//
//  XZCameraHeader.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#ifndef XZCameraHeader_h
#define XZCameraHeader_h

#import "UIView+XZAdditions.h"

#define XZAPPLICATIONFRAME [[UIScreen mainScreen]bounds]//程序可用窗口frame（不含状态栏）
#define SCREEN_WIDTH XZAPPLICATIONFRAME.size.width //屏幕宽度
#define SCREEN_HEIGHT XZAPPLICATIONFRAME.size.height //屏幕高度
// 判断iPhone X
#define IS_IPHONEX ((([[UIScreen mainScreen] bounds].size.height-812)>=0)?YES:NO)
#define kSaveTopSpace       (IS_IPHONEX ? 24.0f : 0)   // iPhone X顶部多出的距离（刘海）
#define kSaveBottomSpace    (IS_IPHONEX ? 34.0f : 0)   // iPhone X底部多出的距离

#define WS(wSelf,self)  __weak typeof(self) wSelf = self
#define SS(sSelf,wSelf) __strong typeof(wSelf) sSelf = wSelf


#define XZRGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define XZRGBACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif /* XZCameraHeader_h */
