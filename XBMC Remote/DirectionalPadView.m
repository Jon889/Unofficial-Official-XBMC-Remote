//
//  DirectionalPadView.m
//  XBMC Remote
//
//  Created by Jonathan on 25/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "DirectionalPadView.h"
#import "OBShapedButton.h"




NSString * NSStringFromDirectionPadViewDirection(DirectionalPadViewDirection direction) {
    static NSString * const directionStrings[] = { @"up", @"left", @"down", @"right", @"center" };
    return directionStrings[direction];
}

@interface DirectionalPadView ()
@property (nonatomic, strong) OBShapedButton *upButton;
@property (nonatomic, strong) OBShapedButton *leftButton;
@property (nonatomic, strong) OBShapedButton *downButton;
@property (nonatomic, strong) OBShapedButton *rightButton;
@property (nonatomic, strong) OBShapedButton *centerButton;
@property (nonatomic, strong) NSMutableArray *heldButtons;
@property (nonatomic, strong) NSTimer *fireTimer;
@end
@implementation DirectionalPadView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fireInterval = 0.5;
        self.heldButtons = [NSMutableArray array];
        
        self.upButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [self.upButton setTag:DirectionalPadViewDirectionUp];
        
        self.leftButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setTag:DirectionalPadViewDirectionLeft];
        
        self.downButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [self.downButton setTag:DirectionalPadViewDirectionDown];
        
        self.rightButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton setTag:DirectionalPadViewDirectionRight];
        
        self.centerButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [self.centerButton setTag:DirectionalPadViewDirectionCenter];
        
        [@[self.upButton, self.leftButton, self.downButton, self.rightButton, self.centerButton] enumerateObjectsUsingBlock:^(OBShapedButton *obj, NSUInteger idx, BOOL *stop) {
            [self addSubview:obj];
            NSString *directionString = NSStringFromDirectionPadViewDirection(obj.tag);
            [obj setImage:[UIImage imageNamed:[NSString stringWithFormat:@"remote_button_%@_up", directionString]] forState:UIControlStateNormal];
            [obj setImage:[UIImage imageNamed:[NSString stringWithFormat:@"remote_button_%@_down", directionString]] forState:UIControlStateHighlighted];
            [obj addTarget:self action:@selector(touchDownButton:) forControlEvents:UIControlEventTouchDown];
            [obj addTarget:self action:@selector(touchUpButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
            obj.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            obj.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        }];
        
    }
    return self;
}
-(void)touchDownButton:(OBShapedButton *)button {
    [button.superview sendSubviewToBack:button];
    [self.heldButtons addObject:@(button.tag)];
    if (!self.fireTimer) {
        self.fireTimer = [NSTimer scheduledTimerWithTimeInterval:self.fireInterval target:self selector:@selector(fired) userInfo:nil repeats:YES];
        [self.fireTimer fire];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(directionalPadView:startedHoldingInDirection:)]) {
        [self.delegate directionalPadView:self startedHoldingInDirection:button.tag];
    }
}
-(void)fired {
    for (NSNumber *direction in self.heldButtons) {
        [self.delegate directionalPadView:self firedHoldingInDirection:[direction integerValue]];
    }
}
-(void)touchUpButton:(OBShapedButton *)button {
    [self.heldButtons removeObject:@(button.tag)];
    if (self.heldButtons.count == 0) {
        [self.fireTimer invalidate];
        self.fireTimer = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(directionalPadView:stoppedHoldingInDirection:)]) {
        [self.delegate directionalPadView:self stoppedHoldingInDirection:button.tag];
    }
}

-(void)setFrame:(CGRect)frame {
    frame.size.height = frame.size.width;
    [super setFrame:frame];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat widthHeightRatio = self.rightButton.imageView.image.size.height/self.rightButton.imageView.image.size.width;
    //side = height + width;
    //width = widthHeightRatio * height;
    //side = height + widthHeightRatio * height;
    //side = height(1 + widthHeightRatio);
    //width and height corresponds to up and down button
    CGFloat side = self.frame.size.width;
    CGFloat height = side/(1 + widthHeightRatio);
    CGFloat width = side - height;
    CGFloat halfHeight = height/2.0;
    self.upButton.frame = CGRectMake(halfHeight, 0, width, height);
    self.leftButton.frame = CGRectMake(0, halfHeight, height, width);
    self.downButton.frame = CGRectMake(halfHeight, side - height, width, height);
    self.rightButton.frame = CGRectMake(side - height, halfHeight, height, width);
    self.centerButton.center = CGPointMake(side/2, side/2);
    
    //to make it more confusing, I'm using the left arrow as a reference, unlike above which uses the up/down button
    //ox = 177; //ow = 220
    //nx = ox/ow * nw
    CGFloat nx = 177.0/220.0 * height;
    CGFloat centersize = side - nx - nx;
    self.centerButton.bounds = CGRectMake(0, 0, centersize, centersize);
}
@end
