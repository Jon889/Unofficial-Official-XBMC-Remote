//
//  XBMCServer.h
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSJSONRPC.h"
#import "XBMCNotificationListener.h"
#import "XBMCPlayer.h"

@class XBMCNotificationListener, XBMCPlayer;
@interface XBMCServer : NSObject
+(XBMCServer *)currentServer;
+(void)setCurrentServer:(XBMCServer *)server;
-(id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) DSJSONRPC *jsonRPC;
@property (nonatomic, strong) XBMCNotificationListener *notificationListener;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *MACAddress;
@property (nonatomic) NSInteger tcpPort;
@property (nonatomic, strong) NSString *serverPort;
@property (nonatomic, strong) NSString *serverDescription;
@property (nonatomic) BOOL preferTVPosters;

@property (readonly) NSInteger version;
@property (readonly) NSInteger minorVersion;

@property (nonatomic, strong) NSArray *activePlayers;
-(XBMCPlayer *)activePlayer;
-(void)getActivePlayers:(void(^)(NSArray *players))completion;


@end
