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

@property (nonatomic, copy, readonly) NSArray *listArray;
@property (nonatomic, strong, readonly) UIColor *magicColor;
@property (nonatomic, strong) RACCommand *movieCommand;
@property (nonatomic, strong) RACCommand *tvCommand;

- (instancetype)initWithMovieListRsp:(GZEMovieListRsp *)model magicColor:(UIColor *)magicColor;
- (instancetype)initWithTvListRsp:(GZETVListRsp *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
