//
//  HomeViewController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//
#import "HomeViewController.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboLayoutFrame.h"
#import "WXRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ThemeImageView.h"

@interface HomeViewController () <SinaWeiboRequestDelegate> {
    WeiboTableView *_weiboTableView;
    SystemSoundID soundID;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    [self _createTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Method
- (void)_createTableView {
    _weiboTableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style: UITableViewStylePlain];
    [self.view addSubview:_weiboTableView];
    [self _loadData];
    
    __weak HomeViewController *this = self;
    [_weiboTableView addPullDownRefreshBlock:^{
        [this _loadData];
    }];
    [_weiboTableView addInfiniteScrollingWithActionHandler:^{
        [this _loadOldData];
    }];
}

- (void)_loadData {
    long since_id = 0;
    if (_weiboTableView.models.count > 0) {
        WeiboLayoutFrame *layout = _weiboTableView.models[0];
        since_id = [layout.weiboModel.weiboId integerValue];
    }
    NSDictionary *param = @{@"since_id" : [NSString stringWithFormat:@"%ld", since_id]};
    
    [self.appDelegate.sinaWeibo requestWithURL:@"statuses/home_timeline.json" params:[param mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        [self _loadDataFinish:result isSinceID:YES];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        [self _stopRefresh];
    }];
}

- (void)_loadOldData {
    long max_id = 0;
    if (_weiboTableView.models.count > 0) {
        WeiboLayoutFrame *layout = [_weiboTableView.models lastObject];
        max_id = [layout.weiboModel.weiboId integerValue];
    }
    
    if (!self.appDelegate.sinaWeibo.isAuthValid) {
        [self.appDelegate.sinaWeibo logIn];
    }
    if ([self.appDelegate.sinaWeibo isLoggedIn]) {
        
        NSDictionary *param = @{@"max_id" : [NSString stringWithFormat:@"%ld", max_id]};
        
        [self.appDelegate.sinaWeibo requestWithURL:@"statuses/home_timeline.json" params:[param mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
            [self _loadDataFinish:result isSinceID:NO];
        } failBlock:^(SinaWeiboRequest *request, NSError *error) {
            [self _stopRefresh];
        }];
    }
}

- (void)_loadDataFinish:(id)result isSinceID:(BOOL)isSinceID {
    NSArray *arr = result[@"statuses"];
    NSMutableArray *weibos = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSDictionary *dic in arr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initContentWithDic:dic];
        WeiboLayoutFrame *layout = [[WeiboLayoutFrame alloc] init];
        layout.weiboModel = weiboModel;
        [weibos addObject:layout];
    }
    
    //更新的微博数
    NSInteger count = weibos.count;
    
    if (weibos.count > 0) {
        if (isSinceID) {
            [weibos addObjectsFromArray:_weiboTableView.models];
            _weiboTableView.models = weibos;
        }
        else {
            WeiboLayoutFrame *first = weibos[0];
            WeiboLayoutFrame *last = [_weiboTableView.models lastObject];
            if (first.weiboModel.weiboId == last.weiboModel.weiboId) {
                [weibos removeObjectAtIndex:0];
            }
            [_weiboTableView.models addObjectsFromArray:weibos];
            _weiboTableView.models = _weiboTableView.models;
        }
    }
    [_weiboTableView reloadData];
    [self _stopRefresh];
    [self _showNewWeiboCount:count];
    
}

- (void)_showNewWeiboCount:(NSInteger)count {
    AudioServicesPlayAlertSound(soundID);
    ThemeImageView *barView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
    barView.imageName = @"Timeline_Notice_color";
    barView.backgroundColor = [UIColor clearColor];
    barView.backgroundColor = [UIColor orangeColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 0, 100, 40)];
    titleLabel.text = [NSString stringWithFormat:@"%ld条微博更新", count];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [barView addSubview:titleLabel];
    [self.view addSubview:barView];
    [UIView animateWithDuration:1 animations:^{
        barView.transform = CGAffineTransformMakeTranslation(0, 40);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [barView removeFromSuperview];
            } completion:NULL];
        }
    }];
}

- (void)_stopRefresh {
    [_weiboTableView.pullToRefreshView stopAnimating];
    [_weiboTableView.infiniteScrollingView stopAnimating];
}

@end
