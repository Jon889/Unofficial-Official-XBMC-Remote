//
//  XBMCMovie.m
//  XBMC Remote
//
//  Created by Jonathan on 23/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "XBMCMovie.h"

@implementation XBMCMovie
-(id)initWithServer:(XBMCServer *)server dictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.server = server;
        self.title = dict[@"title"];
        self.duration = [dict[@"runtime"] integerValue];
        self.studios = dict[@"studio"];
        NSString *serverURL = [NSString stringWithFormat:@"%@:%@/%@/", self.server.ip, self.server.serverPort, (self.server.version > 11) ? @"image" : @"vfs"];
        NSString *stringURL = [serverURL stringByAppendingString:dict[@"thumbnail"]];
        self.thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]]];
    }
    return self;
}
@end
