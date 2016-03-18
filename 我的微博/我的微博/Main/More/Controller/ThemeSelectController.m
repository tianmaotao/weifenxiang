//
//  ThemeSelectController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/15.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "ThemeSelectController.h"
#import "ThemeManager.h"

@interface ThemeSelectController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_themeNameArr;
}

@end

@implementation ThemeSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];;
    _themeNameArr = @[@"猫爷", @"Dark Knight",@"Mr.O",@"Night Club",@"Blue Moon",@"Dark Fairy",@"FishEye",@"Forest",@"Happy Toy",@"Honey",@"魁拔",@"Ocean Run",@"New PinkPink", @"Puppy Love", @"Village"];
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped ];
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
    return _themeNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.text = _themeNameArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeManager *manager = [ThemeManager shareThemeManager];
    manager.themeName = _themeNameArr[indexPath.row];
    [tableView reloadData];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
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
