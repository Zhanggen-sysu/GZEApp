//
//  GZETrendingViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZETrendingRsp;
@class GZETrendingItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETrendingViewModel : GZEBaseModel

@property (nonatomic, copy) NSArray<NSURL *> *imgUrls;
@property (nonatomic, strong) GZETrendingRsp *rsp;
@property (nonatomic, copy) NSArray<GZETrendingItem *> *media;
@property (nonatomic, copy) NSArray<GZETrendingItem *> *people;

@end

NS_ASSUME_NONNULL_END
