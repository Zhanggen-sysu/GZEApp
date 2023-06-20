//
//  GZESearchAdvanceView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZESearchAdvanceView.h"
#import "GZEFilterAdvanceView.h"
#import "GZEMovieDiscoveryReq.h"
#import "GZETVDiscoveryReq.h"
#import "GZEGlobalConfig.h"

@interface GZESearchAdvanceView () <GZEFilterAdvanceViewDelegate>

@property (nonatomic, strong) GZEFilterAdvanceView *filterView;
@property (nonatomic, strong) GZETVDiscoveryReq *tvReq;
@property (nonatomic, strong) GZEMovieDiscoveryReq *movieReq;

@end

@implementation GZESearchAdvanceView

- (UIView *)listView
{
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.filterView];
}

- (void)defineLayout
{
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (GZEFilterAdvanceView *)filterView
{
    if (!_filterView) {
        GZEFilterType filterTypes = GZEFilterType_MediaType|GZEFilterType_Language|GZEFilterType_Genre|GZEFilterType_Decade|GZEFilterType_Year|GZEFilterType_VoteCount|GZEFilterType_VoteAverage|GZEFilterType_Runtime;
        _filterView = [[GZEFilterAdvanceView alloc] initWithFilterType:filterTypes];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (GZEMovieDiscoveryReq *)movieReq
{
    if (!_movieReq) {
        _movieReq = [[GZEMovieDiscoveryReq alloc] init];
    }
    return _movieReq;
}

- (GZETVDiscoveryReq *)tvReq
{
    if (!_tvReq) {
        _tvReq = [[GZETVDiscoveryReq alloc] init];
    }
    return _tvReq;
}

#pragma mark - GZEFilterAdvanceViewDelegate
- (void)filterAdvanceView:(nonnull GZEFilterAdvanceView *)filterView viewModel:(nonnull GZEFilterViewModel *)viewModel
{
    if ([self.delegate respondsToSelector:@selector(searchAdvanceViewConfirm:)]) {
        [self.delegate searchAdvanceViewConfirm:viewModel];
    }
}

@end
