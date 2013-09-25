//
//  BlurredView.m
//  XBMC Remote
//
//  Created by Jonathan on 24/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#import "BlurredView.h"
@interface BlurredView ()
@property (nonatomic, strong) UIToolbar *toolbar;
@end
@implementation BlurredView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.toolbar = [[UIToolbar alloc] initWithFrame:frame];
            [self.toolbar setBarStyle:UIBarStyleBlack];
            [self addSubview:self.toolbar];
        } else {
            [self setBackgroundColor:[UIColor blackColor]];
            [self setAlpha:0.7];
        }
    }
    return self;
}
-(void)layoutSubviews {
    [self.toolbar setFrame:self.bounds];
}

@end
