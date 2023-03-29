//
//  GZESearchCellViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZEBaseModel.h"
#import "GZEEnum.h"
@class GZETrendingItem;
@class GZESearchListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZESearchCellViewModel : GZEBaseModel

@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSAttributedString *stars;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, assign) GZEMediaType mediaType;
@property (nonatomic, copy) NSString *typeText;
@property (nonatomic, assign) NSInteger ID;

+ (GZESearchCellViewModel *)viewModelWithTrendModel:(GZETrendingItem *)model;
+ (GZESearchCellViewModel *)viewModelWithSearchModel:(GZESearchListItem *)model;

@end

NS_ASSUME_NONNULL_END
