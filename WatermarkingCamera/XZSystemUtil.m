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

@end
