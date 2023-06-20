//
//  GZEImageBrowser.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/13.
//

#import "GZEImageBrowser.h"
#import "GZEImageBrowserCell.h"
#import "UIImageView+WebCache.h"
#import "GZEImageBrowserScrollView.h"

#define kGapWidth 20

@interface GZEImageBrowser () <UICollectionViewDelegate, UICollectionViewDataSource>
// UI
@property (nonatomic, strong) UILabel *numPageControlIndicator;
@property (nonatomic, weak) UICollectionViewCell *curDisplayCell;
@property (nonatomic, strong) UIView *bottomContainer;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, assign) CGRect openFrame;

// Data
@property (nonatomic, assign) NSInteger itemCnt;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) NSInteger openIndex;

// 滑动到最后的提示View 松开后的action已完成标识
@property (nonatomic, assign) BOOL scrollDragActionFinished;

@end

@implementation GZEImageBrowser

- (instancetype)initWithIndex:(NSInteger)index openFrame:(CGRect)openFrame
{
    if (self = [super init])
    {
        _curIndex = index;
        _openIndex = index;
        _openFrame = openFrame;
        self.alpha = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:ges];
    [self addSubview:self.contentCollectionView];
}

- (void)show
{
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    [self showInView:view containerSize:view.bounds.size];
}

- (void)showInView:(UIView *)view containerSize:(CGSize)containerSize {
    [view addSubview:self];
    self.frame = view.bounds;
    self.contentCollectionView.frame = view.bounds;
    if (CGSizeEqualToSize(self.openFrame.size, CGSizeMake(0, 0))) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.contentCollectionView.hidden = NO;
        }];
        return;
    }
    // 只用来播放动画
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *url = nil;
    if ([self.delegate respondsToSelector:@selector(imageBrowser:imageUrlAtIndex:)])
    {
        url = [self.delegate imageBrowser:self imageUrlAtIndex:self.curIndex];
    }
    if (!url) {
        url = @"default-poster";
    }
    if ([url containsString:@"http"]) {
        UIImage *defaultImage = nil;
        if ([self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex])
        {
            defaultImage = [self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex];
        }
        if (!defaultImage) {
            defaultImage = [UIImage imageNamed:@"default-poster"];
        }
        [animationView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
    } else {
        animationView.image = [UIImage imageNamed:url];
    }
    CGSize endSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * self.openFrame.size.height / self.openFrame.size.width);
    CGRect endFrame = CGRectMake(0, containerSize.height / 2 - endSize.height / 2, endSize.width, endSize.height);
    animationView.frame = self.openFrame;
    [self addSubview:animationView];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:3 options:0 animations:^{
        animationView.frame = endFrame;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.contentCollectionView.hidden = NO;
        [animationView removeFromSuperview];
    }];
}

- (void)close
{
    if (CGSizeEqualToSize(self.openFrame.size, CGSizeMake(0, 0)) || self.curIndex != self.openIndex) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }
    // 只用来播放动画
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *url = nil;
    if ([self.delegate respondsToSelector:@selector(imageBrowser:imageUrlAtIndex:)])
    {
        url = [self.delegate imageBrowser:self imageUrlAtIndex:self.curIndex];
    }
    if (!url) {
        url = @"default-poster";
    }
    if ([url containsString:@"http"]) {
        UIImage *defaultImage = nil;
        if ([self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex])
        {
            defaultImage = [self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex];
        }
        if (!defaultImage) {
            defaultImage = [UIImage imageNamed:@"default-poster"];
        }
        [animationView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
    } else {
        animationView.image = [UIImage imageNamed:url];
    }
    CGSize startSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * self.openFrame.size.height / self.openFrame.size.width);
    CGRect startFrame = CGRectMake(0, self.frame.size.height / 2 - startSize.height / 2, startSize.width, startSize.height);
    animationView.frame = startFrame;
    [self addSubview:animationView];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:3 options:0 animations:^{
        animationView.frame = self.openFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *lineLayout = [[UICollectionViewFlowLayout alloc] init];
        lineLayout.minimumLineSpacing = 0;
        lineLayout.minimumInteritemSpacing = 0;
        [lineLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_contentCollectionView registerClass:[GZEImageBrowserCell class] forCellWithReuseIdentifier:@"GZEImageBrowserCell"];
        
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lineLayout];
        _contentCollectionView.alwaysBounceHorizontal = YES;
        _contentCollectionView.decelerationRate = 1;
        _contentCollectionView.directionalLockEnabled = YES;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.backgroundColor = [UIColor blackColor];
        _contentCollectionView.bounces = YES;
        _contentCollectionView.contentOffset = CGPointMake(self.curIndex * (SCREEN_WIDTH + kGapWidth), 0);
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        [_contentCollectionView registerClass:[GZEImageBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEImageBrowserCell class])];
        _contentCollectionView.hidden = YES;
    }
    return _contentCollectionView;
}

#pragma mark -- dataSource
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEImageBrowserCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEImageBrowserCell class]) forIndexPath:indexPath];
    NSString *url = nil;
    if ([self.delegate respondsToSelector:@selector(imageBrowser:imageUrlAtIndex:)])
    {
        url = [self.delegate imageBrowser:self imageUrlAtIndex:self.curIndex];
    }
    if (!url) {
        url = @"default-poster";
    }
    if ([url containsString:@"http"]) {
        UIImage *defaultImage = nil;
        if ([self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex])
        {
            defaultImage = [self.delegate imageBrowser:self defaultImageAtIndex:self.curIndex];
        }
        if (!defaultImage) {
            defaultImage = [UIImage imageNamed:@"default-poster"];
        }
        [photoCell.imageScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
    } else {
        photoCell.imageScrollView.imageView.image = [UIImage imageNamed:url];
    }

    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self close];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.itemCnt = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getImageBrowserCount:)])
    {
        self.itemCnt = [self.delegate getImageBrowserCount:self];
    }
    return self.itemCnt;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.curDisplayCell = cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.curIndex = collectionView.contentOffset.x / (SCREEN_WIDTH + kGapWidth);
}

- (void)setSelectedIndex:(NSInteger)index
{
    NSAssert(index < self.itemCnt, @"index is too large. total: %ld, index: %ld", self.itemCnt, index);
    self.curIndex = index;
    [self.contentCollectionView setContentOffset:CGPointMake((SCREEN_WIDTH + kGapWidth) * self.curIndex, 0) animated:NO];
}

- (void)reload
{
    [self.contentCollectionView reloadData];
    NSInteger itemCnt = [self collectionView:self.contentCollectionView numberOfItemsInSection:0];
    if (itemCnt > 0 && self.curIndex >= itemCnt) {
        self.curIndex = itemCnt - 1;
    }
}

@end
