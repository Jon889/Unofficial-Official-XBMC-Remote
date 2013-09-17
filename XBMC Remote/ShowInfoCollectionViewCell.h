//
//  ShowInfoCollectionViewCell.h
//  XBMC Remote
//
//  Created by Jonathan on 16/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowInfoCollectionViewBaseCell.h"

@interface ShowInfoCollectionViewCell : ShowInfoCollectionViewBaseCell
//don't set the text on these, see ShowInfoCollectionViewBaseCell methods.
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
