//
//  HostViewController.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 14/4/12.
//  Copyright (c) 2012 joethefox inc. All rights reserved.
//

#import "HostViewController.h"
#import "AppDelegate.h"
#include <arpa/inet.h>
#import <QuartzCore/QuartzCore.h>

#define serviceType @"_xbmc-jsonrpc-h._tcp"
#define domainName @"local"
#define DISCOVER_TIMEOUT 5.0f

@interface HostViewController ()
-(void)configureView;
@end

@implementation HostViewController

@synthesize detailItem = _detailItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)AnimLabel:(UIView *)Lab AnimDuration:(float)seconds Alpha:(float)alphavalue XPos:(int)X{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:seconds];
	Lab.alpha = alphavalue;
	CGRect frame;
	frame = [Lab frame];
	frame.origin.x = X;
	Lab.frame = frame;
    [UIView commitAnimations];
    
}

- (void)AnimView:(UIView *)view AnimDuration:(float)seconds Alpha:(float)alphavalue XPos:(int)X{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:seconds];
	view.alpha = alphavalue;
	CGRect frame;
	frame = [view frame];
	frame.origin.x = X;
	view.frame = frame;
    [UIView commitAnimations];
}

- (void)configureView {
    if (self.detailItem == nil){
        self.navigationItem.title = NSLocalizedString(@"New XBMC Server", nil);
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"Modify XBMC Server", nil);
        NSIndexPath *idx = self.detailItem;
        
        descriptionUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"serverDescription"];
        
        usernameUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"serverUser"];

        passwordUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"serverPass"];

        ipUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"serverIP"];

        portUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"serverPort"];
        
        NSString *macAddress = ([AppDelegate instance].arrayServerList)[idx.row][@"serverMacAddress"];
        NSArray *mac_octect = [macAddress componentsSeparatedByString:@":"];
        int num_octects = [mac_octect count];
        if (num_octects>0) mac_0_UI.text = mac_octect[0];
        if (num_octects>1) mac_1_UI.text = mac_octect[1];
        if (num_octects>2) mac_2_UI.text = mac_octect[2];
        if (num_octects>3) mac_3_UI.text = mac_octect[3];
        if (num_octects>4) mac_4_UI.text = mac_octect[4];
        if (num_octects>5) mac_5_UI.text = mac_octect[5];

        preferTVPostersUI.on = [([AppDelegate instance].arrayServerList)[idx.row][@"preferTVPosters"] boolValue];
        tcpPortUI.text = ([AppDelegate instance].arrayServerList)[idx.row][@"tcpPort"];
    }
    NSArray *textFields = @[descriptionUI, ipUI, portUI, usernameUI, passwordUI, mac_0_UI, mac_1_UI, mac_2_UI, mac_3_UI, mac_4_UI, mac_5_UI, tcpPortUI];
    for (UITextField *textField in textFields) {
//        textField.layer.borderColor = [[UIColor colorWithWhite:0.7 alpha:1] CGColor];
//        textField.layer.borderWidth = 1;
        UIColor *color = [UIColor colorWithWhite:0.5 alpha:1];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];

        [textField setTintColor:[UIColor whiteColor]];
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0, textField.bounds.size.height-1, textField.bounds.size.width, 1);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
        
        [textField.layer addSublayer:bottomBorder];
        //textField.layer.cornerRadius = 4;
        textField.borderStyle = UITextBorderStyleNone;
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor whiteColor];
    }
}

- (void)setDetailItem:(id)newDetailItem{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (IBAction) dismissView:(id)sender{
    
    [self textFieldDoneEditing:nil];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@", mac_0_UI.text, mac_1_UI.text, mac_2_UI.text, mac_3_UI.text, mac_4_UI.text, mac_5_UI.text];
    if (self.detailItem == nil){
        [[AppDelegate instance].arrayServerList addObject:@{@"serverDescription": descriptionUI.text,
                                                           @"serverUser": usernameUI.text,
                                                           @"serverPass": passwordUI.text,
                                                           @"serverIP": ipUI.text,
                                                           @"serverPort": portUI.text,
                                                           @"serverMacAddress": macAddress,
                                                           @"preferTVPosters": @(preferTVPostersUI.on),
                                                           @"tcpPort": tcpPortUI.text}];
    }
    else{
        NSIndexPath *idx = self.detailItem;
        [[AppDelegate instance].arrayServerList removeObjectAtIndex:idx.row];
        [[AppDelegate instance].arrayServerList insertObject:@{@"serverDescription": descriptionUI.text,
                                                              @"serverUser": usernameUI.text,
                                                              @"serverPass": passwordUI.text,
                                                              @"serverIP": ipUI.text,
                                                              @"serverPort": portUI.text,
                                                              @"serverMacAddress": macAddress,
                                                              @"preferTVPosters": @(preferTVPostersUI.on),
                                                              @"tcpPort": tcpPortUI.text} atIndex:idx.row];
    }
    [[AppDelegate instance] saveServerList];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate Methods

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField setTextColor:[UIColor blackColor]];
//}
-(void)resignKeyboard{
    [descriptionUI resignFirstResponder];
    [ipUI resignFirstResponder];
    [portUI resignFirstResponder];
    [usernameUI resignFirstResponder];
    [mac_0_UI resignFirstResponder];
    [mac_1_UI resignFirstResponder];
    [mac_2_UI resignFirstResponder];
    [mac_3_UI resignFirstResponder];
    [mac_4_UI resignFirstResponder];
    [mac_5_UI resignFirstResponder];
    [passwordUI resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self resignKeyboard];
    [theTextField resignFirstResponder];
    return YES;
}

-(IBAction)textFieldDoneEditing:(id)sender{
    [self resignKeyboard];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 2 && textField.tag>100){
        if (textField.tag < 106){
            UITextField *next = (UITextField*) [self.view viewWithTag:textField.tag + 1];
            [next becomeFirstResponder];
            [next selectAll:self];
        }
        return NO;
    }
    else{
        return YES;
    }
//    return (newLength > 2 && textField.tag>100) ? NO : YES;
}

