//
//  LeftViewController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/14.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_animationArr;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配置";
    _animationArr = @[@"无", @"滑动", @"滑动或缩放", @"漂移门", @"视差滑动"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, kScreenHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _animationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"animationIdentifier"];
    cell.textLabel.text = _animationArr[indexPath.row];
    NSString *imgName = [NSString stringWithFormat:@"00%ld@2x.png", indexPath.row + 1];
    cell.imageView.image = [UIImage imageNamed:imgName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"界面切换动画";
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
