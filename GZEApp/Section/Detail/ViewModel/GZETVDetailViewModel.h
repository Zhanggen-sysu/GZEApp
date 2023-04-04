//
//  GZETVDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"
#import <UIKit/UIKit.h>
@class GZETVDetailRsp;
@class GZEYTVideoRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailViewModel : GZEBaseModel

@property (nonatomic, strong) UIColor *magicColor;
@property (nonatomic, strong) GZETVDetailRsp *detail;
@property (nonatomic, strong) GZEYTVideoRsp *firstVideo;

@end

NS_ASSUME_NONNULL_END
