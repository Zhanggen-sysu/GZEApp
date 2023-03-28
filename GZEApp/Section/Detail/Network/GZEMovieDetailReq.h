//
//  GZEMovieDetailReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GZEMovieDetailType) {
    GZEMovieDetailType_Default,
    GZEMovieDetailType_Common,
    GZEMovieDetailType_CrewCast,
    GZEMovieDetailType_Video,
    GZEMovieDetailType_Image,
    GZEMovieDetailType_Review,
    GZEMovieDetailType_Similar,
};

@interface GZEMovieDetailReq : GZEBaseReq

@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, assign) GZEMovieDetailType type;
// image不能有
@property (nonatomic, copy, nullable) NSString *language;
@property (nonatomic, copy) NSString *append_to_response;
// image
@property (nonatomic, copy) NSString *include_image_language;
// review, similar
@property (nonatomic, strong) NSNumber *page;

@end

NS_ASSUME_NONNULL_END
