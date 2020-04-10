//
//  ReactionPickerPresenter.m
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import "ReactionPickerPresenter.h"
#import "ReactionPickerView.h"

@interface ReactionPickerPresenter ()

@property (nonatomic) CGSize reactionIconNormalSize;
@property (nonatomic, nonnull) UILongPressGestureRecognizer *currentActiveLongPress;

@property (nonatomic) CGRect anchorFrameToShowHidePicker;
@property (nonatomic, nonnull) UIView *overlayViewToPreventTapOutside;

@property (nonatomic, nonnull) ReactionPickerView *pickerView;

@property (nonatomic) BOOL allowSecondChance;

@property (nonatomic) BOOL isExiting;

@end


@implementation ReactionPickerPresenter

- (instancetype)initWithReactionNormalSize:(CGSize)size {
    self = [super init];
    if (self) {
        _reactionIconNormalSize = size;
        _reactionIcons = @[];
        _allowSecondChance = YES;
        _isExiting = NO;
    }
    return self;
}

- (void)showPickerViewWithGesture:(UILongPressGestureRecognizer*)gesture
                      viewThatInitRequest:(UIView*)anchorView
                   viewToInsertPickerView:(UIView*)superview {
    
    if (_reactionIcons.count == 0) {
        gesture.state = UIGestureRecognizerStateCancelled;
        return;
    }
    
    _currentActiveLongPress = gesture;
    _anchorFrameToShowHidePicker = [superview convertRect:anchorView.bounds fromView:anchorView];
    
    // TODO: Refactor, body of each switch statement is not at the same abstraction level
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self showPickerViewInView:superview gesture:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self.pickerView reactionSelectDidChangeWithTouchPosition:[gesture locationInView:self.pickerView]];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self onReleaseReactionPickerGesture];
            break;
        default:
            break;
    }
}

- (void)onReleaseReactionPickerGesture {
    NSInteger const selectedIndex = self.pickerView.indexOfSelectedReaction;
    
    if (0 <= selectedIndex && selectedIndex <  _reactionIcons.count) {
        [self handlePickReactionSuccess:selectedIndex];
    } else {
        [self handlePickReactionFail];
    }
    _allowSecondChance = NO;
}

- (void)handlePickReactionSuccess:(NSInteger)reactionIndex {
    // TODO: Notify Delegate didPickReactionAtIndex:reactionIndex; or didCancelAllCurrentReactions
    [self animateReactionPickerExit];
}

- (void)handlePickReactionFail {
    if (!_allowSecondChance) {
        [self animateReactionPickerExit];
    }
}

- (void)animateReactionPickerExit {
    _isExiting = YES;
    CGRect anchorFrameInPickerRelativeFrame = [self.pickerView.superview convertRect:_anchorFrameToShowHidePicker toView:self.pickerView];
    if (CGRectIsNull(anchorFrameInPickerRelativeFrame)) {
        anchorFrameInPickerRelativeFrame = _anchorFrameToShowHidePicker;
    }
    
    CGPoint midPoint = CGPointMake(CGRectGetMidX(anchorFrameInPickerRelativeFrame),
                                   CGRectGetMidY(anchorFrameInPickerRelativeFrame));
    [self.pickerView animateExitMoveSelectedReactionToPosition:midPoint
                                                    completion:^(BOOL finished) {
        
        [self->_overlayViewToPreventTapOutside removeFromSuperview];
        [self.pickerView removeFromSuperview];
    }];
}

- (void)showPickerViewInView:(UIView*)superview
                     gesture:(UILongPressGestureRecognizer*)gesture {
    _allowSecondChance = YES;
    _isExiting = NO;
    
    // TODO: Make these settable
    CGFloat const paddingBetweenButtonAndPickerView = 20;
    CGFloat const paddingFromPickerToTop = 20;
    
    CGSize const pickerSize = [self calculatePickerSize];
    CGFloat const pickerMinX = (superview.bounds.size.width - pickerSize.width) / 2;
    CGFloat pickerMinY = _anchorFrameToShowHidePicker.origin.y - paddingBetweenButtonAndPickerView - pickerSize.height;
    
    BOOL const isShowPickerBelowAnchorView = pickerMinY - paddingFromPickerToTop < 0;
    if (isShowPickerBelowAnchorView) {
        pickerMinY += 2 * paddingBetweenButtonAndPickerView + _anchorFrameToShowHidePicker.size.height + pickerSize.height;
    }
    
    
    CGRect const pickerFrame = CGRectMake(pickerMinX
                                          , pickerMinY, pickerSize.width, pickerSize.height);
    self.pickerView.frame = pickerFrame;
    [superview addSubview:self.pickerView];
    [self.pickerView reactionSelectDidBeginWithTouchPosition:[gesture locationInView:self.pickerView]
                                                 sizePerIcon:_reactionIconNormalSize];
    
    self.overlayViewToPreventTapOutside.frame = superview.bounds;
    [superview addSubview:self.overlayViewToPreventTapOutside];
}

- (CGSize)calculatePickerSize {
    // TODO: Make these settable (horizontal padding and vertical padding must be equal)
    CGFloat const horizontalPaddingBetweenReaction = 8;
    CGFloat const verticalPadding = 8;
    
    CGFloat const numberOfReactions = _reactionIcons.count;
    CGFloat const width = numberOfReactions * _reactionIconNormalSize.width + (numberOfReactions + 1) * horizontalPaddingBetweenReaction;
    CGFloat const height = _reactionIconNormalSize.height + 2 * verticalPadding;
    return CGSizeMake(width, height);
}

- (void)secondChanceLongPressSelector:(UILongPressGestureRecognizer*)gesture {
    if (_allowSecondChance || _isExiting) {
        // Primary long press gesture is still active
        return;
    }
    
    _currentActiveLongPress = gesture;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self.pickerView reactionSelectDidChangeWithTouchPosition:[gesture locationInView:self.pickerView]];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self onReleaseReactionPickerGesture];
            break;
        default:
            break;
    }
}

- (void)setReactionIcons:(NSArray<UIImage *> *)reactionIcons {
    _reactionIcons = reactionIcons;
    self.pickerView.reactionIcons = reactionIcons;
}

- (ReactionPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = ReactionPickerView.new;
    }
    return _pickerView;
}

- (UIView *)overlayViewToPreventTapOutside {
    if (_overlayViewToPreventTapOutside == nil) {
        _overlayViewToPreventTapOutside = UIView.new;
        _overlayViewToPreventTapOutside.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        
        UILongPressGestureRecognizer *secondChanceLongPress = [[UILongPressGestureRecognizer alloc]
                                                               initWithTarget:self
                                                               action:@selector(secondChanceLongPressSelector:)];
        secondChanceLongPress.minimumPressDuration = 0;
        
        [_overlayViewToPreventTapOutside setUserInteractionEnabled:YES];
        [_overlayViewToPreventTapOutside addGestureRecognizer:secondChanceLongPress];
    }
    return _overlayViewToPreventTapOutside;
}

@end
