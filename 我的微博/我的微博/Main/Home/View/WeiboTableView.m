//
//  WeiboTableView.m
//  84班测试微博
//
//  Created by wenyuan on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboLayoutFrame.h"
#import "CommentViewController.h"
#import "UIView+ViewController.h"

#define kWeiboCell @"WeiboCell"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        //如果要复用，注册单元格
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:kWeiboCell];
        //创建models
        _models = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell创建
    WeiboCell *weiboCell = [tableView dequeueReusableCellWithIdentifier:kWeiboCell forIndexPath:indexPath];
    weiboCell.weiboLayoutFrame = self.models[indexPath.row];
    
    return weiboCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboLayoutFrame *frame = self.models[indexPath.row];
    CGFloat height = frame.cellHeight;
    return height;
}
//1、点击单元格 跳转到详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewController *cmmVC = [[CommentViewController alloc] init];
    cmmVC.weiboLayout = _models[indexPath.row];
    [self.viewController.navigationController pushViewController:cmmVC animated:YES];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}
@end
