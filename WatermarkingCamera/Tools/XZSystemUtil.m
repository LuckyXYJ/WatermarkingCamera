//
//  JYBSystemUtil.m
//  workers
//
//  Created by  on 2018/9/13.
//  Copyright © 2018年 cnabc. All rights reserved.
//

#import "XZSystemUtil.h"
#import <Photos/Photos.h>

@implementation XZSystemUtil

+ (void)saveImageToAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
              switch ( status ) {
                  case PHAuthorizationStatusNotDetermined:
                  case PHAuthorizationStatusRestricted:
                  case PHAuthorizationStatusDenied: {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"需要访问您的照片。\n请启用设置-隐私-照片");
                      });
                  }
                      break;
                  case PHAuthorizationStatusAuthorized: {
                        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                               [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                           } completionHandler:completionHandler];
                  }
                      break;
                  default:
                      break;
              }
          }];
}

+ (BOOL)cameraAuthority {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            return NO;
        }
    }
    return YES;
}

+ (void)showCameraAuthorityRequest:(NSString *)message withBlock:(void (^)(void))backBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (backBlock) {
            backBlock();
        }
    }];
    [alert addAction:confirm];
    [[self topViewController] presentViewController:alert animated:true completion:nil];
}

+ (UIViewController *)topViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)rootVC).topViewController;
    }else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nav = ((UITabBarController *)rootVC).selectedViewController;
        return nav.topViewController;
    }else {
        return [[UIViewController alloc] init];
    }
}

@end
