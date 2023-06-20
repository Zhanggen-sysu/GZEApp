//
//  GZESearchResultVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import "GZESearchResultVC.h"
#import "Macro.h"
#import "Masonry.h"
#import "GZETmdbListManager.h"
#import "GZEFilterViewModel.h"
#import "GZEMovieListItem.h"
#import "GZETVListItem.h"
#import "GZEDiscoverCell.h"
#import "GZEDetailListCell.h"
#import "GZEDiscoverCellViewModel.h"
#import "GZEGlobalConfig.h"
#import "GZEMovieListRsp.h"
#import "GZETVListRsp.h"
#import "GZECommonHelper.h"
#import "GZEMovieDetailVC.h"
#import "GZETVDetailVC.h"
#import "MJRefresh.h"
#import "GZECustomScrollView.h"
#import <TTGTextTagCollectionView.h>
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZESearchResultVC () <YPNavigationBarConfigureStyle, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TTGTextTagCollectionView *filterView;
@property (nonatomic, strong) TTGTextTagStyle *style;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *segmentBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) GZECustomScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) GZETVDiscoveryReq *tvReq;
@property (nonatomic, strong) GZEMovieDiscoveryReq *movieReq;
@property (nonatomic, strong) GZETmdbListManager *manager;
@property (nonatomic, assign) GZEMediaType currentMediaType;

@property (nonatomic, strong) GZEFilterViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray<GZEMovieListItem *> *movieList;
@property (nonatomic, strong) NSMutableArray<GZETVListItem *> *tvList;
@property (nonatomic, assign) BOOL mainCanScroll;
@property (nonatomic, assign) BOOL listCanScroll;

@end

@implementation GZESearchResultVC

- (instancetype)initWithViewModel:(GZEFilterViewModel *)viewModel
{
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.title = @"Find Movies And TV Shows";
        self.mainCanScroll = YES;
        self.listCanScroll = NO;
    }
    return self;
}

- (void)initLoadingData
{
    [self.viewModel.filterArray enumerateObjectsUsingBlock:^(GZEFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selectIndexs.count <= 0) {
            return;
        }
        NSString *text = [GZEFilterModel getTextWithModel:obj];
        switch (obj.filterType) {
            case GZEFilterType_MediaType:
            {
                if ([text isEqualToString:@"movie"]) {
                    self.currentMediaType = GZEMediaType_Movie;
                } else if ([text isEqualToString:@"tv"]) {
                    self.currentMediaType = GZEMediaType_TV;
                }
            }
                break;
            case GZEFilterType_Language:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.withOriginalLanguage = text;
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.withOriginalLanguage = text;
                }
            }
                break;
            case GZEFilterType_Genre:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.withGenres = text;
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.withGenres = text;
                }
            }
                break;
            case GZEFilterType_Decade:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.releaseDateGte = [NSString stringWithFormat:@"%@-01-01", text];
                    self.movieReq.releaseDateLTE = [NSString stringWithFormat:@"%ld-12-31", text.integerValue + 10];
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.firstAirDateGte = [NSString stringWithFormat:@"%@-01-01", text];
                    self.tvReq.firstAirDateLTE = [NSString stringWithFormat:@"%ld-12-31", text.integerValue + 10];
                }
            }
                break;
            case GZEFilterType_Year:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.primaryReleaseYear = @(text.integerValue);
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.firstAirDateYear = @(text.integerValue);
                }
            }
                break;
            case GZEFilterType_VoteCount:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.voteCountGte = @(text.integerValue);
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.voteCountGte = @(text.integerValue);
                }
            }
                break;
            case GZEFilterType_VoteAverage:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    self.movieReq.voteAverageGte = @(text.integerValue);
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    self.tvReq.voteAverageGte = @(text.integerValue);
                }
            }
                break;
            case GZEFilterType_Runtime:
            {
                if (self.currentMediaType == GZEMediaType_Movie) {
                    NSNumber* currentIndex = obj.selectIndexs.firstObject;
                    self.movieReq.withRuntimeLTE = @(text.integerValue);
                    self.movieReq.withRuntimeGte = currentIndex.integerValue - 1 >= 0 ? @(obj.array[currentIndex.integerValue - 1].key.integerValue) : nil;
                } else if (self.currentMediaType == GZEMediaType_TV) {
                    NSNumber* currentIndex = obj.selectIndexs.firstObject;
                    self.tvReq.withRuntimeLTE = @(text.integerValue);
                    self.tvReq.withRuntimeGte = currentIndex.integerValue - 1 >= 0 ? @(obj.array[currentIndex.integerValue - 1].key.integerValue) : nil;
                }
            }
                break;
            default:
                break;
        }
    }];
    [self loadDataWithLoadMore:NO];
}

