//
//  GZETrendingCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZETrendingCell.h"
#import "SDCycleScrollView.h"
#import "GZETrendingViewModel.h"
#import "GZECommonHelper.h"

@interface GZETrendingCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@end

@implementation GZETrendingCell

- (void)updateWithModel:(GZETrendingViewModel *)model;
{
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
    
}


@end
