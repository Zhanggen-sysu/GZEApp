//
//  GZEDetailManager.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import <Foundation/Foundation.h>
#import "GZEMovieDetailReq.h"
#import "GZETVDetailReq.h"
#import "GZEPeopleDetailReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailManager : NSObject

- (void)getMovieDetailWithId:(NSInteger)movieId completion:(GZECommonRspBlock)completion;
- (void)getTVDetailWithId:(NSInteger)tvId completion:(GZECommonRspBlock)completion;
- (void)getPeopleDetailWithId:(NSInteger)peopleId completion:(GZECommonRspBlock)completion;

@end

NS_ASSUME_NONNULL_END
