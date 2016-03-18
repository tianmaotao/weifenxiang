//
//  MessageViewController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "MessageViewController.h"
#import "SinaWeibo.h"
#import "WXRefresh.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createView];
    
    __weak MessageViewController *weekSelf = self;
    [_tableView addPullDownRefreshBlock:^{
        [weekSelf _loadData];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weekSelf _loadOldData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createView {
    NSLog(@"%@", [UIImage imageNamed:@"navigationbar_mentions"]);
    NSArray *imageArr = @[
                          [UIImage imageNamed:@"navigationbar_mentions"],[UIImage imageNamed:@"navigationbar_comments"],[UIImage imageNamed:@"navigationbar_messages"],[UIImage imageNamed:@"navigationbar_notice"]
                          ];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * 50, 5, 30, 30)];
        button.tag = 100 + i;
        [button setBackgroundImage:imageArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(mgvcAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        button.showsTouchWhenHighlighted = YES;
    }
    self.navigationItem.titleView = titleView;
}

- (void)_loadData {
    
}

- (void)_loadOldData {
    
}

- (void)mgvcAction:(UIButton *)sender {
    
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
