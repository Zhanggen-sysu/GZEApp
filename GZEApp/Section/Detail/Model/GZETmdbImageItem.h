//
//  GZETmdbImageItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZETrendingItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbImageItem : GZEBaseModel

@property (nonatomic, assign)         double aspectRatio;
@property (nonatomic, copy)           NSString *filePath;
@property (nonatomic, assign)         NSInteger height;
@property (nonatomic, nullable, copy) id iso639_1;
@property (nonatomic, assign)         double voteAverage;
@property (nonatomic, assign)         NSInteger voteCount;
@property (nonatomic, assign)         NSInteger width;
// people
@property (nonatomic, copy)           NSString *imageType;
@property (nonatomic, strong)         GZETrendingItem *media;
@property (nonatomic, copy)           NSString *mediaType;

@end

NS_ASSUME_NONNULL_END
