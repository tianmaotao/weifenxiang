//
//  WeiboTableView.h
//  84班测试微博
//
//  Created by wenyuan on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , copy)NSMutableArray *models;

@end
