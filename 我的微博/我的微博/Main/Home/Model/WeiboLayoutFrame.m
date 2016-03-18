//
//  WeiboLayoutFrame.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/14.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "WeiboLayoutFrame.h"
#import "WeiboModel.h"
#import "WXLabel.h"

@implementation WeiboLayoutFrame

//- (void)setWeiboModel:(WeiboModel *)weiboModel {
//    if (_weiboModel != weiboModel) {
//        _weiboModel = weiboModel;
//        
//        [self layoutFrame];
//    }
//}
//
////根据微博内容计算微博视图的大小
//- (void)layoutFrame
//{
//    //整个微博视图的预设值
//    self.weiboFrame = CGRectMake(10, 60, kScreenWidth, 0);
//    
//    //计算微博视图的高度
//    //1.计算文本宽度
//    CGFloat textWidth = CGRectGetWidth(self.weiboFrame) - 20;
//    
//    //计算文本的高度
//    NSString *text = self.weiboModel.text;
//    CGFloat textHeight = [WXLabel getTextHeight:14 width:textWidth text:text linespace:5];
//    
//    self.textFrame = CGRectMake(10, 0, textWidth, textHeight);
//    
//    //原微博的frame
//    if (self.weiboModel.reWeibo != nil) {
//        
//        NSString *reText = self.weiboModel.reWeibo.text;
//        
//        CGFloat reTextWidth = textWidth - 20;
//        
//        CGFloat reTextHeight = [WXLabel getTextHeight:14 width:reTextWidth text:reText linespace:8];
//        
//        self.reTextFrame = CGRectMake(20, 0, reTextWidth, reTextHeight);
//        
//        NSString *image = self.weiboModel.reWeibo.thumbnailImage;
//        if (image.length > 0 ) {
//            CGFloat x = CGRectGetMinX(self.reTextFrame);
//            CGFloat y = CGRectGetMaxY(self.reTextFrame) + 5;
//            
//            self.reImageFrame = CGRectMake(x, y, 80, 80);
//        }
//        
//        //原微博的背景
//        CGFloat bgx = CGRectGetMinX(self.textFrame);
//        CGFloat bgy = CGRectGetMaxY(self.textFrame);
//        CGFloat bgWidth = CGRectGetWidth(self.reTextFrame);
//        CGFloat bgHeight = CGRectGetHeight(self.reTextFrame);
//        
//        if (image != nil) {
//            bgHeight = CGRectGetHeight(self.reTextFrame) + 80;
//        }
//        
//        self.bgImgFrame = CGRectMake(bgx, bgy, bgWidth, bgHeight);
//    }
//    
//#warning 是否在有原微博的情况下，要显示微博的图片
//    //原微博的图片
//    NSString *image = self.weiboModel.thumbnailImage;
//    if (image != nil) {
//        CGFloat imgX = CGRectGetMinX(self.textFrame);
//        CGFloat imgY = CGRectGetMaxY(self.textFrame);
//        
//        self.imageFrame = CGRectMake(imgX, imgY, 90, 90);
//    }
//    
//    CGRect frame = self.weiboFrame;
//    frame.size.height = self.bgImgFrame.size.height + self.textFrame.size.height + self.imageFrame.size.height;
//    
//    self.weiboFrame = frame;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imgFrameArr = [[NSMutableArray alloc] init];
        _retweetImgFrameArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<9; i++) {
            [_imgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
            [_retweetImgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
        }
    }
    return self;
}

-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self layoutFrame];
    }
}

