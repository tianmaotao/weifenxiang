//
//  CommentTableView.h
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, copy) NSMutableArray *dataArr;
@end
