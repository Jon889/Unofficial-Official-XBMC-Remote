//
//  ShowInfoCollectionViewFlowLayout.h
//  XBMC Remote
//
//  Created by Jonathan on 18/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowInfoCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic) BOOL floatLeft;//default YES
@property (nonatomic, strong) NSArray *indexPathsToFloat;
@end
