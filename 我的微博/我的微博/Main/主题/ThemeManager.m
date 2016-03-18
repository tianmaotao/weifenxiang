//
//  ThemeManager.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/12.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "ThemeManager.h"
#define kDefaultThemeName @"Forest"
@interface ThemeManager()
@property (nonatomic, copy) NSDictionary *themeConfig;

@end

@implementation ThemeManager

+ (instancetype)shareThemeManager {
    static ThemeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _themeName = kDefaultThemeName;
        //读取本地保存的配置信息
        NSString *saveName = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveThemeName];
        
        if (saveName.length > 0) {
            _themeName = saveName;
        }
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    }
    
    return self;
}

- (NSString *)themePath {
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *themePath = [self.themeConfig objectForKey:_themeName];
    NSString *path = [bundlePath stringByAppendingPathComponent:themePath];
    return path;
}

- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName == nil) {
        return nil;
    }
    NSString *imagePath = [self themePath];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:imageName]];
    
    return image;
}
//当主题名改变的时候，就发送一个通知
/*
 主题名字改变-》发送一个通知-》相关视图接受通知-》接受通知的对象调用视图背景所在方法（该方法通过调用主题管理对象的getThemeImage方法获取同名字，但是路径不同的图片）,完成主题的设置
 */



- (void)setThemeName:(NSString *)themeName {
    if (_themeName != themeName) {
        _themeName = themeName;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangeNotification object:nil];
    }
}

@end
