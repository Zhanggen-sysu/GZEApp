//
//  GZEListSmallViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZEMovieListItem;
@class GZETVListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListSmallViewModel : GZEBaseModel

@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *score;
@property (nonatomic, copy) NSString *scoreNum;
+ (GZEListSmallViewModel *)viewModelWithMovie:(GZEMovieListItem *)movie;
+ (GZEListSmallViewModel *)viewModelWithTV:(GZETVListItem *)tv;

@end

NS_ASSUME_NONNULL_END
