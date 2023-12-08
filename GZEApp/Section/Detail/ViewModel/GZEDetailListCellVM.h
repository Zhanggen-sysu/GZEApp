//
//  GZEDetailListCellVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/8.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEMovieListItem;
@class GZETVListItem;

@interface GZEDetailListCellVM : GZEBaseModel
// 魔法色计算比较麻烦，就放VM里吧
@property (nonatomic, strong, readonly) UIColor *magicColor;
@property (nonatomic, strong, readonly) UIColor *nameColor;
@property (nonatomic, strong, readonly) NSURL *posterUrl;
@property (nonatomic, assign, readonly) NSAttributedString *ratingString;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) RACCommand *tapCommand;
@property (nonatomic, strong, readonly) RACSubject *jumpTVSubject;
@property (nonatomic, strong, readonly) RACSubject *jumpMovieSubjec;

- (instancetype)initWithMovieListItem:(GZEMovieListItem *)movieItem magicColor:(UIColor *)magicColor;
- (instancetype)initWithTVListItem:(GZETVListItem *)tvItem magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
