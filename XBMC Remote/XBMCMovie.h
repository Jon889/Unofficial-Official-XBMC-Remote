//
//  XBMCMovie.h
//  XBMC Remote
//
//  Created by Jonathan on 23/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMCServer.h"
@interface XBMCMovie : NSObject
@property (nonatomic, strong) XBMCServer *server;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSTimeInterval duration;//runtime;
@property (nonatomic, strong) NSArray *studios;
@property (nonatomic, strong) UIImage *thumbnail;
-(id)initWithServer:(XBMCServer *)server dictionary:(NSDictionary *)dict;
@end