- (void)loadDataWithLoadMore:(BOOL)loadMore
{
    if (self.currentMediaType == GZEMediaType_Movie) {
        [self.movieReq stop];
        WeakSelf(self)
        [self.manager getMovieDiscoverWithReq:self.movieReq
                                     loadMore:loadMore
                                        block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            [self.tableView.mj_footer endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                self.textLabel.text = [NSString stringWithFormat:@"Total Result: %ld", response.totalResults];
                if (loadMore) {
                    if (response.results.count <= 0) {
                        [GZECommonHelper showMessage:@"No More Data" inView:self.view duration:1.5];
                        return;
                    }
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    NSInteger cnt = self.movieList.count;
                    [self.movieList addObjectsFromArray:response.results];
                    [response.results enumerateObjectsUsingBlock:^(GZEMovieListItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:0]];
                    }];
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } else {
                    self.movieList = [[NSMutableArray alloc] initWithArray:response.results];
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                }
            } else {
                [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
            }
        }];
    } else if (self.currentMediaType == GZEMediaType_TV) {
        [self.tvReq stop];
        WeakSelf(self)
        [self.manager getTVDiscoverWithReq:self.tvReq
                                  loadMore:loadMore
                                     block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            [self.tableView.mj_footer endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (isSuccess) {
                GZETVListRsp *response = (GZETVListRsp *)rsp;
                self.textLabel.text = [NSString stringWithFormat:@"Total Result: %ld", response.totalResults];
                if (loadMore) {
                    if (response.results.count <= 0) {
                        [GZECommonHelper showMessage:@"No More Data" inView:self.view duration:1.5];
                        return;
                    }
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    NSInteger cnt = self.tvList.count;
                    [self.tvList addObjectsFromArray:response.results];
                    [response.results enumerateObjectsUsingBlock:^(GZETVListItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:0]];
                    }];
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } else {
                    self.tvList = [[NSMutableArray alloc] initWithArray:response.results];
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                }
            } else {
                [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [self defineLayout];
    [self updateTagUI];
    [self initLoadingData];
}

- (void)updateTagUI
{
    [self.viewModel.filterArray enumerateObjectsUsingBlock:^(GZEFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selectIndexs.count <= 0) {
            return;
        }
        [obj.selectIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull index, NSUInteger idx, BOOL * _Nonnull stop) {
            GZEFilterItem *item = obj.array[index.integerValue];
            [self.tagArray addObject:item];
            TTGTextTagStringContent *text = [TTGTextTagStringContent contentWithText:item.value];
            text.textFont = kFont(15.f);
            text.textColor = RGBColor(128, 128, 128);
            TTGTextTag *textTag = [TTGTextTag tagWithContent:text style:self.style];
            [self.filterView addTag:textTag];
        }];
    }];
    [self.filterView reload];
}

- (void)setupSubviews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.filterView];
    [self.contentView addSubview:self.sectionView];
    
    [self.sectionView addSubview:self.textLabel];
    [self.sectionView addSubview:self.filterBtn];
    [self.sectionView addSubview:self.segmentBtn];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.collectionView];
}

