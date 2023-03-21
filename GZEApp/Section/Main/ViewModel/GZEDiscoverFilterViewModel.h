//
//  GZEDiscoverFilterViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import "GZEBaseModel.h"
#import "GZEEnum.h"
@class GZELanguageItem;
@class GZEGenreItem;
typedef NS_ENUM(NSUInteger, GZEDiscoverFilterType) {
    GZEDiscoverFilterType_Default,
    GZEDiscoverFilterType_Genre,
    GZEDiscoverFilterType_Language,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverFilterItem : GZEBaseModel

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

+ (GZEDiscoverFilterItem *)itemWithKey:(NSString *)key value:(NSString *)value;

@end

@interface GZEDiscoverFilterViewModel : GZEBaseModel

@property (nonatomic, copy) NSArray<GZEDiscoverFilterItem *> *itemArray;
@property (nonatomic, assign) GZEMediaType mediaType;
@property (nonatomic, assign) GZEDiscoverFilterType filterType;
@property (nonatomic, assign) NSInteger selectIndex;

+ (GZEDiscoverFilterViewModel *)viewModelWithLanguageDict:(NSDictionary<NSString *, GZELanguageItem *> *)languageDict mediaType:(GZEMediaType)mediaType;
+ (GZEDiscoverFilterViewModel *)viewModelWithGenreDict:(NSDictionary<NSNumber *, NSString *> *)genreDict mediaType:(GZEMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
