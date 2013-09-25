// SocketController.m

#import "SocketController.h"

@implementation SocketController

static void socketCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void * data, void * info)
{
	SocketController * socketController = (SocketController *) info;
	
	if (type == kCFSocketConnectCallBack)
	{
		if (data)
		{
			[socketController onError: (int) data];
		}
		else
		{
			[socketController onConnect];
		}
		return;
	}
	
	if (type == kCFSocketDataCallBack)
	{
		[socketController onData: (NSMutableData *) data];
	}
}

- (void) dealloc
{
	if (_socket)
	{
		CFSocketInvalidate(_socket);
		_socket = nil;
	}
	[super dealloc];
}

- (id) initWithIPAddress:(NSString *)ips port: (int) port delegate: (id <SocketControllerDelegate>) delegate
{
    const char *ip = [ips UTF8String];
	if ((self = [super init]))
	{
		_delegate = delegate;
		
		CFSocketContext context = {
			.version = 0,
			.info = self,
			.retain = NULL,
			.release = NULL,
			.copyDescription = NULL
		};
		
		_socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack ^ kCFSocketConnectCallBack, socketCallBack, &context);
		
		struct sockaddr_in addr4;
		memset(&addr4, 0, sizeof(addr4));
		addr4.sin_family = AF_INET;
		addr4.sin_len = sizeof(addr4);
		addr4.sin_port = htons(port);
		
		inet_aton(ip, &addr4.sin_addr);
		NSData * address = [NSData dataWithBytes: &addr4 length: sizeof(addr4)];
		CFSocketConnectToAddress(_socket, (CFDataRef) address, -1);
		
		CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(NULL, _socket, 1);
		CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
		CFRelease(source);
	}
	return self;
}

- (void) onConnect
{
	if (_delegate)
	{
		[_delegate onSocketControllerConnect];
	}
}

- (void) onError: (int) error
{
	if (_delegate)
	{
		[_delegate onSocketControllerError: error];
	}
}

- (void) onData: (NSMutableData *) data
{
	if (_delegate && [(id) _delegate respondsToSelector: @selector(onSocketControllerMessage:)])
	{
		[_delegate onSocketControllerMessage: [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]];
	}
	if (_delegate && [(id) _delegate respondsToSelector: @selector(onSocketControllerData:)])
	{
		[_delegate onSocketControllerData: data];
	}
}

- (void) sendString: (NSString *) message
{
	const char * sendStrUTF = [message UTF8String];
	NSData * data = [NSData dataWithBytes: sendStrUTF length: strlen(sendStrUTF)];
	
	CFSocketError error = CFSocketSendData(_socket, NULL, (CFDataRef) data, 0);
	
	if (error > 0 && _delegate)
	{
		[_delegate onSocketControllerError: error];
	}
}

@end
