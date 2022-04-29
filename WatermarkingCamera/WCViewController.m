//
//  WCViewController.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/1.
//

#import "WCViewController.h"
#import "XZCameraHeader.h"
#import "XZCameraView.h"

@interface WCViewController()

@property (nonatomic, strong) XZCameraView *cameraView;
//@property (nonatomic, strong) CustomCameraView *cameraView;

@end

@implementation WCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
    _cameraView = [[XZCameraView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    self.view = _cameraView;
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
