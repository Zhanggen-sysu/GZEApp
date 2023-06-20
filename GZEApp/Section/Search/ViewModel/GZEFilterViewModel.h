//
//  GZEFilterViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"
#import "GZEEnum.h"

typedef NS_OPTIONS(NSUInteger, GZEFilterType) {
    GZEFilterType_Default,
    GZEFilterType_MediaType,
    GZEFilterType_Language,
    GZEFilterType_Genre,
    GZEFilterType_Decade,
    GZEFilterType_Year,
    GZEFilterType_VoteCount,
    GZEFilterType_VoteAverage,
    GZEFilterType_Runtime,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZEFilterItem : GZEBaseModel

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) GZEFilterType type;

@end

@interface GZEFilterModel : GZEBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) GZEFilterType filterType;
@property (nonatomic, copy) NSArray<GZEFilterItem *> *array;
@property (nonatomic, strong) NSMutableArray *selectIndexs;
@property (nonatomic, assign) BOOL allowMultiSelect;
+ (NSString *)getTextWithModel:(GZEFilterModel *)model;

@end

@interface GZEFilterViewModel : GZEBaseModel

@property (nonatomic, assign) GZEFilterType filterTypes;
@property (nonatomic, copy) NSArray<GZEFilterModel *> *filterArray;

+ (void)createFilterModelWithType:(GZEFilterType)filterTypes completeBlock:(void (^)(GZEFilterViewModel *))completeBlock;
- (void)selectMediaType:(GZEMediaType)mediaType completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
