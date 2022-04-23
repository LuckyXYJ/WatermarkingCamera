//
//  CustomCameraView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import "CustomCameraView.h"
#import "XZCameraHeader.h"

#define BottowButtonWidth ((SCREEN_WIDTH - 66 - 50)/4.f)

@interface CustomCameraView()

@property(nonatomic, strong)UIView *photoTopView;
@property(nonatomic, strong)UIView *editTopView;

@property(nonatomic, strong)UIView *photoBottowView;
@property(nonatomic, strong)UIView *editBottowView;

@end

@implementation CustomCameraView

- (instancetype)init{
    if(self = [super init]){
        [self ui_config];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self ui_config];
    }
    
    return self;
}

- (void)ui_config {
    
    [self addSubview:self.videoPreView];
    [self addSubview:self.imagePreiew];
    
    __weak typeof(self) wSelf = self;
    self.imagePreiew.waterViewTap = ^{
        if (wSelf.waterViewTap) {
            wSelf.waterViewTap();
        };
    };
    
    self.imagePreiew.drawLineBlock = ^(BOOL showUndo, BOOL showRedo) {
        [wSelf.lastStepButton setImage:[UIImage imageNamed:showUndo?@"icon_photo_edit_left":@"icon_photo_edit_left_normer"] forState:UIControlStateNormal];
        [wSelf.nextStepButton setImage:[UIImage imageNamed:showRedo?@"icon_photo_edit_right":@"icon_photo_edit_right_normer"] forState:UIControlStateNormal];
    };
    
    UIView *topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSaveTopSpace + 64)];
    topBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:topBgView];
    
    
    
    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, kSaveTopSpace + 20, SCREEN_WIDTH, 44)];
    [topBgView addSubview:topBarView];
    [topBarView addSubview:self.backButton];
    [topBarView addSubview:self.flashButton];
    [topBarView addSubview:self.cameraSwitchButton];
    _photoTopView = topBarView;
    
    UIView *botBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSaveBottomSpace - 156, SCREEN_WIDTH, kSaveBottomSpace + 156)];
    botBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:botBgView];
    _photoBottowView = botBgView;
    [botBgView addSubview:self.takePictureButton];
    [botBgView addSubview:self.photoWaterButton];
    
    
    
    UIView *topBarEditView = [[UIView alloc]initWithFrame:CGRectMake(0, kSaveTopSpace + 20, SCREEN_WIDTH, 44)];
    topBarEditView.hidden = YES;
    [topBgView addSubview:topBarEditView];
    _editTopView = topBarEditView;
    [topBarEditView addSubview:self.cancelButton];
    [topBarEditView addSubview:self.lastStepButton];
    [topBarEditView addSubview:self.nextStepButton];
    
    UIView *botBgEditView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSaveBottomSpace - 156, SCREEN_WIDTH, kSaveBottomSpace + 156)];
    botBgEditView.backgroundColor = [UIColor blackColor];
    botBgEditView.hidden = YES;
    [self addSubview:botBgEditView];
    _editBottowView = botBgEditView;
    [botBgEditView addSubview:self.editSaveButton];
    [botBgEditView addSubview:self.editBackButton];
    [botBgEditView addSubview:self.editWaterButton];
    [botBgEditView addSubview:self.editShareButton];
    [botBgEditView addSubview:self.editMarkButton];
    [botBgEditView addSubview:self.editSubmitButton];
}

- (void)changeViewStatus:(XZCameraPreviewStatus)status {
    if (status == XZCameraPreviewStatusEdit) {
        self.photoTopView.hidden = YES;
        self.photoBottowView.hidden = YES;
        self.videoPreView.hidden = YES;
        
        self.editTopView.hidden = NO;
        self.editBottowView.hidden = NO;
        self.imagePreiew.hidden = NO;
        
    }else {
        self.photoTopView.hidden = NO;
        self.photoBottowView.hidden = NO;
        self.videoPreView.hidden = NO;
        
        self.editTopView.hidden = YES;
        self.editBottowView.hidden = YES;
        self.imagePreiew.hidden = YES;
        
        [self.imagePreiew clearSignature];
    }
}

- (void)setFlashModel:(AVCaptureFlashMode)mode{
    if(mode == AVCaptureFlashModeOff){
        [self.flashButton setImage:[UIImage imageNamed:@"icon_camera_flash_close"] forState:UIControlStateNormal];
    }else if (mode == AVCaptureFlashModeOn){
        [self.flashButton setImage:[UIImage imageNamed:@"icon_camera_flash_open"] forState:UIControlStateNormal];
    }else if (mode == AVCaptureFlashModeAuto){
        [self.flashButton setImage:[UIImage imageNamed:@"icon_camera_flash_auto"] forState:UIControlStateNormal];
    }
}

