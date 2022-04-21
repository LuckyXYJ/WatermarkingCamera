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
#define XZSCREEN_WIDTH APPLICATIONFRAME.size.width //屏幕宽度
#define XZSCREEN_HEIGHT APPLICATIONFRAME.size.height //屏幕高度

#define WS(wSelf,self)  __weak typeof(self) wSelf = self
#define SS(sSelf,wSelf) __strong typeof(wSelf) sSelf = wSelf


#define XZRGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define XZRGBACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif /* XZCameraHeader_h */
