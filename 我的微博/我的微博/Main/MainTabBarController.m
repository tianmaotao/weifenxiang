//
//  MainTabBarController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "MainTabBarController.h"
#import "WXTabBarItem.h"
#import "ThemeManager.h"

@interface MainTabBarController () {
    NSArray *_titleArr;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"首页", @"消息", @"个人中心", @"发现", @"更多"];
    self.viewControllers = [self _createNavigationController];
     [self.tabBar setBackgroundImage:[UIImage imageNamed:@"mask_navbar@2x.png"]];
    [self _createTabbar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - 标签栏控制器
- (NSArray *)_loadViewController {
    
    NSArray *storyboardArr = @[@"HomeStoryboard", @"MessageStoryboard", @"ProfileStoryboard", @"DiscoverStoryboard", @"MoreStoryboard"];
    NSMutableArray *VCArr = [NSMutableArray array];
    for (int  i = 0; i < storyboardArr.count; i++) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardArr[i] bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [VCArr addObject:viewController];
    }
    
    return VCArr;
}

- (NSArray *)_createNavigationController {
    NSArray *storyboard = [self _loadViewController];
    NSMutableArray *NGArr = [NSMutableArray array];
    if (storyboard.count) {
        for (int i = 0; i < _titleArr.count; i++) {
            [NGArr addObject:[[MyNavigationController alloc] initWithRootViewController:storyboard[i]]];
            UIViewController *vc = storyboard[i];
            vc.title = _titleArr[i];
        }
    }
    
    return NGArr;
}

#pragma mark - 标签栏
- (void)_createTabbar {
    //移除标签栏视图
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat itemHeight = CGRectGetHeight(self.tabBar.frame);
    CGFloat itemWidth = kScreenWidth / _titleArr.count;
    NSLog(@"%lf", itemHeight);
    NSLog(@"%lf", itemWidth);
    NSArray *imgArray = @[
                          @"home_tab_icon_1.png",
                          @"home_tab_icon_2.png",
                          @"home_tab_icon_3.png",
                          @"home_tab_icon_4.png",
                          @"home_tab_icon_5.png",
                          ];
    for (int i = 0; i < _titleArr.count; i++) {
        CGRect frame = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        NSString *img = imgArray[i];
        WXTabBarItem *item = [[WXTabBarItem alloc] initWithFrame:frame imageName:img];
        item.tag = 100 + i;
        [self.tabBar addSubview:item];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_selectImgView == nil) {
            
            _selectImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 49)];
            _selectImgView.imageName = @"home_bottom_tab_arrow.png";
            [self.tabBar insertSubview:_selectImgView atIndex:0];
            if (i == 0) {
                _selectImgView.center = item.center;
            }
        }
    }
}

- (void)itemAction:(WXTabBarItem *)item {
    [UIView animateWithDuration:0.2 animations:^{
        _selectImgView.center = item.center;
    }];
    
    [self setSelectedIndex:item.tag - 100];
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
