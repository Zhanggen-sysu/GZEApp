//
//  GZECompanyListReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseReq.h"

typedef NS_ENUM(NSUInteger, GZECompanyListType) {
    GZECompanyListType_Default,
    GZECompanyListType_Movie,
    GZECompanyListType_Tv,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZECompanyListReq : GZEBaseReq

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *watch_region;
@property (nonatomic, assign) GZECompanyListType type;

@end

NS_ASSUME_NONNULL_END
