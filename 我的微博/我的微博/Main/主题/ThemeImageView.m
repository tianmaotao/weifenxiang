//
//  ThemeImageView.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/12.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"
@implementation ThemeImageView

- (void)dealloc {
    //当该类的实例对象释放时移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeChangeNotification object:nil];
    }
    
    return self;
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
        
        [self loadImage];
    }
}

- (void)loadImage {
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    self.image = [themeManager getThemeImage:_imageName];
}

@end












