//
//  CommentLayout.h
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

#define kCmmtFontSize 15
#define kLinespace 10
#define kCmmtTextX 55
#define kCmmtTextY 55
#define kCmmtTextLinespace 4

@interface CommentLayout : NSObject
@property(nonatomic, strong) CommentModel *commentModel;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) CGRect textFrame;
@end