- (void)defineLayout
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view);
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(10.f);
        make.trailing.equalTo(self.contentView).offset(-10.f);
    }];
    [self.sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(48.f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionView);
        make.leading.equalTo(self.sectionView).offset(10.f);
    }];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionView);
        make.trailing.equalTo(self.sectionView).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
    [self.segmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionView);
        make.trailing.equalTo(self.filterBtn.mas_leading).offset(-5.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.equalTo(self.scrollView);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.scrollView);
        make.leading.equalTo(self.contentView).offset(10.f);
        make.trailing.equalTo(self.contentView).offset(-10.f);
    }];
}

- (void)didTapSegmentBtn
{
    [self.segmentBtn setSelected:!self.segmentBtn.isSelected];
    if (!self.segmentBtn.isSelected) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
}

- (GZECustomScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[GZECustomScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        // Tips: 去除scrollView顶部空白区域
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = [UIColor whiteColor];
    }
    return _sectionView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = kFont(15.f);
        _textLabel.textColor = [UIColor blackColor];
    }
    return _textLabel;
}

- (UIButton *)segmentBtn
{
    if (!_segmentBtn) {
        _segmentBtn = [[UIButton alloc] init];
        [_segmentBtn setImage:kGetImage(@"layout-line-fill") forState:UIControlStateNormal];
        [_segmentBtn setImage:kGetImage(@"layout-grid-fill") forState:UIControlStateSelected];
        [_segmentBtn addTarget:self action:@selector(didTapSegmentBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _segmentBtn;
}

- (UIButton *)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [[UIButton alloc] init];
        [_filterBtn setImage:kGetImage(@"filter-fill") forState:UIControlStateNormal];
        [_filterBtn addTarget:self action:@selector(didTapFilterBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WeakSelf(self)
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            StrongSelfReturnNil(self)
            [self loadDataWithLoadMore:YES];
        }];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = (SCREEN_WIDTH - 30) / 2;
        layout.itemSize = CGSizeMake(width, width * 1.5 + 64);
        layout.minimumInteritemSpacing = 10.f;
        layout.minimumLineSpacing = 10.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden = YES;
        WeakSelf(self)
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            StrongSelfReturnNil(self)
            [self loadDataWithLoadMore:YES];
        }];
        [_collectionView registerClass:[GZEDetailListCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class])];
    }
    return _collectionView;
}

- (TTGTextTagCollectionView *)filterView
{
    if (!_filterView) {
        _filterView = [[TTGTextTagCollectionView alloc] init];
        _filterView.horizontalSpacing = 10;
    }
    return _filterView;
}

- (GZETmdbListManager *)manager
{
    if (!_manager) {
        _manager = [[GZETmdbListManager alloc] init];
    }
    return _manager;
}

- (GZETVDiscoveryReq *)tvReq
{
    if (!_tvReq) {
        _tvReq = [[GZETVDiscoveryReq alloc] init];
    }
    return _tvReq;
}

- (GZEMovieDiscoveryReq *)movieReq
{
    if (!_movieReq) {
        _movieReq = [[GZEMovieDiscoveryReq alloc] init];
    }
    return _movieReq;
}

- (NSMutableArray *)tagArray
{
    if (!_tagArray) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    return _tagArray;
}

