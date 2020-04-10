//
//  ViewController.m
//  MultiReactionDemo
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

#import "ViewController.h"
#import "ReactionCollectionViewCell.h"
#import "MultiReactionDemo-Swift.h"
#import "ReactionPickerView.h"
#import "ReactionPickerPresenter.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ReactionPickerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *demoCollectionView;

@property (nonnull, nonatomic) NSArray<ReactionCellModel*> *mockData;

@property (nonnull, nonatomic) ReactionPickerPresenter *reactionPickerPresenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _demoCollectionView.delegate = self;
    _demoCollectionView.dataSource = self;
    [_demoCollectionView registerClass:[ReactionCollectionViewCell class]
            forCellWithReuseIdentifier:@"Cell"];
    _mockData = ReactionCellModel.mockData;
}

- (void)didRequestPickReactionWithLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture
                               viewThatInitRequest:(UIView *)viewThatInitRequest {
    [self.reactionPickerPresenter showPickerViewWithGesture:longPressGesture
                                        viewThatInitRequest:viewThatInitRequest
                                     viewToInsertPickerView:self.view];
}

- (void)didIncreaseReactionForCellWithCellModel:(ReactionCellModel *)cellModel {
    [cellModel increaseSelfReactionWithReactionId:@"1"];
    [self.demoCollectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ReactionCollectionViewCell class]]) {
        ReactionCollectionViewCell *reactionCell = (ReactionCollectionViewCell*)cell;
        reactionCell.pickerDelegate = self;
        [reactionCell bindData:[_mockData objectAtIndex:indexPath.item]];
        return reactionCell;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mockData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.bounds.size.width, 50);
    
}

- (ReactionPickerPresenter *)reactionPickerPresenter {
    if (_reactionPickerPresenter == nil) {
        _reactionPickerPresenter = [[ReactionPickerPresenter alloc]
                                    initWithReactionNormalSize:CGSizeMake(40, 40)];
        
        _reactionPickerPresenter.reactionIcons = @[
            [UIImage systemImageNamed:@"bold"],
            [UIImage systemImageNamed:@"italic"],
            [UIImage systemImageNamed:@"underline"],
            [UIImage systemImageNamed:@"strikethrough"],
            [UIImage systemImageNamed:@"questionmark"],
            [UIImage systemImageNamed:@"arrow.3.trianglepath"],
            [UIImage systemImageNamed:@"arrow.clockwise.circle"]
        ];
    }
    return _reactionPickerPresenter;
}

@end
