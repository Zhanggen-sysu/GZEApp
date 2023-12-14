//
//  GZEDetailListViewVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/8.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEMovieListRsp;
@class GZETVListRsp;

@interface GZEDetailListViewVM : GZEBaseModel

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *listArray;
@property (nonatomic, strong, readonly) UIColor *magicColor;

- (instancetype)initWithTitle:(NSString *)title
                 movieListRsp:(GZEMovieListRsp *)model
                   magicColor:(UIColor *)magicColor;
- (instancetype)initWithTitle:(NSString *)title
                    tvListRsp:(GZETVListRsp *)model
                   magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END