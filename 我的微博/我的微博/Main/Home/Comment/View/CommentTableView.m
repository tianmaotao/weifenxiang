//
//  CommentTableView.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"

#define kCommentCell @"CommentCell"

@implementation CommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupConfig];
    }
    
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    if (_dataArr != dataArr) {
        _dataArr = dataArr;
        [self reloadData];
    }
}

- (void)setupConfig {
    self.delegate = self;
    self.dataSource = self;
    _dataArr = [[NSMutableArray alloc] init];
    
    [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCell];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCell forIndexPath:indexPath];
    cell.layout = _dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentLayout *layout = _dataArr[indexPath.row];
    return layout.cellHeight;
}

@end
