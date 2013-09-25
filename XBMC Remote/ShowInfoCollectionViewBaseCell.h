//
//  ShowInfoCollectionViewBaseCell.h
//  XBMC Remote
//
//  Created by Jonathan on 17/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowInfoCollectionViewBaseCell : UICollectionViewCell
+(CGSize)initialSizeOfCellForWidth:(CGFloat)width;
-(CGSize)sizeOfCellForWidth:(CGFloat)width;
-(void)setTitle:(NSString *)title;
-(void)setContent:(id)content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
