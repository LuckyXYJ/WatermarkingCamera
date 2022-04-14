//
//  XZCustomCameraBotton.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import "XZCustomCameraBotton.h"
#import "XZCameraHeader.h"

@interface XZCustomCameraBotton()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;

@end
 
@implementation XZCustomCameraBotton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageName:(NSString *)imageName isBig:(BOOL)isBig {
    
    if (self = [super initWithFrame:frame]) {
        [self configButtonWithFrame:frame withTitle:title imageName:imageName isBig:isBig];
    }
    return self;
}

- (void)configButtonWithFrame:(CGRect)frame withTitle:(NSString *)title imageName:(NSString *)imageName isBig:(BOOL)isBig {
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = title;
    nameLabel.textColor = XZRGBCOLOR(0xFFFFFF);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:imageName];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconView];
    _iconView = iconView;
    
    
    iconView.frame = CGRectMake((frame.size.width - (isBig?66:30))/2, isBig?0:15, isBig?66:30, isBig?66:30);
    
    nameLabel.frame = CGRectMake(0, isBig?76:38, frame.size.width, 18);
}

- (void)changeImage:(NSString *)imageName {
    _iconView.image = [UIImage imageNamed:imageName];
}

@end
