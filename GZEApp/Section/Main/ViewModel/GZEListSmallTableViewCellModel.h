//
//  GZEListSmallTableViewCellModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
#import "GZEEnum.h"
@class GZEMovieListItem;
@class GZETVListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListSmallTableViewCellModel : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *score;
@property (nonatomic, copy) NSString *scoreNum;
@property (nonatomic, assign) GZEMediaType mediaType;
+ (GZEListSmallTableViewCellModel *)viewModelWithMovie:(GZEMovieListItem *)movie;
+ (GZEListSmallTableViewCellModel *)viewModelWithTV:(GZETVListItem *)tv;

@end

NS_ASSUME_NONNULL_END
