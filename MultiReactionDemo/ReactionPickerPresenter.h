//
//  ReactionPickerPresenter.h
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactionPickerPresenter : NSObject

- (instancetype)initWithReactionNormalSize:(CGSize)size;
- (void)showPickerViewWithGesture:(UILongPressGestureRecognizer*)gesture
                      viewThatInitRequest:(UIView*)anchorView
                   viewToInsertPickerView:(UIView*)superview;

@property (nonnull, nonatomic) NSArray<UIImage*> *reactionIcons;

@end

NS_ASSUME_NONNULL_END
