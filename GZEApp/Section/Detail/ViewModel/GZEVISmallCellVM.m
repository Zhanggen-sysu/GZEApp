//
//  GZEVISmallCellVM.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/15.
//

#import "GZEVISmallCellVM.h"
#import "GZETmdbImageItem.h"
#import "GZEYTVideoRsp.h"
#import "GZECommonHelper.h"
@interface GZEVISmallCellVM ()

@property (nonatomic, strong, readwrite) NSURL *url;
/// YES-(height > width)，NO-(height < width)
@property (nonatomic, assign, readwrite) BOOL isPoster;
// Video
@property (nonatomic, copy, readwrite) NSString *videoType;
@property (nonatomic, assign, readwrite) BOOL isVideo;

@end

@implementation GZEVISmallCellVM

- (instancetype)initWithImageItem:(GZETmdbImageItem *)item
{
    if (self = [super init]) {
        if (item.aspectRatio > 1) {
            self.isPoster = NO;
            self.url = [GZECommonHelper getBackdropUrl:item.filePath size:GZEBackdropSize_w780];
        } else {
            self.isPoster = YES;
            self.url = [GZECommonHelper getPosterUrl:item.filePath size:GZEPosterSize_w342];
        }
        self.isVideo = NO;
    }
    return self;
}

- (instancetype)initWithVideoRsp:(GZEYTVideoRsp *)rsp
{
    if (self = [super init]) {
        self.videoType = rsp.videoType;
        self.url = [NSURL URLWithString:rsp.thumbnailURL];
        self.isPoster = NO;
        self.isVideo = YES;
    }
    return self;
}

@end
