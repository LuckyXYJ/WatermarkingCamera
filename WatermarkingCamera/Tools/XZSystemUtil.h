//
//  JYBSystemUtil.h
//  workers
//
//  Created by LuckyXYJ on 2023/3/2.
//  Copyright © 2018年 cnabc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZSystemUtil : NSObject

+ (void)saveImageToAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

+ (BOOL)cameraAuthority;

+ (void)showCameraAuthorityRequest:(NSString *)message withBlock:(void (^)(void))backBlock;
@end
