//
//  NSURL+Builder.h
//  XBMC Remote
//
//  Created by Jonathan on 22/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Builder)
+(NSURL *)URLWithScheme:(NSString *)scheme username:(NSString *)username password:(NSString *)password host:(NSString *)host port:(NSInteger)port path:(NSString *)path;
@end
