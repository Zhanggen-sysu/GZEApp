//
//  GZEVISmallCellVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/15.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZETmdbImageItem;
@class GZEYTVideoRsp;

@interface GZEVISmallCellVM : GZEBaseModel

@property (nonatomic, strong, readonly) NSURL *url;
/// YES-(height > width)，NO-(height < width)
@property (nonatomic, assign, readonly) BOOL isPoster;
// Video
@property (nonatomic, copy, readonly) NSString *videoType;
@property (nonatomic, assign, readonly) BOOL isVideo;

- (instancetype)initWithImageItem:(GZETmdbImageItem *)item;
- (instancetype)initWithVideoRsp:(GZEYTVideoRsp *)rsp;

@end

NS_ASSUME_NONNULL_END