- (void)changeImageViewFrameIfNeeded:(UIDeviceOrientation)orientation {
    [self.imagePreiew changeImageViewFrameIfNeeded:orientation];
}

- (void)showPreEditImage:(UIImage *)image {
    self.imagePreiew.imageView.image = image;
}

#pragma Actions
- (void)flashButtonClick:(id )sender{
    if(self.isHiddenFlashButtons ){
        
    }else{
        _clickFlashModel?_clickFlashModel():0;
    }
}

- (void)undoLastDraw {
    [self.imagePreiew undoLastDraw];
}

- (void)redoLastDraw {
    [self.imagePreiew redoLastDraw];
}

#pragma mark - setters && getters

- (void)setIsOpenDraw:(BOOL)isOpenDraw {
    self.imagePreiew.isOpenDraw = isOpenDraw;
    
    self.lastStepButton.hidden = !isOpenDraw;
    self.nextStepButton.hidden = !isOpenDraw;
    
    //TODO: 修改标记按钮颜色
    [self.editMarkButton changeImage:isOpenDraw?@"icon_photo_edit_select":@"icon_photo_edit"];
}

- (UIButton *)backButton{
    if(_backButton == nil){
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"base_arrow_left_white"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)flashButton{
    if(_flashButton == nil){
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.frame = CGRectMake(SCREEN_WIDTH - 44 - 8 - 44, 0, 44, 44);
        [_flashButton setImage:[UIImage imageNamed:@"icon_camera_flash_close"]
                      forState:UIControlStateNormal];
    }
    
    return _flashButton;
}

- (UIButton *)cameraSwitchButton{
    if(_cameraSwitchButton == nil){
        _cameraSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraSwitchButton.frame = CGRectMake(SCREEN_WIDTH - 44 - 8, 0, 44, 44);
        [_cameraSwitchButton setImage:[UIImage imageNamed:@"icon_camera_switch"] forState:UIControlStateNormal];
    }
    return _cameraSwitchButton;
}

- (XZCustomCameraBotton *)photoWaterButton {
    if(_photoWaterButton == nil){
        _photoWaterButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(15, 35, (SCREEN_WIDTH - 80)/2.f - 30, 80) withTitle:@"水印" imageName:@"icon_photo_water" isBig:NO];
    }
    return _photoWaterButton;
}

- (UIButton *)takePictureButton{
    if(_takePictureButton == nil){
        _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _takePictureButton.frame = CGRectMake(SCREEN_WIDTH/2 - 40, 24, 80, 80);
        [_takePictureButton setImage:[UIImage imageNamed:@"icon_camera_photo"] forState:UIControlStateNormal];
        [_takePictureButton.titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _takePictureButton;
}


- (UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setImage:[UIImage imageNamed:@"base_arrow_left_white"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)lastStepButton {
    if(_lastStepButton == nil){
        _lastStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastStepButton.frame = CGRectMake(SCREEN_WIDTH - 44 - 8 - 44, 0, 44, 44);
        [_lastStepButton setImage:[UIImage imageNamed:@"icon_photo_edit_left_normer"] forState:UIControlStateNormal];
    }
    return _lastStepButton;
}

- (UIButton *)nextStepButton {
    if(_nextStepButton == nil){
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.frame = CGRectMake(SCREEN_WIDTH - 44 - 8, 0, 44, 44);
        [_nextStepButton setImage:[UIImage imageNamed:@"icon_photo_edit_right_normer"] forState:UIControlStateNormal];
    }
    return _nextStepButton;
}

- (XZCustomCameraBotton *)editBackButton {
    if(_editBackButton == nil){
        _editBackButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(12.5, 35, BottowButtonWidth, 80) withTitle:@"返回" imageName:@"icon_camere_back" isBig:NO];
    }
    return _editBackButton;
}

- (XZCustomCameraBotton *)editWaterButton {
    if(_editWaterButton == nil){
        _editWaterButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(12.5 + BottowButtonWidth, 35, BottowButtonWidth, 80) withTitle:@"水印" imageName:@"icon_photo_water" isBig:NO];
    }
    return _editWaterButton;
}

- (XZCustomCameraBotton *)editShareButton {
    if(_editShareButton == nil){
        _editShareButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 33, 35, 66, 88) withTitle:@"发布" imageName:@"icon_photo_share" isBig:YES];
    }
    return _editShareButton;
}

