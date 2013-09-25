//
//  NSURL+Builder.m
//  XBMC Remote
//
//  Created by Jonathan on 22/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "NSURL+Builder.h"
NSString * sOn(NSString *str) {
    return (str.length == 0) ? nil : str;
}

@implementation NSURL (Builder)
+(NSURL *)URLWithScheme:(NSString *)scheme username:(NSString *)username password:(NSString *)password host:(NSString *)host port:(NSInteger)port path:(NSString *)path {
    username = sOn(username);
    password = sOn(password);
    scheme = sOn(scheme);
    path = sOn(path);
    NSAssert(!!sOn(host), @"Host must not be nil when building URL");
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@://", scheme ?: @"http"];
    if (username) {
        [url appendString:username];
        if (password) {
            [url appendFormat:@":%@", password];
        }
        [url appendString:@"@"];
    }
    [url appendFormat:@"%@:%i", host, port];
    if (path) {
        [url appendFormat:@"/%@", path];
    }
    return [NSURL URLWithString:url];
}
@end
