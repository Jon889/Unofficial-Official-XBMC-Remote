//
//  MoreItemsViewController.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 23/3/12.
//  Copyright (c) 2012 joethefox inc. All rights reserved.
//

#import "MoreItemsViewController.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

#import "BlurredView.h"

@implementation MoreItemsViewController

@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame mainMenu:(NSMutableArray *)menu {
    if (self = [super init]) {
        cellLabelOffset = 50;
		[self.view setFrame:frame];
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        mainMenuItems = menu;
        UIView* footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		_tableView.tableFooterView = footerView;
        BlurredView *background = [[BlurredView alloc] initWithFrame:_tableView.frame];
        [self.view addSubview:background];
//        if (IS_IOS7) {
//            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, cellLabelOffset, 0, 0)];
//        }
		[self.view addSubview:_tableView];
	}
    return self;
}
#pragma mark -
#pragma mark Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 64;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //    return 10;
    return [mainMenuItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
	}
    [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    [cell.textLabel setTextColor:[UIColor colorWithWhite:0.8 alpha:0.9]];
    UIView *sbgv = [[UIView alloc] initWithFrame:cell.bounds];
    [sbgv setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    
    [cell setSelectedBackgroundView:sbgv];
    NSDictionary *item = mainMenuItems[indexPath.row];
    [cell.textLabel setText:item[@"label"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    if (![item[@"icon"] isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_off", item[@"icon"]]];
        if (IS_IOS7) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.imageView setTintColor:[UIColor colorWithWhite:0.8 alpha:0.9]];
        }
        [cell.imageView setImage:image];
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"tabHasChanged" object:indexPath]; 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
