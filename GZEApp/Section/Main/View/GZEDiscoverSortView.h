//
//  GZEDiscoverSortView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEBaseView.h"
#import "GZEEnum.h"
@class GZEGenreItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverSortView : GZEBaseView

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, copy) void (^selectItemBlock)(NSInteger);

- (void)show;
- (void)dismiss;
- (void)updateWithModel:(NSArray<GZEGenreItem *> *)model mediaType:(GZEMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
