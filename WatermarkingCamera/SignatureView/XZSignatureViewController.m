//
//  XZSignatureViewController.m
//  workers
//
//  Created by ios on 2020/12/26.
//  Copyright © 2020 cnabc. All rights reserved.
//

#import "XZSignatureViewController.h"
#import "SignatureView.h"
#import "XZCameraHeader.h"

@interface XZSignatureViewController ()
@property (nonatomic, strong) SignatureView *signatureView;
@end

@implementation XZSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _signatureView = [[SignatureView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _signatureView.lineColor = [UIColor blackColor];
//    [_signatureView drawRectDotterLineWithLineWidth:4 lineLength:4 lineSpacing:2 lineColor:[UIColor blueColor] cornerRadius:3.0];
    [self.view addSubview:_signatureView];
    
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    redoButton.frame = CGRectMake(0, 110+250, 80, 30);
    redoButton.backgroundColor = [UIColor whiteColor];
    redoButton.layer.masksToBounds = YES;
    redoButton.layer.cornerRadius = 15;
    redoButton.layer.borderWidth = 0.5;
    redoButton.layer.borderColor = XZRGBCOLOR(0x0289DC).CGColor;
    [redoButton setTitleColor:XZRGBCOLOR(0x0289DC) forState:UIControlStateNormal];
    [redoButton setTitle:@"重写" forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(clearButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redoButton];
    
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 210+250, 80, 30);
    clearButton.backgroundColor = [UIColor whiteColor];
    clearButton.layer.masksToBounds = YES;
    clearButton.layer.cornerRadius = 15;
    clearButton.layer.borderWidth = 0.5;
    clearButton.layer.borderColor = XZRGBCOLOR(0x0289DC).CGColor;
    [clearButton setTitleColor:XZRGBCOLOR(0x0289DC) forState:UIControlStateNormal];
    [clearButton setTitle:@"取消" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 310+250, 80, 30);
    saveButton.backgroundColor = XZRGBCOLOR(0x0289DC);
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 15;
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"确认" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    redoButton.transform = CGAffineTransformRotate(saveButton.transform, M_PI_4*2);
    clearButton.transform = CGAffineTransformRotate(saveButton.transform, M_PI_4*2);
    saveButton.transform = CGAffineTransformRotate(saveButton.transform, M_PI_4*2);
}

//- (BOOL)shouldAutorotate
//
//{
//
//    return NO;
//
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//
//{
//
//    return UIInterfaceOrientationMaskLandscape;
//
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//
//{
//
//    return UIInterfaceOrientationLandscapeRight;
//
//}

#pragma mark - 撤销
- (void)undoButtonDidClick:(id)sender
{
    [_signatureView undoLastDraw];
}

#pragma mark - 恢复
- (void)redoButtonDidClick:(id)sender
{
    [_signatureView redoLastDraw];
}

#pragma mark - 清空
- (void)clearButtonDidClick:(id)sender
{
    [_signatureView clearSignature];
}

#pragma mark - 保存
- (void)saveButtonDidClick:(id)sender
{
    
//    [_signatureView saveSignature];
    
    if (self.imageBlock) {
        self.imageBlock([_signatureView passSignatureImage]);
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)backButtonDidClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
