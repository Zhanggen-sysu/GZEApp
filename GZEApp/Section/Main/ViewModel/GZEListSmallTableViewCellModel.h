//
//  GZEListSmallTableViewCellModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZEMovieListItem;
@class GZETVListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListSmallTableViewCellModel : GZEBaseModel

@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *score;
@property (nonatomic, copy) NSString *scoreNum;
+ (GZEListSmallTableViewCellModel *)viewModelWithMovie:(GZEMovieListItem *)movie;
+ (GZEListSmallTableViewCellModel *)viewModelWithTV:(GZETVListItem *)tv;

@end

NS_ASSUME_NONNULL_END
