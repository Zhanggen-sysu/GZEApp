//
//  GZETrendingCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZETrendingCell.h"
#import "SDCycleScrollView.h"
#import "GZETrendingViewModel.h"
#import "GZETrendingItem.h"
#import "GZECommonHelper.h"

@interface GZETrendingCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) GZETrendingViewModel *viewModel;

@end

@implementation GZETrendingCell

- (void)updateWithModel:(GZETrendingViewModel *)model
{
    self.viewModel = model;
    self.cycleView.imageURLStringsGroup = model.imgUrls;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.cycleView];
}

- (void)defineLayout
{
}

- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 1.5) delegate:self placeholderImage:kGetImage(@"default-poster")];
        _cycleView.autoScrollTimeInterval = 8;
    }
    return _cycleView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    GZETrendingItem *item = self.viewModel.media[index];
    if ([item.mediaType isEqualToString:@"tv"]) {
        !self.didTapItem ?: self.didTapItem(item.identifier, GZEMediaType_TV);
    } else if ([item.mediaType isEqualToString:@"movie"]) {
        !self.didTapItem ?: self.didTapItem(item.identifier, GZEMediaType_Movie);
    }
}


@end
