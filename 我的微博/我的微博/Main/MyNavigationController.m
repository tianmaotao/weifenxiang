//
//  MyNavigationController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "MyNavigationController.h"
#import "ThemeManager.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBarImg) name:kThemeChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [self loadBarImg];
    // Do any additional setup after loading the view.
}

- (void)loadBarImg {
    //设置背景，因为img高度小于64，所以需要自己生成高度64的图片
    UIImage *bgImg = [[ThemeManager shareThemeManager] getThemeImage:@"mask_titlebar@2x.png"];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(bgImg.CGImage, CGRectMake(0, 0, kScreenWidth, 64));
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
    CGImageRelease(imageRef);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
