//
//  GZEEnum.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#ifndef GZEEnum_h
#define GZEEnum_h

typedef NS_ENUM(NSUInteger, GZEMediaType) {
    GZEMediaType_Default,
    GZEMediaType_All,
    GZEMediaType_Movie,
    GZEMediaType_TV,
    GZEMediaType_Person,
};

typedef NS_ENUM(NSUInteger, GZEMediaWatchMonetizationType) {
    GZEMediaWatchMonetizationType_Default,
    GZEMediaWatchMonetizationType_Flatrate,
    GZEMediaWatchMonetizationType_Free,
    GZEMediaWatchMonetizationType_Ads,
    GZEMediaWatchMonetizationType_Rent,
    GZEMediaWatchMonetizationType_Buy,
};

#endif /* GZEEnum_h */
