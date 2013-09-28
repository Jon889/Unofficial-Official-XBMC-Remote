//
//  DirectionalPadView.h
//  XBMC Remote
//
//  Created by Jonathan on 25/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DirectionalPadViewDirectionUp,
    DirectionalPadViewDirectionLeft,
    DirectionalPadViewDirectionDown,
    DirectionalPadViewDirectionRight,
    DirectionalPadViewDirectionCenter
    
} DirectionalPadViewDirection;

NSString * NSStringFromDirectionPadViewDirection(DirectionalPadViewDirection direction);

@class DirectionalPadView;
@protocol DirectionalPadViewDelegate <NSObject>
-(void)directionalPadView:(DirectionalPadView *)view firedHoldingInDirection:(DirectionalPadViewDirection)direction;
@optional
-(void)directionalPadView:(DirectionalPadView *)view startedHoldingInDirection:(DirectionalPadViewDirection)direction;
-(void)directionalPadView:(DirectionalPadView *)view stoppedHoldingInDirection:(DirectionalPadViewDirection)direction;
@end

@interface DirectionalPadView : UIView
@property (nonatomic, weak) IBOutlet id<DirectionalPadViewDelegate> delegate;
@property (nonatomic) float fireInterval;
@end
