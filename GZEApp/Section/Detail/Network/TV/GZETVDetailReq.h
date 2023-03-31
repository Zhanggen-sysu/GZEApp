//
//  GZETVDetailReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseReq.h"

typedef NS_ENUM(NSUInteger, GZETVDetailType) {
    GZETVDetailType_Default,
    GZETVDetailType_All,    // 利用append_to_response字段把所有信息全部请求了
    GZETVDetailType_Common,
    GZETVDetailType_CrewCast,
    GZETVDetailType_Rating,
    GZETVDetailType_Image,
    GZETVDetailType_Keyword,
    GZETVDetailType_Recommend,
    GZETVDetailType_Review,
    GZETVDetailType_Similar,
    GZETVDetailType_Videos,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailReq : GZEBaseReq

@property (nonatomic, assign) NSInteger tvId;
// all, image, keyword不能有
@property (nonatomic, copy) NSString *language;
// common
@property (nonatomic, copy) NSString *append_to_response;
// recommend, review, similar
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, assign) GZETVDetailType type;

@end

NS_ASSUME_NONNULL_END
