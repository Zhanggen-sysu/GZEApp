//
//  GZEMovieDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class GZEMovieDetailRsp;

@interface GZEMovieDetailViewModel : GZEBaseDetailViewModel

@property (nonatomic, strong, readonly) GZEMovieDetailRsp *commonInfo;

@property (nonatomic, strong, readonly) RACCommand *reqCommand;

@property (nonatomic, strong, readonly) RACCommand *movieCommand;

- (instancetype)initWithMovieId:(NSInteger)movieId;

@end

NS_ASSUME_NONNULL_END
