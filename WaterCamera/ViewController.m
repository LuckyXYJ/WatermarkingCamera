//
//  ViewController.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/1.
//

#import "ViewController.h"
#import "WCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"ddd");
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 50);
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)takePhoto {
    
    WCViewController *wc = [[WCViewController alloc] init];
    wc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:wc animated:NO completion:^{
        
    }];
    
}


@end