-(void)layoutFrame
{
    CGFloat cellHeight = kCellHeadHeight;
    
    //1.微博正文的frame（固定宽度与字体大小）
    CGFloat textWidth = kScreenWidth-kSpaceSize*2;
    
    /*
     NSDictionary *attributeDic = @{
     NSFontAttributeName : [UIFont systemFontOfSize:kTextSize],
     NSForegroundColorAttributeName : [UIColor blackColor]
     };
     CGRect frame = [_weiboModel.text boundingRectWithSize:CGSizeMake(textWidth, 999)
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:attributeDic
     context:nil];
     */
    CGFloat textHeight = [WXLabel getTextHeight:kTextSize width:textWidth text:_weiboModel.text linespace:kTextLineSpace];
    self.textFrame = CGRectMake(kSpaceSize, kCellHeadHeight+kSpaceSize, textWidth, textHeight);
    cellHeight += CGRectGetHeight(self.textFrame)+kSpaceSize*2;
    
    /*
     //2.图片的frame
     if (_weiboModel.thumbnail_pic) {
     CGFloat imgX = CGRectGetMinX(self.textFrame);
     CGFloat imgY = CGRectGetMaxY(self.textFrame)+kSpaceSize;
     
     self.imgFrame = CGRectMake(imgX, imgY, kWeiboImgWidth, kWeiboImgHeight);
     cellHeight += CGRectGetHeight(self.imgFrame)+kSpaceSize;
     }
     */
    
    
    //2.微博多图的frame（0-9张数量不定）
    int row = 0, column = 0;
    
    CGFloat imgX = CGRectGetMinX(self.textFrame);
    CGFloat imgY = CGRectGetMaxY(self.textFrame)+kSpaceSize;
    CGFloat imgSize = (textWidth - kMultipleImgSpace*2)/3;      //一张图片的大小
    CGRect imgFrame = CGRectZero;
    for (int i=0; i<_weiboModel.pic_urls.count; i++) {
        //计算每张图片的frame
        row = i/3;
        column = i%3;
        imgFrame = CGRectMake(imgX+column*(imgSize+kMultipleImgSpace), imgY+row*(imgSize+kMultipleImgSpace), imgSize, imgSize);
        [self.imgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:imgFrame]];
    }
    /*
     计算多图所占用的行高（0-9）
     1、如果count为0，则cellHeight加0；
     2、如果count大于0，文字下面与图片之间的上下间隔只有1个kSpaceSize，kSpaceSize取值范围（0-1）
     3、图片与图片之间的间隔kMultipleImgSpace为 line-1，2行才有1个上下间隔，取值范围为（0-2）
     */
    NSInteger line = (_weiboModel.pic_urls.count+2)/3;  //+2 是区分 count>0 的小技巧
    cellHeight += line*imgSize + kMultipleImgSpace*(MAX(0, line-1)) + kSpaceSize*(MAX(0, MIN(line, 1)));
    
    
    //如果有转发微博
    if (_weiboModel.reWeibo) {
        
        //3.转发微博背景 初始frame
        CGFloat retweetBgX = CGRectGetMinX(self.textFrame);
        CGFloat retweetBgY = CGRectGetMaxY(self.textFrame)+kRetweetBgAlignY;
        CGFloat retweetBgWidth = CGRectGetWidth(self.textFrame);
        CGFloat retweetBgHeight = kSpaceSize;
        
        //4.转发微博的文字frame
        CGFloat retweetTextX = retweetBgX+kSpaceSize;
        CGFloat retweetTextY = retweetBgY+kSpaceSize;
        CGFloat retweetTextWidth = retweetBgWidth-kSpaceSize*2;
        
        /*
         NSDictionary *attributeDic = @{
         NSFontAttributeName : [UIFont systemFontOfSize:kRetweetTextSize],
         NSForegroundColorAttributeName : [UIColor blackColor]
         };
         CGRect retweetTextFrame = [_weiboModel.retweeted_status.text
         boundingRectWithSize:CGSizeMake(retweetTextWidth, 999)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:attributeDic
         context:nil];
         */
        CGFloat retweetTextHeight = [WXLabel getTextHeight:kRetweetTextSize width:retweetTextWidth text:_weiboModel.reWeibo.text linespace:kRetweetTextLineSpace];
        self.retweetTextFrame = CGRectMake(retweetTextX, retweetTextY, retweetTextWidth, retweetTextHeight);
        retweetBgHeight += CGRectGetHeight(self.retweetTextFrame)+kSpaceSize;
        
        /*
         //5.转发微博的图片frame
         if (_weiboModel.retweeted_status.thumbnail_pic) {
         self.retweetImgFrame = CGRectMake(retweetTextX, CGRectGetMaxY(self.retweetTextFrame)+kSpaceSize, kWeiboImgWidth, kWeiboImgHeight);
         retweetBgHeight += CGRectGetHeight(self.retweetImgFrame)+kSpaceSize;
         }
         */
        
        //5.转发微博多图frame
        CGFloat retweetImgX = CGRectGetMinX(self.retweetTextFrame);
        CGFloat retweetImgY = CGRectGetMaxY(self.retweetTextFrame)+kSpaceSize;
        CGFloat retweetImgSize = (retweetTextWidth - kMultipleImgSpace*2)/3;
        CGRect retweetImgFrame = CGRectZero;
        for (int i=0; i<_weiboModel.reWeibo.pic_urls.count; i++) {
            row = i/3;
            column = i%3;
            retweetImgFrame = CGRectMake(retweetImgX+column*(retweetImgSize+kMultipleImgSpace), retweetImgY+row*(retweetImgSize+kMultipleImgSpace), retweetImgSize, retweetImgSize);
            [self.retweetImgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:retweetImgFrame]];
        }
        NSInteger line = (_weiboModel.reWeibo.pic_urls.count+2)/3;
        retweetBgHeight += line*retweetImgSize + (MAX(0, line-1))*kMultipleImgSpace + kSpaceSize*(MAX(0, MIN(line, 1)));
        
        //6.转发微博背景 最终frame
        self.retweetBgFrame = CGRectMake(retweetBgX, retweetBgY, retweetBgWidth, retweetBgHeight);
        cellHeight += CGRectGetHeight(self.retweetBgFrame)+kRetweetBgAlignY;
        
    }
    
    //cell的高度
    self.cellHeight = cellHeight + kBottomHeight;
}


@end