# pragma  mark - Gestures

- (void)handleSwipeFromRight:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - NSNetServiceBrowserDelegate Methods

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser{
    searching = YES;
    [self updateUI];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser{
    searching = NO;
    [self updateUI];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary *)errorDict{
    searching = NO;
    [self handleError:errorDict[NSNetServicesErrorCode]];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing {    
    [services addObject:aNetService];
    if(!moreComing) {
        [self stopDiscovery];
        [self updateUI];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing{
    [services removeObject:aNetService];
    if(!moreComing) {
        [self updateUI];
    }
}

- (void)handleError:(NSNumber *)error {
//    NSLog(@"An error occurred. Error code = %d", [error intValue]);
    // Handle error here
}

- (void)updateUI{
    if (!searching) {
        switch ([services count]) {
            case 0:
                [self AnimLabel:noInstances AnimDuration:0.3 Alpha:1.0 XPos:0];
                break;
            case 1:
                [self resolveIPAddress:services[0]];
                break;
            default:
                [discoveredInstancesTableView reloadData];
                [self AnimView:discoveredInstancesView AnimDuration:0.3 Alpha:1.0 XPos:0];
                break;
        }
    }
}

# pragma mark - resolveIPAddress Methods


-(void) resolveIPAddress:(NSNetService *)service {    
    NSNetService *remoteService = service;
    remoteService.delegate = self;
    [remoteService resolveWithTimeout:0];
}
-(void)netServiceDidResolveAddress:(NSNetService *)service {

    for (NSData* data in [service addresses]) {
        char addressBuffer[100];
        struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
        int sockFamily = socketAddress->sin_family;
        if (sockFamily == AF_INET ) {//|| sockFamily == AF_INET6 should be considered
            const char* addressStr = inet_ntop(sockFamily,
                                               &(socketAddress->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));
            int port = ntohs(socketAddress->sin_port);
            if (addressStr && port){
                descriptionUI.text = [service name];
                ipUI.text = [NSString stringWithFormat:@"%s", addressStr];
                portUI.text = [NSString stringWithFormat:@"%d", port];
                
                [descriptionUI setTextColor:[UIColor blueColor]];
                [ipUI setTextColor:[UIColor blueColor]];
                [portUI setTextColor:[UIColor blueColor]];

                [self AnimView:discoveredInstancesView AnimDuration:0.3 Alpha:1.0 XPos:320];

            }
        }
    }
}

-(void)stopDiscovery{
    [netServiceBrowser stop];
    [activityIndicatorView stopAnimating];
    startDiscover.enabled = YES;
}

-(IBAction)startDiscover:(id)sender{
    [self resignKeyboard];
    [activityIndicatorView startAnimating];
    [services removeAllObjects];
    startDiscover.enabled = NO;
    [self AnimLabel:noInstances AnimDuration:0.3 Alpha:0.0 XPos:320];
    [self AnimView:discoveredInstancesView AnimDuration:0.3 Alpha:1.0 XPos:320];

    searching = NO;
    [netServiceBrowser setDelegate:self];
    [netServiceBrowser searchForServicesOfType:serviceType inDomain:domainName];
    timer = [NSTimer scheduledTimerWithTimeInterval:DISCOVER_TIMEOUT target:self selector:@selector(stopDiscovery) userInfo:nil repeats:NO];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [services count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *tableCellIdentifier = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
	}
	
	NSUInteger count = [services count];
	if (count == 0) {
		return cell;
	}
    NSNetService* service = services[indexPath.row];
	cell.textLabel.text = [service name];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self resolveIPAddress:services[indexPath.row]];
}

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    CGSize size = CGSizeMake(320, 380);
    self.contentSizeForViewInPopover = size;
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    netServiceBrowser = nil;
    services = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        self.edgesForExtendedLayout = 0;
    }
    services = [[NSMutableArray alloc] init];
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    rightSwipe.numberOfTouchesRequired = 1;
    rightSwipe.cancelsTouchesInView = NO;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self configureView];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)dealloc{
    services = nil;
    netServiceBrowser = nil;
    descriptionUI = nil;
    ipUI = nil;
    usernameUI = nil;
    passwordUI = nil;
    portUI = nil;
    mac_0_UI = nil;
    mac_1_UI = nil;
    mac_2_UI = nil;
    mac_3_UI = nil;
    mac_4_UI = nil;
    mac_5_UI = nil;
}

@end
