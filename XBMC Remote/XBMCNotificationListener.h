//
//  XBMCNotificationListener.h
//  XBMC Remote
//
//  Created by Jonathan on 21/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMCServer.h"
@class XBMCServer;


@interface XBMCNotificationListener : NSObject
@property (nonatomic, assign) XBMCServer *server;
-(id)initWithServer:(XBMCServer *)server;
-(void)addTarget:(id)target action:(SEL)action forMethod:(NSString *)method;
-(void)removeTarget:(id)target;
@end
