//
//  GZEFilterViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"

typedef NS_OPTIONS(NSUInteger, GZEFilterType) {
    GZEFilterType_Default,
    GZEFilterType_MediaType,
    GZEFilterType_Language,
    GZEFilterType_Genre,
    GZEFilterType_Sort,
    GZEFilterType_Decade,
    GZEFilterType_Year,
    GZEFilterType_VoteCount,
    GZEFilterType_VoteAverage,
    GZEFilterType_Runtime,
    GZEFilterType_Region,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZEFilterModel : GZEBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) GZEFilterType filterType;
@property (nonatomic, copy) NSArray *array;

@end

@interface GZEFilterViewModel : GZEBaseModel

@property (nonatomic, assign) GZEFilterType filterTypes;
@property (nonatomic, copy) NSArray<GZEFilterModel *> *filterArray;

+ (void)createFilterModelWithType:(GZEFilterType)filterTypes completeBlock:(void (^)(GZEFilterViewModel *))completeBlock;

@end

NS_ASSUME_NONNULL_END
