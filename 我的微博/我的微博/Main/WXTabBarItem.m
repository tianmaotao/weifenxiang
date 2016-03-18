//
//  WXTabBarItem.m
//  BJWxhl
//
//  Created by zhangchuning on 15/12/8.
//  Copyright © 2015年 oahgnehzoul. All rights reserved.
//

#import "WXTabBarItem.h"
#import "ThemeImageView.h"

@implementation WXTabBarItem

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        //1、创建子视图
        //1)图片
        ThemeImageView *imgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        imgView.imageName = name;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imgView];
    }
    
    return self;
}


@end