- (TTGTextTagStyle *)style
{
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = RGBColor(245, 245, 245);
        _style.borderWidth = 0;
        _style.shadowOffset = CGSizeMake(0, 0);
        _style.shadowRadius = 0;
        _style.cornerRadius = 10;
        _style.extraSpace = CGSizeMake(20, 10);
    }
    return _style;
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentMediaType == GZEMediaType_TV) {
        return self.tvList.count;
    }
    return self.movieList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEDiscoverCell class])];
    if (!cell) {
        cell = [[GZEDiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEDiscoverCell class])];
        WeakSelf(self)
        WeakSelf(cell)
        cell.didChangeHeight = ^(BOOL isExpand) {
            StrongSelfReturnNil(self)
            StrongSelfReturnNil(cell)
            // 获取修改cell的IndexPath的正确姿势，不能直接用indexPath
            NSIndexPath *changeIndexPath = [tableView indexPathForCell:cell];
            if (self.currentMediaType == GZEMediaType_Movie) {
                self.movieList[indexPath.row].isExpand = isExpand;
            } else if (self.currentMediaType == GZEMediaType_TV) {
                self.tvList[indexPath.row].isExpand = isExpand;
            }
            // 更新该行的高度
            [self.tableView reloadRowsAtIndexPaths:@[changeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    if (self.currentMediaType == GZEMediaType_Movie) {
        GZEMovieListItem *item = self.movieList[indexPath.row];
        [cell updateWithModel:[GZEDiscoverCellViewModel viewModelWithMovieItem:item]];
    } else if (self.currentMediaType == GZEMediaType_TV) {
        GZETVListItem *item = self.tvList[indexPath.row];
        [cell updateWithModel:[GZEDiscoverCellViewModel viewModelWithTVItem:item]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentMediaType == GZEMediaType_Movie) {
        GZEMovieListItem *item = self.movieList[indexPath.row];
        GZEMovieDetailVC *vc = [[GZEMovieDetailVC alloc] initWithMovieId:item.identifier];
        // tips: 下一页的返回按钮需要在上一页设置才有效
        self.navigationItem.backButtonTitle = @"";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.currentMediaType == GZEMediaType_TV) {
        GZETVListItem *item = self.tvList[indexPath.row];
        GZETVDetailVC *vc = [[GZETVDetailVC alloc] initWithTVId:item.identifier];
        // tips: 下一页的返回按钮需要在上一页设置才有效
        self.navigationItem.backButtonTitle = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate, DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.currentMediaType == GZEMediaType_TV) {
        return self.tvList.count;
    }
    return self.movieList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDetailListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class]) forIndexPath:indexPath];
    if (self.currentMediaType == GZEMediaType_Movie) {
        GZEMovieListItem *item = self.movieList[indexPath.row];
        [cell updateWithModel:item magicColor:[UIColor whiteColor]];
    } else if (self.currentMediaType == GZEMediaType_TV) {
        GZETVListItem *item = self.tvList[indexPath.row];
        [cell updateWithTVModel:item magicColor:[UIColor whiteColor]];
    }
    return cell;
}

#pragma mark - YPNavigationBarConfigureStyle
- (YPNavigationBarConfigurations)yp_navigtionBarConfiguration {
    return YPNavigationBarShow | YPNavigationBarBackgroundStyleOpaque | YPNavigationBarBackgroundStyleColor;
}

- (UIColor *)yp_navigationBarTintColor {
    return [UIColor blackColor];
}

- (UIColor *)yp_navigationBackgroundColor {
    return [UIColor whiteColor];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if (self.mainCanScroll) {
            if (scrollView.contentOffset.y >= self.filterView.contentSize.height + 20) {
                // 主scrollView到达临界点，启动子scrollView
                self.scrollView.contentOffset = CGPointMake(0, self.filterView.contentSize.height + 20);
                self.mainCanScroll = NO;
                self.listCanScroll = YES;
            }
        } else {
            self.scrollView.contentOffset = CGPointMake(0, self.filterView.contentSize.height + 20);
            CGPoint point = [scrollView.panGestureRecognizer translationInView:self.view];
            // 下滑时，如果子scrollView已经到了临界点，则启动父scrollView
            if (point.y > 0 && ((!self.segmentBtn.isSelected && self.tableView.contentOffset.y == 0) || (self.segmentBtn.isSelected && self.collectionView.contentOffset.y == 0))) {
                self.mainCanScroll = YES;
                self.listCanScroll = NO;
            }
        }
    } else {
        if (self.listCanScroll) {
            if (scrollView.contentOffset.y <= 0) {
                // 子scrollView回滑到临界点
                scrollView.contentOffset = CGPointZero;
                self.mainCanScroll = YES;
                self.listCanScroll = NO;
            }
        } else {
            scrollView.contentOffset = CGPointZero;
        }
    }
}
@end
