//
//  ShowInfoCollectionViewTrailerCell.h
//  XBMC Remote
//
//  Created by Jonathan on 17/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewBaseCell.h"

@interface ShowInfoCollectionViewTrailerCell : ShowInfoCollectionViewBaseCell <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *URLToLoad;
- (IBAction)playButtonPressed:(UIButton *)sender;
@end
