//
//  ReactionCollectionViewCell.h
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiReactionDemo-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReactionCollectionViewCell : UICollectionViewCell

- (void)bindData:(ReactionCellModel*)model;
@property (weak) id<ReactionPickerDelegate> pickerDelegate;


@end

NS_ASSUME_NONNULL_END
