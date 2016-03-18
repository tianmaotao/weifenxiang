//
//  WeiboCell.m
//  84班测试微博
//
//  Created by wenyuan on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboCell.h"
#import "UserModel.h"
#import "WeiboLayoutFrame.h"
#import "WeiboModel.h"
#import "RegexKitLite.h"
#import "UIViewExt.h"
#import "ZoomImageView.h"

@implementation WeiboCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self _createWeiboLabel];
//    }
//    
//    return self;
//}

- (void)awakeFromNib {
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //注意数据的加载都在这里
    if (_weiboLayoutFrame.weiboModel != nil) {
        UserModel *userModel = _weiboLayoutFrame.weiboModel.user;
        self.nickName.text = userModel.screen_name;
        NSURL *url = [NSURL URLWithString:userModel.profile_image_url];
        [_headImage sd_setImageWithURL:url];
        _headImage.layer.cornerRadius = 10;
        _headImage.clipsToBounds = YES;
        _timeLabel.text = [self timeRegex];
        _sourceLabel.text = [self sourceRegex];
        
        for (int i = 0; i < self.weiboLayoutFrame.weiboModel.pic_urls.count; i++) {
            ZoomImageView *img = _imgViewArr[i];
            NSString *urlStr =  self.weiboLayoutFrame.weiboModel.pic_urls[i][@"thumbnail_pic"];
            [img sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            
            //
            NSMutableString *url = [NSMutableString stringWithString:urlStr];
            NSRange range = [urlStr rangeOfString:@"thumbnail"];
            [url replaceCharactersInRange:range withString:@"large"];
            img.urlString = url;
            
            //
            NSString *strGIF = [urlStr pathExtension];
            if ([strGIF isEqualToString:@"gif"]) {
                img.isGif = YES;
            }else {
                img.isGif = NO;
            }
        }
        
        //转发微博多图赋值
        for (int i=0; i<self.weiboLayoutFrame.weiboModel.reWeibo.pic_urls.count; i++) {
            ZoomImageView *retweetImgView = self.reImgViewArr[i];
            NSString *imgUrlStr = self.weiboLayoutFrame.weiboModel.reWeibo.pic_urls[i][@"thumbnail_pic"];
            [retweetImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
            
            //
            NSMutableString *url = [NSMutableString stringWithString:imgUrlStr];
            NSRange range = [imgUrlStr rangeOfString:@"thumbnail"];
            [url replaceCharactersInRange:range withString:@"large"];
            retweetImgView.urlString = url;
            
            //
            NSString *strGIF = [imgUrlStr pathExtension];
            if ([strGIF isEqualToString:@"gif"]) {
                retweetImgView.isGif = YES;
            }else {
                retweetImgView.isGif = NO;
            }
        }
        
        
        [self setWeiboLayout];
    }
}

//时间正则
- (NSString *)timeRegex {
    NSString *timeStr = _weiboLayoutFrame.weiboModel.createDate;
    NSString *regex = @"\\d{2}:\\d{2}:\\d{2}";
    NSArray *regexArr = [timeStr componentsMatchedByRegex:regex];
    return [regexArr lastObject];
}

//来源正则
- (NSString *)sourceRegex {
    
    NSString *sourceStr = _weiboLayoutFrame.weiboModel.source;
    NSString *regex = @">.*<";
    NSArray *regexArr = [sourceStr componentsMatchedByRegex:regex];
    NSString *str = [regexArr lastObject];
    NSString *regexStr = [str substringWithRange:NSMakeRange(1, str.length - 2)];
    if (regexStr == nil) {
        return nil;
    }
    NSString *resultStr = [NSString stringWithFormat:@"来源：%@", regexStr];
    return resultStr;
}

- (void)setWeiboLayoutFrame:(WeiboLayoutFrame *)weiboLayoutFrame {
    if (_weiboLayoutFrame != weiboLayoutFrame) {
        _weiboLayoutFrame = weiboLayoutFrame;
        
        [self layoutSubviews];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 微博内容在cell上得布局
- (void)setWeiboLayout {
    self.weiboLabel.text = _weiboLayoutFrame.weiboModel.text;
    self.weiboLabel.frame = _weiboLayoutFrame.textFrame;
    self.reWeiboLabel.text = _weiboLayoutFrame.weiboModel.reWeibo.text;
    self.reWeiboLabel.frame = _weiboLayoutFrame.retweetTextFrame;
    self.reWeiboView.frame = _weiboLayoutFrame.retweetBgFrame;
    
    for (int i = 0; i < self.imgViewArr.count || i < self.reImgViewArr.count; i++) {
        ZoomImageView *img = self.imgViewArr[i];
        img.frame = [_weiboLayoutFrame.imgFrameArr[i] CGRectValue];
        
        ZoomImageView *reImg = self.reImgViewArr[i];
        reImg.frame = [_weiboLayoutFrame.retweetImgFrameArr[i] CGRectValue];
    }
}

#pragma mark - 懒加载
/*
 需要的时候才加载。
 */
@synthesize weiboLabel = _weiboLabel;
@synthesize reImgViewArr = _reImgViewArr;
@synthesize imageView = _imageView;
@synthesize reWeiboLabel = _reWeiboLabel;
@synthesize reWeiboView = _reWeiboView;

- (UILabel *)weiboLabel {
    if (!_weiboLabel) {
        _weiboLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _weiboLabel.wxLabelDelegate = self;
        _weiboLabel.linespace = kTextLineSpace;
        _weiboLabel.numberOfLines = 0;
        _weiboLabel.font = [UIFont systemFontOfSize:kTextSize];
        [self.contentView addSubview:_weiboLabel];
    }
    
    return _weiboLabel;
}

- (UILabel *)reWeiboLabel {
    if (!_reWeiboLabel) {
        _reWeiboLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
       
        _reWeiboLabel.wxLabelDelegate = self;
        _reWeiboLabel.linespace = kRetweetTextLineSpace;
        _reWeiboLabel.numberOfLines = 0;
        _reWeiboLabel.font = [UIFont systemFontOfSize:kRetweetTextSize];

        [self.contentView addSubview:_reWeiboLabel];
    }
    
    return _reWeiboLabel;
}

- (ThemeImageView *)reWeiboView {
    if (!_reWeiboView) {
        _reWeiboView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
        _reWeiboView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentView insertSubview:_reWeiboView atIndex:0];
    }
    
    return _reWeiboView;
}

- (NSMutableArray *)imgViewArr {
    if (!_imgViewArr) {
        _imgViewArr = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            ZoomImageView *img = [[ZoomImageView alloc] init];
            [self.contentView addSubview:img];
            [_imgViewArr addObject:img];
        }
    }
    
    return _imgViewArr;
}

- (NSMutableArray *)reImgViewArr {
    if (!_reImgViewArr) {
        _reImgViewArr = [NSMutableArray array];
        for (int  i = 0; i < 9; i++) {
            ZoomImageView *reImg = [[ZoomImageView alloc] init];
            [self.contentView addSubview:reImg];
            [_reImgViewArr addObject:reImg];
        }
    }
    
    return  _reImgViewArr;
}


#pragma mark - WXLabel Delegate
//返回正则表达式匹配的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    NSString *regEx1 = @"http://([a-zA-Z0-9_.-]+(/)?)+";
    NSString *regEx2 = @"@[\\w.-]{2,30}";
    NSString *regEx3 = @"#[^#]+#";
    
    NSString *regEx =
    [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regEx1, regEx2, regEx3];
    
    return regEx;
}

- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    return @"\\[\\w+\\]";
}






@end
