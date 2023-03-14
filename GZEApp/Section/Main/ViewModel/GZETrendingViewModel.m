//
//  GZETrendingViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETrendingViewModel.h"
#import "GZETrendingItem.h"
#import "GZETrendingRsp.h"
#import "GZECommonHelper.h"

@implementation GZETrendingViewModel

- (void)setRsp:(GZETrendingRsp *)rsp
{
    _rsp = rsp;
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    [rsp.results enumerateObjectsUsingBlock:^(GZETrendingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.mediaType isEqualToString:@"tv"] || [obj.mediaType isEqualToString:@"movie"]) {
            [urlArray addObject:[GZECommonHelper getPosterUrl:obj.posterPath size:GZEPosterSize_w780]];
            [mediaArray addObject:obj];
        }
    }];
    self.imgUrls = urlArray;
    self.media = mediaArray;
}

@end
