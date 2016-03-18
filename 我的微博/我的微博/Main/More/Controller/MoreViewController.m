//
//  MoreViewController.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeSelectController.h"
#import "SinaWeibo.h"

@interface MoreViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArr;
    NSArray *_titleImg;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"主题选择", @"账户管理", @"意见反馈", @"登录退出"];
    _titleImg = @[@"more_icon_theme@2x.png", @"more_icon_account@2x.png", @"more_icon_feedback@2x.png"];
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped ];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_titleImg[indexPath.row]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _titleArr[indexPath.row + 2];
        NSString *str = _titleImg[indexPath.row + 2];
        cell.imageView.image = [UIImage imageNamed:str];
    } else {
        cell.textLabel.text = _titleArr[indexPath.row + 3];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        ThemeSelectController *themeSelectCtr = [[ThemeSelectController alloc] init];
        [self.navigationController pushViewController:themeSelectCtr animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self _logOut];
    }
}

- (void)_logOut {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要离开我么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.appDelegate.sinaWeibo logOut];
        
        UIAlertController *exit = [UIAlertController alertControllerWithTitle:@"退出程序？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [exit addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            _Exit(0);
            
        }]];
        
        [exit addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.appDelegate.sinaWeibo logIn];
        }]];
        
        [self presentViewController:exit animated:YES completion:NULL];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
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
