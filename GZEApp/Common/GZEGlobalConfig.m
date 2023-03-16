//
//  GZEGlobalConfig.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEGlobalConfig.h"
#import "GZEGenreItem.h"
#import "GZEGenreListReq.h"
#import "GZEGenreListRsp.h"

@interface GZEGlobalConfig ()

@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *genresDict;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *tvGenresDict;

@end

@implementation GZEGlobalConfig

+ (GZEGlobalConfig *)shareConfig{
    static dispatch_once_t once;
    static GZEGlobalConfig *instance;
    dispatch_once(&once, ^{
        instance = [[GZEGlobalConfig alloc] init];
    });
    return instance;
}

+ (NSString *)language
{
    // 中文是zh-CN，不过有些地方没有中文版
    return @"en-US";
}

// 获取类型列表
- (void)getGenresWithType:(GZEMediaType)mediaType completion:(nullable void (^)(NSDictionary<NSNumber *, NSString *> *))completion
{
    if ((mediaType == GZEMediaType_Movie && !self.genresDict) || (mediaType == GZEMediaType_TV && !self.tvGenresDict)) {
        GZEGenreListReq *req = [[GZEGenreListReq alloc] init];
        req.type = mediaType;
        [req startRequestWithRspClass:[GZEGenreListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            if (isSuccess) {
                GZEGenreListRsp *model = (GZEGenreListRsp *)rsp;
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [model.genres enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dict setObject:obj.name forKey:@(obj.identifier)];
                }];
                if (mediaType == GZEMediaType_TV) {
                    self.tvGenresDict = dict;
                } else if (mediaType == GZEMediaType_Movie) {
                    self.genresDict = dict;
                }
                !completion ?: completion(dict);
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
        }];
    } else {
        if (mediaType == GZEMediaType_TV) {
            !completion ?: completion(self.tvGenresDict);
        } else if (mediaType == GZEMediaType_Movie) {
            !completion ?: completion(self.genresDict);
        }
    }
}

@end
