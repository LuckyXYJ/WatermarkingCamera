//
//  XZCustomWaterContentView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import "XZCustomWaterContentView.h"
#import "NSDictionary+XZAdditions.h"
#import "UIView+XZAdditions.h"
#import "XZCameraHeader.h"


@interface XZCustomWaterContentView()


@property(nonatomic, strong)UILabel *titleLabel; // 标题
@property(nonatomic, strong)UILabel *contentLabel; // 标题


@end

@implementation XZCustomWaterContentView

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
    
    NSString *showText = [NSString stringWithFormat:@"%@：%@", [dict xz_stringForKey:@"title"], [dict xz_stringForKey:@"content"]];
    self.titleLabel.attributedText = [self shadowText:showText];
//    self.titleLabel.attributedText = [self shadowText:[dict xz_stringForKey:@"title"]];
    self.titleLabel.frame = CGRectMake(8*scale, 0, self.width - 16 *scale, CGFLOAT_MAX);
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(8*scale, 0, self.titleLabel.width, self.titleLabel.height);
    
//    self.contentLabel.text = [dict xz_stringForKey:@"content"];
//    self.contentLabel.attributedText = [self shadowText:[dict xz_stringForKey:@"content"]];
////    self.contentLabel.font = [UIFont systemFontOfSize:12*scale];
//    self.contentLabel.frame = CGRectMake(16*scale + self.titleLabel.width, 0, self.width - (16*scale + self.titleLabel.width), CGFLOAT_MAX);
//    [self.contentLabel sizeToFit];
//    self.contentLabel.frame = CGRectMake(16*scale + self.titleLabel.width, 0, self.width - (16*scale + self.titleLabel.width), self.contentLabel.height);
    
//    self.height = MAX(self.titleLabel.height, self.contentLabel.height);
    self.height = self.titleLabel.height;
    
}

- (NSAttributedString *)shadowText:(NSString *)string {
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 4.0;
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 2;
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]
                initWithString:string
                attributes: @{
                    NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                    NSForegroundColorAttributeName: [UIColor whiteColor],
                    NSShadowAttributeName:shadow,
                    NSParagraphStyleAttributeName:paragraphStyle,
    }];
    
    return aString;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = XZRGBCOLOR(0xFFFFFF);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
