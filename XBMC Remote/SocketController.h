// simple socket wrapper class for objective-c

// SocketController.h

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>

@protocol SocketControllerDelegate

- (void) onSocketControllerConnect;
- (void) onSocketControllerError: (int) error;

@optional

- (void) onSocketControllerData: (NSMutableData *) data;
- (void) onSocketControllerMessage: (NSString *) message;

@end

@interface SocketController : NSObject {
	id <SocketControllerDelegate> _delegate;
    CFSocketRef _socket;
}

- (id) initWithIPAddress:(NSString *) ip port: (int) port delegate: (id <SocketControllerDelegate>) delegate;
- (void) onConnect;
- (void) onError: (int) error;
- (void) onData: (NSMutableData *) data;
- (void) sendString: (NSString *) message;

@end