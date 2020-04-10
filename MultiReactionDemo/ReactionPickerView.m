//
//  ReactionPickerView.m
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import "ReactionPickerView.h"

@interface ReactionPickerView ()

@property (nonatomic, nonnull) UIView *backgroundView;

@property (nonatomic) BOOL allowTouchFlop;

@property (nonatomic, nonnull) NSArray<UIButton *> *reactionIconViews;

@property (nonatomic) CGSize normalIconSize;

@property (nonatomic) CGPoint firstTouchPosition;

@end


@implementation ReactionPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.backgroundView];
        _allowTouchFlop = NO;
        _indexOfSelectedReaction = -1;
        _firstTouchPosition = CGPointZero;
    }
    return self;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)reactionSelectDidBeginWithTouchPosition:(CGPoint)position
                                    sizePerIcon:(CGSize)normalIconSize {
    _firstTouchPosition = position;
    _allowTouchFlop = YES;
    
    self.backgroundView.frame = self.bounds;
    self.backgroundView.alpha = 1;
    self.backgroundView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.backgroundView.layer.shadowOpacity = 0.3;
    self.backgroundView.layer.shadowRadius = 2;
    self.backgroundView.layer.shadowOffset = CGSizeMake(2, 2);
    self.backgroundView.layer.cornerRadius = 16;
    
    for (NSUInteger i = 0; i < _reactionIconViews.count; ++i) {
        [[_reactionIconViews objectAtIndex:i] removeFromSuperview];
    }
    
    _normalIconSize = normalIconSize;
    CGFloat const maxIconDimen = [self maxIconDimenWithNormalIconSize:_normalIconSize];
    
    NSMutableArray<UIButton *> *iconViews = NSMutableArray.new;
    for (NSUInteger i = 0; i < _reactionIcons.count; ++i) {
        UIButton *iconView = UIButton.new;
        iconView.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        iconView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // Resize Image fitting biggest size
        UIImage *image = [self imageWithImage:[_reactionIcons objectAtIndex:i] convertToSize:CGSizeMake(maxIconDimen, maxIconDimen)];
        [iconView setImage:image forState:UIControlStateNormal];
        
        [iconViews addObject:iconView];
        [self addSubview:iconView];
    }
    _indexOfSelectedReaction = -1;
    _reactionIconViews = iconViews;
    
    [self layoutReactionIconViews];
    [self animateEntrance];
}

- (void)animateEntrance {
    CGRect const originalFrame = self.frame;
    self.alpha = 0.3;
    self.frame = CGRectOffset(originalFrame, 0, 30);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = originalFrame;
        self.alpha = 1;
    }];
}

- (void)animateExitMoveSelectedReactionToPosition:(CGPoint)position
                                       completion:(void (^ __nullable)(BOOL finished))completion {
    
    CGRect const backgroundViewFrame = _backgroundView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self->_backgroundView.alpha = 0;
        self->_backgroundView.frame = CGRectOffset(backgroundViewFrame, 0, 30);
        
        for (NSUInteger index = 0; index < self->_reactionIconViews.count; ++index) {
            UIButton *iconView = [self->_reactionIconViews objectAtIndex:index];
            if (index == self->_indexOfSelectedReaction) {
                // Set size = 0 make button disappear immediately, why?
                iconView.frame = CGRectMake(position.x - 5, position.y - 5, 10, 10);
            } else {
                iconView.frame = CGRectOffset(iconView.frame, 0, 30);
            }
            
            iconView.alpha = 0.3;
        }
        
    } completion:completion];
}

- (void)layoutReactionIconViews {
    if (0 <= _indexOfSelectedReaction && _indexOfSelectedReaction < _reactionIconViews.count) {
        [self layoutIconViewsWithBigIconAtIndex:_indexOfSelectedReaction];
    } else {
        [self layoutAllNormalIconViews];
    }
}

- (void)layoutAllNormalIconViews {
    // TODO: Make this settable
    CGFloat const horizontalPadding = 8;
    CGFloat const verticalPadding = 8;
    
    for (NSUInteger iconViewIndex = 0; iconViewIndex < _reactionIconViews.count; ++iconViewIndex) {
        UIButton *iconView = [_reactionIconViews objectAtIndex:iconViewIndex];
        iconView.frame = CGRectMake(horizontalPadding * (iconViewIndex + 1) + iconViewIndex * _normalIconSize.width - horizontalPadding / 2,
                                    verticalPadding,
                                    _normalIconSize.width + horizontalPadding,
                                    _normalIconSize.height);
    }
}

