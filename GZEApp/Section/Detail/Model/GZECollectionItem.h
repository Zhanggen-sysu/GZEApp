//
//  GZECollectionItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZECollectionItem : GZEBaseModel

@property (nonatomic, copy) NSString *backdrop_path;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *poster_path;

@end

NS_ASSUME_NONNULL_END
