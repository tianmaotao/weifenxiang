//
//  CommentLayout.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "CommentLayout.h"
#import "WXLabel.h"

@implementation CommentLayout

- (void)setCommentModel:(CommentModel *)commentModel {
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        [self _setLayout];
    }
}

- (void)_setLayout {
    CGFloat minitrim = kLinespace / 2;
    CGFloat textWidth = kScreenWidth - kCmmtTextX - kLinespace * 2 - minitrim;
    CGFloat textHeight = [WXLabel getTextHeight:kCmmtFontSize width:textWidth text:_commentModel.text linespace:kCmmtTextLinespace];
    
    _cellHeight = textHeight + kCmmtTextY;
    _textFrame = CGRectMake(kCmmtTextX, kCmmtTextY, textWidth, textHeight);
}

@end