- (void)layoutIconViewsWithBigIconAtIndex:(long)bigIconIndex {
    BOOL foundBigIcon = NO;
    // TODO: Make this settable
    CGFloat const horizontalPadding = 8;
    
    CGFloat const maxIconDimen = [self maxIconDimenWithNormalIconSize:_normalIconSize];
    CGFloat const minIconDimen = [self minIconDimenWithNormalIconSize:_normalIconSize];
    CGPoint const boundsOrigin = self.bounds.origin;
    CGSize const boundsSize = self.bounds.size;
    CGFloat const positionBot = boundsOrigin.y + boundsSize.height - (boundsSize.height - minIconDimen) / 2;
    
    // TODO: Frame calculation based on assumption of max/minSize algorithm, to use abirtary size, review this section
    for (NSUInteger iconViewIndex = 0; iconViewIndex < _reactionIconViews.count; ++iconViewIndex) {
        UIButton *iconView = [_reactionIconViews objectAtIndex:iconViewIndex];
        
        CGRect iconViewFrame;
        if (iconViewIndex == _indexOfSelectedReaction) {
            foundBigIcon = YES;
            iconViewFrame = CGRectMake(horizontalPadding * (iconViewIndex + 1) + iconViewIndex * minIconDimen - horizontalPadding / 2,
                                       positionBot - maxIconDimen,
                                       maxIconDimen,
                                       maxIconDimen);
        } else {
            CGFloat offsetDueToBigIcon = foundBigIcon ? (maxIconDimen - minIconDimen) : 0;
            iconViewFrame = CGRectMake(horizontalPadding * (iconViewIndex + 1) + iconViewIndex * minIconDimen + offsetDueToBigIcon - horizontalPadding / 2,
                                       positionBot - minIconDimen,
                                       minIconDimen + horizontalPadding,
                                       minIconDimen);
        }
        
        iconView.frame = iconViewFrame;
    }
}

- (void)reactionSelectDidChangeWithTouchPosition:(CGPoint)position {
    CGFloat allowableFlopAmount = 0.5 * _normalIconSize.width;
    CGFloat distanceX = fabs(position.x - _firstTouchPosition.x);
    CGFloat distanceY = fabs(position.y - _firstTouchPosition.y);
    
    CGFloat totalOffsetAmount = sqrt(distanceX * distanceX + distanceY * distanceY);
    
    if (_allowTouchFlop && totalOffsetAmount <= allowableFlopAmount) {
        return;
    }
    _allowTouchFlop = NO;
    
    _indexOfSelectedReaction = [self selectSuitableReactionWithTouchPosition:position];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutReactionIconViews];
    }];
}

- (NSInteger)selectSuitableReactionWithTouchPosition:(CGPoint)position {
    if ([self isTouchPositionOutOfBound:position]) {
        return -1;
    }
    
    for (NSUInteger index = 0; index < _reactionIconViews.count; ++index) {
        UIButton *iconView = [_reactionIconViews objectAtIndex:index];
        if (CGRectGetMinX(iconView.frame) < position.x && position.x < CGRectGetMaxX(iconView.frame)) {
            return index;
        }
    }
    return -1;
}

- (BOOL) isTouchPositionOutOfBound:(CGPoint)position {
    return (position.x > CGRectGetMaxX(self.bounds) + _normalIconSize.width ||
            position.x < CGRectGetMinX(self.bounds) - _normalIconSize.width ||
            position.y > CGRectGetMaxY(self.bounds) + 2 * _normalIconSize.height ||
            position.y < CGRectGetMinY(self.bounds) - _normalIconSize.height);
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
    }
    return _backgroundView;
}

// Min/Max Icon size = formula such that horizontal padding and padding to bottom
// remains the same during the transition
- (CGFloat)maxIconDimenWithNormalIconSize:(CGSize)normalIconSize {
    // TODO: Make this settable (must be equal to padding from ReactionPickerPresenter)
    CGFloat const horizontalPaddingBetweenReaction = 8;
    CGFloat const count = _reactionIcons.count;
    return 3 * count * ((horizontalPaddingBetweenReaction + normalIconSize.width) - horizontalPaddingBetweenReaction) / (2 * count + 1);
    return 60;
}

- (CGFloat)minIconDimenWithNormalIconSize:(CGSize)normalIconSize {
    CGFloat const count = _reactionIcons.count;
    CGFloat maxIconDimen = [self maxIconDimenWithNormalIconSize:normalIconSize];
    return (normalIconSize.width * count - maxIconDimen) / (count - 1);
    return 20;
}

@end
