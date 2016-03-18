//
//  CommentViewController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableView.h"
#import "SinaWeibo.h"
#import "WeiboModel.h"
#import "CommentLayout.h"
#import "WeiboCell.h"

@interface CommentViewController () {
    NSMutableArray *_dataArr;
    CommentTableView *_commentTableView;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _commentTableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_commentTableView];
    [self _dataRequest];
    [self _commentHeader];
    // Do any additional setup after loading the view.
}

- (void)_commentHeader {
    WeiboCell *commentHeader = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] lastObject];
        commentHeader.frame = CGRectMake(CGRectGetMinX(_commentTableView.frame), CGRectGetMinY(_commentTableView.frame), CGRectGetWidth(_commentTableView.frame), self.weiboLayout.cellHeight - kBottomHeight);
    commentHeader.weiboLayoutFrame = _weiboLayout;
    _commentTableView.tableHeaderView = commentHeader;
}

- (void)_dataRequest {
//    AppDelegate *appDelegate = [self appDelegate];
//    NSString *weiboID = [NSString stringWithFormat:@"%ld", [_weiboLayout.weiboModel.weiboId integerValue]];
//    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];
//    [appDelegate.sinaWeibo requestWithURL:@"comments/show.json" params:mDic httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
//        
//    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
//        
//    }];
    AppDelegate *appDelegate = [self appDelegate];
    NSString *weiboID = [NSString stringWithFormat:@"%ld", [_weiboLayout.weiboModel.weiboId integerValue]];
    NSDictionary *param = @{
                            @"id" : weiboID
                            };
    [appDelegate.sinaWeibo requestWithURL:@"comments/show.json" params:[param mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        NSArray *arr = [result objectForKey:@"comments"];
        _dataArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            CommentModel *commentModel = [[CommentModel alloc] initWithDictionary:dic error:NULL];
            CommentLayout *layout = [[CommentLayout alloc] init];
            layout.commentModel = commentModel;
            [_dataArr addObject:layout];
        }
        _commentTableView.dataArr =_dataArr;
        
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
