//
//  WeiboCell.h
//  84班测试微博
//
//  Created by wenyuan on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WXLabel.h"

@class WeiboLayoutFrame;
@class WXLabel;
@interface WeiboCell : UITableViewCell <WXLabelDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;
@property(nonatomic, strong) WeiboLayoutFrame *weiboLayoutFrame;

@property(nonatomic, strong) WXLabel *weiboLabel;
@property(nonatomic, strong)WXLabel *reWeiboLabel;//转发微博
@property(nonatomic, strong)ThemeImageView *reWeiboView;
@property(nonatomic, strong) NSMutableArray *imgViewArr;//
@property(nonatomic, strong) NSMutableArray *reImgViewArr;//转发微博的图片数组
@end
