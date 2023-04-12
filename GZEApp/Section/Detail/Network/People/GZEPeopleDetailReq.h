//
//  GZEPeopleDetailReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseReq.h"

typedef NS_ENUM(NSUInteger, GZEPeopleDetailType) {
    GZEPeopleDetailType_Default,
    GZEPeopleDetailType_All,    // 利用append_to_response字段把所有信息全部请求了
    GZEPeopleDetailType_Common,
    GZEPeopleDetailType_Credits,
    GZEPeopleDetailType_Images,
    GZEPeopleDetailType_TagImage,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleDetailReq : GZEBaseReq

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *append_to_response;

@property (nonatomic, assign) NSInteger peopleId;
@property (nonatomic, assign) GZEPeopleDetailType type;
// tag image
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
