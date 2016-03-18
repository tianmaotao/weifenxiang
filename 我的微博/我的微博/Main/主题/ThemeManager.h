//
//  ThemeManager.h
//  我的微博
//
//  Created by 汇文教育 on 16/1/12.
//  Copyright © 2016年 1203. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kThemeChangeNotification @"themeChangeNotification"
//保存的本地名key
#define kSaveThemeName @"kSaveThemeName"
@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;

+ (instancetype)shareThemeManager;

- (UIImage *)getThemeImage:(NSString *)path;

@end
