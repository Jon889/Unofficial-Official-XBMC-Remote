//
//  XBMCPlayer.h
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMCServer.h"

typedef NSString * XBMCPlayerType;
XBMCPlayerType const XBMCPlayerTypeVideo;
XBMCPlayerType const XBMCPlayerTypeAudio;
XBMCPlayerType const XBMCPlayerTypePicture;

@class XBMCServer;
@interface XBMCPlayer : NSObject
@property (nonatomic, weak) XBMCServer *server;
@property (nonatomic, strong) XBMCPlayerType playerType;
@property (nonatomic, strong) id playingItem;
-(id)initWithServer:(XBMCServer *)server resultsDictionary:(NSDictionary *)dict;
-(void)playPause;
-(void)previous;
-(void)stop;
-(void)next;
-(void)backward;
-(void)forward;
-(void)play;
-(void)pause;
-(void)setPlaySpeed:(NSInteger)speed;
@end
