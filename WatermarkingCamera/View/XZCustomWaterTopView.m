//
//  XZCustomWaterTopView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import "XZCustomWaterTopView.h"
#import "UIView+XZAdditions.h"
#import "NSDictionary+XZAdditions.h"
#import "XZCameraHeader.h"
#import "NSDate+Utilities.h"

@interface XZCustomWaterTopView()

@property(nonatomic, strong)UIImageView *leftImageView; // 标题Icon

@property(nonatomic, strong)UIImageView *rightImageView; // 标题Icon
@property(nonatomic, strong)UILabel *titleLabel; // 标题
@property(nonatomic, strong)UILabel *subTitleLabel; // 标题
@property(nonatomic, strong)UIImageView *centerImageView; // 标题Icon


@property(nonatomic, strong)UIView *centerBgView;
@property(nonatomic, strong)UIView *leftBgView;
@property(nonatomic, strong)UILabel *leftLabel;
@property(nonatomic, strong)UILabel *rightLabel;
@end

@implementation XZCustomWaterTopView

- (instancetype)init{
    if(self = [super init]){
        [self ui_config];
    }
    
    return self;
}

- (void)ui_config {
    
    
}

- (void)showViewData:(NSDictionary *)dict {
    
    CGFloat scale = 1;//self.width/210;
    
    [self hideAllView];
    
//    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
//
//    Class targetClass = NSClassFromString(targetClassString);
//    id target = [[targetClass alloc] init];
//    SEL action = NSSelectorFromString(actionString);
//    [target performSelector:action withObject:rnParams]
    
    // 1 图标+标题； 2 居中标题  3 居中图标  4 上下双标题  5 左右双标题
    NSString *type = [dict xz_stringForKey:@"type"];
    
    if ([type isEqualToString:@"engineering"]) {
        
        self.height = 33*scale;
        self.backgroundColor = XZRGBCOLOR(0x3A79EF);
        self.leftImageView.image = [UIImage imageNamed:@"icon_water_title_icon"];
        self.leftImageView.frame = CGRectMake(8*scale, 9*scale, 16*scale, 16*scale);
        self.leftImageView.hidden = NO;
        
        self.rightImageView.image = [UIImage imageNamed:@"icon_water_right_icon"];
        self.rightImageView.frame = CGRectMake(self.width - 66*scale, 7*scale, 60*scale, 26*scale);
        self.rightImageView.hidden = NO;
        
        self.titleLabel.text = [dict xz_stringForKey:@"title"];
        self.titleLabel.frame = CGRectMake(29*scale, 0, self.width - 29*scale, self.height);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15*scale];
        self.titleLabel.hidden = NO;
    }else if ([type isEqualToString:@"warning"]) {
        
        self.height = 33*scale;
        self.backgroundColor = XZRGBCOLOR(0xFF6532);
        self.leftImageView.image = [UIImage imageNamed:@"icon_water_title_icon"];
        self.leftImageView.frame = CGRectMake(8*scale, 9*scale, 16*scale, 16*scale);
        self.leftImageView.hidden = NO;
        
        self.rightImageView.image = [UIImage imageNamed:@"icon_water_right_icon"];
        self.rightImageView.frame = CGRectMake(self.width - 66*scale, 7*scale, 60*scale, 26*scale);
        self.rightImageView.hidden = NO;
        
        self.titleLabel.text = [dict xz_stringForKey:@"title"];
        self.titleLabel.frame = CGRectMake(29*scale, 0, self.width - 29*scale, self.height);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15*scale];
        self.titleLabel.hidden = NO;
    }else if ([type isEqualToString:@"inspection"]) {
        self.height = 33*scale;
        self.backgroundColor = XZRGBCOLOR(0x008832);
        self.titleLabel.hidden = NO;
        self.titleLabel.text = [dict xz_stringForKey:@"title"];
        self.titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15*scale];
        
    }else if ([type isEqualToString:@"failed"]) {
        self.height = 68*scale;
        self.backgroundColor = [UIColor clearColor];
        self.centerImageView.image = [UIImage imageNamed:@"icon_water_failed"];
        self.centerImageView.frame = CGRectMake(10*scale, 8*scale, 60*scale, 60*scale);
        self.centerImageView.hidden = NO;
    }else if ([type isEqualToString:@"record"]) {
        self.height = 42*scale;
        self.backgroundColor = XZRGBCOLOR(0x3A79EF);
        self.titleLabel.text = [dict xz_stringForKey:@"title"];
        self.titleLabel.frame = CGRectMake(8*scale, 5*scale, self.width - 16*scale, 24*scale);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15*scale];
        self.titleLabel.hidden = NO;
        
        NSDictionary *data = [dict xz_dicForKey:@"data"];
        
        NSDate *date = [NSDate dateWithTimestampString:[data xz_stringForKey:@"date"]];
        if (!date) {
            date = [NSDate date];
        }
        NSString *time = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        self.subTitleLabel.text = time;
        self.subTitleLabel.frame = CGRectMake(8*scale, 26*scale, self.width - 16*scale, 15*scale);
        self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.subTitleLabel.font = [UIFont systemFontOfSize:12*scale];
        self.subTitleLabel.hidden = NO;
    }else if ([type isEqualToString:@"attendance"]) {
        
        self.height = 39*scale;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.centerBgView.frame = CGRectMake(10*scale, 5*scale, self.width - 20*scale, 34*scale);
        self.centerBgView.layer.cornerRadius = 6;
        self.centerBgView.layer.masksToBounds = YES;
        self.centerBgView.hidden = NO;
        
        self.leftBgView.frame = CGRectMake(5*scale, 3*scale, (self.width - 25*scale)/2.f, 28*scale);
        self.leftBgView.layer.cornerRadius = 6;
        self.leftBgView.layer.masksToBounds = YES;
        self.leftLabel.text = [dict xz_stringForKey:@"title"];
        self.leftLabel.frame = CGRectMake(0, 0, self.leftBgView.width, self.leftBgView.height);
        self.leftLabel.font = [UIFont boldSystemFontOfSize:15*scale];
        
        NSDictionary *data = [dict xz_dicForKey:@"data"];
        NSDate *date = [NSDate dateWithTimestampString:[data xz_stringForKey:@"date"]];
        if (!date) {
            date = [NSDate date];
        }
        NSString *time = [date stringWithFormat:@"HH:mm"];
        self.rightLabel.text = time;
        self.rightLabel.frame = CGRectMake((self.width - 25*scale)/2.f, 0, self.width/2.f, 34*scale);
        self.rightLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:20*scale];
    }

}

- (void)showType_engineering {
    CGFloat scale = self.width/210;
}

- (void)hideAllView {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
}

- (UIImageView *)leftImageView{
    if(!_leftImageView){
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc] init];
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UIImageView *)centerImageView{
    if(!_centerImageView){
        _centerImageView = [[UIImageView alloc] init];
        [self addSubview:_centerImageView];
    }
    return _centerImageView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.leftBgView addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [self.centerBgView addSubview:_rightLabel];
    }
    return _rightLabel;
}

- (UIView *)centerBgView {
    
    if (!_centerBgView) {
        _centerBgView = [[UILabel alloc]init];
        _centerBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_centerBgView];
    }
    return _centerBgView;
}

- (UIView *)leftBgView {
    if (!_leftBgView) {
        _leftBgView = [[UILabel alloc]init];
        _leftBgView.backgroundColor = XZRGBCOLOR(0x3A79EF);
        [self.centerBgView addSubview:_leftBgView];
    }
    return _leftBgView;
}

@end
