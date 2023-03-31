//
//  GZETmdbImageItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbImageItem : GZEBaseModel

@property (nonatomic, assign)         double aspectRatio;
@property (nonatomic, copy)           NSString *filePath;
@property (nonatomic, assign)         NSInteger height;
@property (nonatomic, nullable, copy) id iso639_1;
@property (nonatomic, assign)         NSInteger voteAverage;
@property (nonatomic, assign)         NSInteger voteCount;
@property (nonatomic, assign)         NSInteger width;

@end

NS_ASSUME_NONNULL_END
