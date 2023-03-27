//
//  GZEDetailManager.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import <Foundation/Foundation.h>
#import "GZEMovieDetailReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailManager : NSObject

- (void)getMovieDetailWithId:(NSInteger)movieId completion:(GZECommonRspBlock)completion;

@end

NS_ASSUME_NONNULL_END
