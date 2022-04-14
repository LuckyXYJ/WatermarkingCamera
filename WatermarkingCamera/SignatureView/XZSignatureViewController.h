//
//  XZSignatureViewController.h
//  workers
//
//  Created by ios on 2020/12/26.
//  Copyright © 2020 cnabc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSignatureViewController : UIViewController

@property (copy, nonatomic) void (^imageBlock)(UIImage *img);

@end

NS_ASSUME_NONNULL_END
