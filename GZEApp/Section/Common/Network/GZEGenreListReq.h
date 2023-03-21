//
//  GZEGenreListReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseReq.h"
#import "GZEEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEGenreListReq : GZEBaseReq

@property (nonatomic, strong) NSString *language;
@property (nonatomic, assign) GZEMediaType type;

@end

NS_ASSUME_NONNULL_END
