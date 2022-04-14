//
//  XZCustomCameraEditImageView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import "XZCustomCameraEditImageView.h"
#import "XZCameraHeader.h"

@implementation XZCustomCameraEditImageView {
    NSInteger _index;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _index = 0;
        [self ui_config];
    }
    
    return self;
}

- (void)ui_config {
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    _signatureView = [[SignatureView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _signatureView.lineColor = XZRGBCOLOR(0xFF0000);
    WS(wSelf, self);
    _signatureView.drawLineBlock = ^(BOOL showUndo, BOOL showRedo) {
        if (wSelf.drawLineBlock) {
            wSelf.drawLineBlock(showUndo, showRedo);
        }
    };
    [self addSubview:_signatureView];
    
    _waterView = [[XZCustomCameraWaterView alloc]init];
    _waterView.frame = CGRectMake(10, self.height - 124, 210, 114);
//    _waterView.waterViewTap = ^{
//        if (wSelf.waterViewTap) {
//            wSelf.waterViewTap();
//        }
//    };
    [self addSubview:_waterView];
}

- (void)undoLastDraw {
    [self.signatureView undoLastDraw];
}

- (void)redoLastDraw {
    [self.signatureView redoLastDraw];
}

- (void)clearSignature {
    [self.signatureView clearSignature];
}

- (void)setIsOpenDraw:(BOOL)isOpenDraw {
    self.signatureView.stopDraw = !isOpenDraw;
}

- (void)changeImageViewFrameIfNeeded:(UIDeviceOrientation)orientation {
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight){
        
        CGFloat scale =  self.width / self.height;
        
        self.imageView.frame = CGRectMake(0, 0, self.width, self.width / self.height * self.width);
        self.imageView.centerY = self.height / 2.0;
        
        [self.signatureView changeSignatureFrame:CGRectMake(0, 0, self.width, self.width / self.height * self.width)];
        self.signatureView.centerY = self.height / 2.0;
        
        
        
        CGFloat xTranslate = - 115.f * (1.0 - scale);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.waterView.transform = CGAffineTransformTranslate(transform, xTranslate, - ((self.height - self.width / self.height * self.width)/2 - 67) - 67*scale);
        self.waterView.transform = CGAffineTransformScale(self.waterView.transform, scale, scale);
        
        
    }else{
        self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
        self.imageView.centerY = self.height / 2.0;
        
        [self.signatureView changeSignatureFrame:CGRectMake(0, 0, self.width, self.height)];
        self.signatureView.centerY = self.height / 2.0;
        
        CGFloat scale =  1;
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.waterView.transform = CGAffineTransformScale(transform, scale, scale);
    }
}

- (UIImageView *)imageView{
    if(_imageView == nil){
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return _imageView;
}


- (void)testWaterView:(NSDictionary *)dict {
    
//    [self.waterView showWaterWithDetail:dict];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
