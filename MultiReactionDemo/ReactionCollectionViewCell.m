//
//  ReactionCollectionViewCell.m
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import "ReactionCollectionViewCell.h"

@interface ReactionCollectionViewCell ()

@property (nonnull, nonatomic) UILabel* totalCountLabel;
@property (nonnull, nonatomic) UIButton* reactionPickerButton;
@property (nonnull, nonatomic) ReactionCellModel *reactionCountEntity;

@end

@implementation ReactionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.contentView addSubview:self.totalCountLabel];
        [self.contentView addSubview:self.reactionPickerButton];
        
        self.contentView.backgroundColor = UIColor.darkGrayColor;
    }
    return self;
}

- (void)bindData:(ReactionCellModel *)model {
    _reactionCountEntity = model;
    _totalCountLabel.text = [NSString stringWithFormat:@"%ld", (long)model.totalReactionCount];
}

- (void)onReactionPickerLongPress:(UILongPressGestureRecognizer *)gesture {
    [_pickerDelegate didRequestPickReactionWithLongPressGesture:gesture
                                            viewThatInitRequest:_reactionPickerButton];
}

- (void)onAddReactionTap:(UITapGestureRecognizer*)gesture {
    [_pickerDelegate didIncreaseReactionForCellWithCellModel:self.reactionCountEntity];
}

- (UILabel *)totalCountLabel {
    if (_totalCountLabel == nil) {
        _totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 20)];
        _totalCountLabel.backgroundColor = UIColor.whiteColor;
        _totalCountLabel.textColor = UIColor.blackColor;
    }
    return _totalCountLabel;
}

- (UIButton *)reactionPickerButton {
    if (_reactionPickerButton == nil) {
        _reactionPickerButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 15, 80, 20)];
        _reactionPickerButton.backgroundColor = UIColor.redColor;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(onReactionPickerLongPress:)];
        [_reactionPickerButton addGestureRecognizer:longPressGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(onAddReactionTap:)];
        [_reactionPickerButton addGestureRecognizer:tapGesture];
    }
    return _reactionPickerButton;
}

@end