- (XZCustomCameraBotton *)editMarkButton {
    if(_editMarkButton == nil){
        _editMarkButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(12.5 + SCREEN_WIDTH/2.f + 33, 35, BottowButtonWidth, 80) withTitle:@"标记" imageName:@"icon_photo_edit" isBig:NO];
    }
    return _editMarkButton;
}

- (XZCustomCameraBotton *)editSaveButton {
    if(_editSaveButton == nil){
        _editSaveButton = [[XZCustomCameraBotton alloc] initWithFrame:CGRectMake(12.5 + BottowButtonWidth + SCREEN_WIDTH/2.f + 33, 35, BottowButtonWidth, 80) withTitle:@"保存" imageName:@"icon_photo_save" isBig:NO];
    }
    return _editSaveButton;
}

- (UIButton *)editSubmitButton {
    if (!_editSubmitButton) {
        _editSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editSubmitButton.backgroundColor = XZRGBCOLOR(0X3A79EF);
        _editSubmitButton.layer.cornerRadius = 16;
        [_editSubmitButton setTitle:@"完成" forState:UIControlStateNormal];
        [_editSubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editSubmitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _editSubmitButton.hidden = YES;
        [self addSubview:_editSubmitButton];
    }
    return _editSubmitButton;
}

- (UIImageView *)focusView{
    if(_focusView == nil){
        _focusView = [[UIImageView alloc] init];
        _focusView.frame = CGRectMake(0, 0, 80, 80);
        _focusView.layer.borderColor = XZRGBCOLOR(0XFCD034).CGColor;
        _focusView.layer.borderWidth = 2.0f;
        _focusView.hidden = YES;
        _focusView.alpha = 0.0;
        [self addSubview:_focusView];
    }
    return _focusView;
}

- (UIView *)videoPreView {
    if(_videoPreView == nil){
        _videoPreView = [[UIView alloc] initWithFrame:CGRectMake(0, kSaveTopSpace + 64, SCREEN_WIDTH, SCREEN_HEIGHT - kSaveTopSpace - kSaveBottomSpace - 64 - 156)];
    }
    return _videoPreView;
}

- (XZCustomCameraEditImageView *)imagePreiew {
    if(_imagePreiew == nil){
        _imagePreiew = [[XZCustomCameraEditImageView alloc] initWithFrame:CGRectMake(0, kSaveTopSpace + 64, SCREEN_WIDTH, SCREEN_HEIGHT - kSaveTopSpace - kSaveBottomSpace - 64 - 156)];
        _imagePreiew.hidden = YES;
    }
    return _imagePreiew;
}


- (void)testWaterView:(NSDictionary *)dict {
    [self.imagePreiew testWaterView:dict];
}

- (void)showPreEditFromType:(NSInteger)type {

    if (type == 0) {
        
        self.editBackButton.frame = CGRectMake(12.5, 35, BottowButtonWidth, 80);
        self.editWaterButton.frame = CGRectMake(12.5 + BottowButtonWidth, 35, BottowButtonWidth, 80);
        self.editShareButton.frame = CGRectMake(SCREEN_WIDTH/2.f - 33, 35, 66, 88);
        self.editMarkButton.frame = CGRectMake(12.5 + SCREEN_WIDTH/2.f + 33, 35, BottowButtonWidth, 80);
        self.editSaveButton.frame = CGRectMake(12.5 + BottowButtonWidth + SCREEN_WIDTH/2.f + 33, 35, BottowButtonWidth, 80);
        self.editSubmitButton.hidden = YES;
        self.editShareButton.hidden = NO;
        
    }else {
        
        self.editBackButton.frame = CGRectMake(12.5, 35, BottowButtonWidth, 80);
        self.editWaterButton.frame = CGRectMake(12.5 + BottowButtonWidth, 35, BottowButtonWidth, 80);
        self.editMarkButton.frame = CGRectMake(12.5 + BottowButtonWidth*2, 35, BottowButtonWidth, 80);
        self.editSaveButton.frame = CGRectMake(12.5 + BottowButtonWidth*3, 35, BottowButtonWidth, 80);
        self.editSubmitButton.frame = CGRectMake(SCREEN_WIDTH - 88, 52, 70, 32);
        self.editSubmitButton.hidden = NO;
        self.editShareButton.hidden = YES;
    }
}

@end
