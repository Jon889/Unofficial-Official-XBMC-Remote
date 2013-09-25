//
//  XBMCNotificationListener.m
//  XBMC Remote
//
//  Created by Jonathan on 21/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "XBMCNotificationListener.h"
#import "SocketController.h"
#import "JSONKit.h"

@interface XBMCTargetAction : NSObject
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;
-(id)initWithTarget:(id)target action:(SEL)action;
@end
@implementation XBMCTargetAction

-(id)initWithTarget:(id)target action:(SEL)action {
    if (self = [super init]) {
        self.target = target;
        self.action = action;
    }
    return self;
}

@end


@interface XBMCNotificationListener () <SocketControllerDelegate>
@property (nonatomic, strong) SocketController *socket;
@property (nonatomic, strong) NSMutableDictionary *targetActionsForMethods;
@end
@implementation XBMCNotificationListener

-(id)initWithServer:(XBMCServer *)server {
    if (self = [super init]) {
        self.server = server;
        self.socket = [[SocketController alloc] initWithIPAddress:self.server.ip port:self.server.tcpPort ?: 9090 delegate:self];
    }
    return self;
}
-(NSMutableDictionary *)targetActionsForMethods {
    if (!_targetActionsForMethods) {
        _targetActionsForMethods = [[NSMutableDictionary alloc] init];
    }
    return _targetActionsForMethods;
}
-(void)addTarget:(id)target action:(SEL)action forMethod:(NSString *)method {
    XBMCTargetAction *ta = [[XBMCTargetAction alloc] initWithTarget:target action:action];
    NSMutableArray *tas = self.targetActionsForMethods[method];
    if (!tas) {
        tas = [NSMutableArray array];
        self.targetActionsForMethods[method] = tas;
    }
    [tas addObject:ta];
}
-(void)removeTarget:(id)target {
    for (NSMutableArray *tas in [self.targetActionsForMethods allValues]) {
        NSMutableArray *removes = [NSMutableArray array];
        for (XBMCTargetAction *ta in tas) {
            if (ta.target == target) {
                [removes addObject:ta];
            }
        }
        [tas removeObjectsInArray:removes];
    }
}
- (void) onSocketControllerError: (int) error {
    
}
-(void)onSocketControllerConnect {
}
-(void)onSocketControllerMessage:(NSString *)message {
    NSDictionary *notification = [message objectFromJSONString];
    NSString *method = notification[@"method"];
    NSLog(@"RECEIVED NOTIFICATION: %@", message);
    NSArray *tas = self.targetActionsForMethods[method];
    for (XBMCTargetAction *ta in tas) {
        [ta.target performSelector:ta.action withObject:notification];
    }
}
@end
