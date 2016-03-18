//
//  ZoomImageView.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/19.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "ZoomImageView.h"
#import "SDPieProgressView.h"
#import <ImageIO/ImageIO.h>

@interface ZoomImageView ()<NSURLSessionDataDelegate>

@end

@implementation ZoomImageView {
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    SDPieProgressView *_progressView;
    NSMutableData *_data;
    NSURLSession *_session;
    NSURLSessionDataTask *_dataTask;
}

- (instancetype)init {
    if (self = [super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

- (void)_createView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        [_scrollView addSubview:_fullImageView];
        
        _progressView = [SDPieProgressView progressView];
        _progressView.frame = CGRectMake(0, 0, 100, 100);
        _progressView.center = self.window.center;
        _progressView.hidden = YES;
        [_scrollView addSubview:_progressView];
    }
}

- (void)zoomIn {
    [self _createView];
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = rect;
    
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.frame = _scrollView.bounds;
    } completion:^(BOOL finished) {
        
        _scrollView.backgroundColor = [UIColor blackColor];
        
        _progressView.hidden = NO;
        if (self.urlString.length > 0) {
            NSURL *url = [NSURL URLWithString:_urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            _dataTask = [_session dataTaskWithRequest:request];
            [_dataTask resume];
            _data = [[NSMutableData alloc] init];
        }
    }];
}

- (void)zoomOut {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = rect;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _progressView = nil;
    }];
}

#pragma mark - nsurl session data delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_data appendData:data];
    _progressView.progress = (double)dataTask.countOfBytesReceived / dataTask.countOfBytesExpectedToReceive;
    
    if (dataTask.countOfBytesReceived == dataTask.countOfBytesExpectedToReceive) {
        UIImage *image = [UIImage imageWithData:_data];
        _fullImageView.image = image;
        CGFloat height = image.size.height / image.size.width * kScreenWidth;
        if (height < kScreenHeight) {
            _fullImageView.top = (kScreenHeight - height) / 2;
        }
        _fullImageView.height = height;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
        
        //播放GIF
        if (_isGif) {
            CGImageSourceRef source = CGImageSourceCreateWithData(((__bridge CFDataRef)_data), NULL);
            size_t count = CGImageSourceGetCount(source);
            NSMutableArray *images = [NSMutableArray array];
            NSTimeInterval duration = 0.0;
            
            for (size_t i = 0; i < count; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                UIImage *imageUI = [UIImage imageWithCGImage:image];
                [images addObject:imageUI];
                duration += 0.1;
                CGImageRelease(image);
            }
            
            UIImage *image = [UIImage animatedImageWithImages:images duration:duration];
            _fullImageView.image = image;
            CFRelease(source);
        }
    }
}
@end
