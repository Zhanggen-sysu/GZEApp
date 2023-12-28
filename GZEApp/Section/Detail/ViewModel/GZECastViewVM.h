//
//  GZECastViewVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/28.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GZECrewCastRsp;

@interface GZECastViewVM : GZEBaseModel

@property (nonatomic, copy, readonly) NSArray *castArray;
@property (nonatomic, copy, readonly) NSString *director;

- (instancetype)initWithCrewCastRsp:(GZECrewCastRsp *)rsp
                         magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
