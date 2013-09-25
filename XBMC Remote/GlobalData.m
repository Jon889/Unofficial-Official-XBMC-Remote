//
//  GlobalData.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 27/3/12.
//  Copyright (c) 2012 joethefox inc. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *instance = nil;    
+(GlobalData *)getInstance    {    
    @synchronized(self) {    
        if (instance == nil) {    
            instance = [GlobalData new];    
        }    
    }    
    return instance;    
}

@end
