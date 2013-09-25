//
//  LockscreenMediaControls.h
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockscreenMediaControls : NSObject
+(instancetype)sharedInstance;
-(void)play;
-(void)pause;
-(void)stop;
-(void)updateAllCurrentlyPlaying;
@end
