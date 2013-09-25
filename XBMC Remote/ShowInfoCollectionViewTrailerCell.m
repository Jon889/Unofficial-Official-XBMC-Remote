//
//  ShowInfoCollectionViewTrailerCell.m
//  XBMC Remote
//
//  Created by Jonathan on 17/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewTrailerCell.h"

@implementation ShowInfoCollectionViewTrailerCell

+(CGSize)initialSizeOfCellForWidth:(CGFloat)width {
    //nh = oh/ow * nw   = 9/16*width
    return CGSizeMake(width, ((9.0/16.0)*width) + 20);
}
-(CGSize)sizeOfCellForWidth:(CGFloat)width {
    return [[self class] initialSizeOfCellForWidth:width];
}
-(void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
-(void)setContent:(id)content {
//    content = @"http://download.wavetlan.com/SVV/Media/HTTP/MP4/ConvertedFiles/QuickTime/QuickTime_test1_4m3s_MPEG4SP_CBR_120kbps_480x320_30fps_AAC-LCv4_CBR_32kbps_Stereo_22050Hz.mp4";
    NSURL *URL = [NSURL URLWithString:content];
    self.URLToLoad = URL;
    if (URL && [[URL host] rangeOfString:@"youtube"].location != NSNotFound) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    } else {
        [self.activityIndicator setHidden:YES];
        [self.playButton setHidden:NO];
        [self.webView setHidden:YES];
        
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView setOpaque:YES];
    [self.activityIndicator setHidden:YES];
}
- (IBAction)playButtonPressed:(UIButton *)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URLToLoad]];
    [self.webView setHidden:NO];
}
@end
