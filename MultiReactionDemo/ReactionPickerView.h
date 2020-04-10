//
//  ReactionPickerView.h
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactionPickerView : UIView

@property (nonatomic, nonnull) NSArray<UIImage*> *reactionIcons;
@property (nonatomic) NSInteger indexOfSelectedReaction;

- (void)reactionSelectDidBeginWithTouchPosition:(CGPoint)position
                                    sizePerIcon:(CGSize)normalIconSize;
- (void)reactionSelectDidChangeWithTouchPosition:(CGPoint)position;
- (void)animateExitMoveSelectedReactionToPosition:(CGPoint)position
                                       completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
