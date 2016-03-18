//
//  WeiboLayoutFrame.h
//  我的微博
//
//  Created by 汇文教育 on 16/1/14.
//  Copyright © 2016年 1203. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboModel;
@interface WeiboLayoutFrame : NSObject

@property (nonatomic, strong) WeiboModel *weiboModel;

////微博内容
//@property (nonatomic, assign) CGRect textFrame;
////微博图片
//@property (nonatomic, assign) CGRect imageFrame;
////原微博
//@property (nonatomic, assign) CGRect reTextFrame;
//
//@property (nonatomic, assign) CGRect reImageFrame;
//
////原微博的背景
//@property (nonatomic, assign)CGRect bgImgFrame;
//
////整个微博的frame
//@property (nonatomic, assign) CGRect weiboFrame;

#define kCellHeadHeight     65      //cell头视图的高度
#define kSpaceSize          15      //间距
#define kTextSize           16      //微博字体大小
#define kRetweetTextSize    15      //转发微博字体大小
#define kRetweetBgAlignY    5       //转发微博背景起始Y坐标离微博文字底部的距离（调整美观度）

#define kTextLineSpace  6           //微博正文行间距
#define kRetweetTextLineSpace  4    //转发微博正文行间距
#define kBottomHeight  25

//微博图片的宽高（一张图片）
//#define kWeiboImgWidth  100
//#define kWeiboImgHeight 100

#define kMultipleImgSpace 5     //多图之间的间隔


/**
 *  WeiboCellLayout 包含 WeiboModel 以及 cell里面所有ui的frame
 */

//cell的高度
@property(nonatomic, assign)CGFloat cellHeight;

//微博正文的frame
@property(nonatomic, assign)CGRect textFrame;

//微博图片的frame
//@property(nonatomic, assign)CGRect imgFrame;

//转发微博背景图片的frame
@property(nonatomic, assign)CGRect retweetBgFrame;

//转发微博正文的frame
@property(nonatomic, assign)CGRect retweetTextFrame;

//转发微博图片的frame
//@property(nonatomic, assign)CGRect retweetImgFrame;

//微博多图每张图片的frame
@property(nonatomic, strong)NSMutableArray *imgFrameArr;

//转发微博多图每张图片的frame
@property(nonatomic, strong)NSMutableArray *retweetImgFrameArr;


@end
