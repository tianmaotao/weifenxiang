//
//  CommentCell.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "CommentCell.h"
#import "NSDate+TimeAgo.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayout:(CommentLayout *)layout {
    if (_layout != layout) {
        _layout = layout;
        self.textLabel.text = _layout.commentModel.text;
        self.textLabel.frame = _layout.textFrame;
        self.nickLabel.text = _layout.commentModel.user.screen_name;
        [_userImgView sd_setImageWithURL:[NSURL URLWithString:_layout.commentModel.user.profile_image_url]];
        self.timeLabel.text = [self parseDateStr:_layout.commentModel.created_at];
    }
}

#pragma mark - utils
//Sat Oct 24 14:40:05 +0800 2015
-(NSString *)parseDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *format = @"E M d HH:mm:ss Z yyyy";
    [formatter setDateFormat:format];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeAgo];
}

#pragma mark - 懒加载
@synthesize commentLabel = _commentLabel;;
- (WXLabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[WXLabel alloc] init];
    }
    
    return _commentLabel;
}







@end
