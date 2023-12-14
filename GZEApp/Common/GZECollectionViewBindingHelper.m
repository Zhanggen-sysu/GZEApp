//
//  GZECollectionViewBindingHelper.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/14.
//

#import "GZECollectionViewBindingHelper.h"
#import "GZERacViewProtocol.h"

@interface GZECollectionViewBindingHelper () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) RACCommand *selectCommand;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *data;

@end


@implementation GZECollectionViewBindingHelper

+ (instancetype)bindCollectionView:(UICollectionView *)collectionView
                      sourceSignal:(RACSignal *)sourceSignal
                     selectCommand:(RACCommand *)selectCommand
                         cellClass:(Class)cellClass
{
    return [[GZECollectionViewBindingHelper alloc] initWithCollectionView:collectionView
                                                             sourceSignal:sourceSignal
                                                            selectCommand:selectCommand
                                                                cellClass:cellClass];
}


- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          sourceSignal:(RACSignal *)sourceSignal
                         selectCommand:(RACCommand *)selectCommand
                             cellClass:(Class)cellClass
{
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.selectCommand = selectCommand;
        @weakify(self)
        [sourceSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.data = (NSArray *)x;
            
            [self.collectionView reloadData];
        }];
        
        self.cellClass = cellClass;
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectCommand) {
        [self.selectCommand execute:@(indexPath.row)];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<GZERacViewProtocol> cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    NSAssert([cell respondsToSelector:@selector(bindViewModel:)], @"cell should implement bindViewModel");
    [cell bindViewModel:self.data[indexPath.row]];
    return (UICollectionViewCell *)cell;
}

@end
