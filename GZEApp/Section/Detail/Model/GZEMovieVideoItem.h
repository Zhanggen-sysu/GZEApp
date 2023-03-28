//
//  GZEMovieVideoItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieVideoItem : GZEBaseModel

@property (nonatomic, copy)   NSString *iso639_1;
@property (nonatomic, copy)   NSString *iso3166_1;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *key;
@property (nonatomic, copy)   NSString *site;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) BOOL isOfficial;
@property (nonatomic, copy)   NSString *publishedAt;
@property (nonatomic, copy)   NSString *identifier;

///  示例
///  {"iso_639_1":"en","iso_3166_1":"US","name":"Victim","key":"1ku7oz4U-jg",
///  "site":"YouTube","size":1080,"type":"Clip","official":true
///  ,"published_at":"2023-03-09T20:00:01.000Z","id":"640ac13f18b75100842825a6"}

@end

NS_ASSUME_NONNULL_END
