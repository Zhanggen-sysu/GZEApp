//
//  GZEGlobalConfig.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEGlobalConfig.h"
#import "GZECommonHelper.h"
#import "GZEGenreItem.h"
#import "GZEGenreListReq.h"
#import "GZEGenreListRsp.h"

@interface GZEGlobalConfig ()

@property (nonatomic, copy) NSArray<GZEGenreItem *> *genres;

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
    return @"en-US";
}

// 获取类型列表
- (void)getGenresWithCompletion:(void (^)(NSArray<GZEGenreItem *> *))completion
{
    if (!self.genres) {
        GZEGenreListReq *req = [[GZEGenreListReq alloc] init];
        [req startRequestWithRspClass:[GZEGenreListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            if (isSuccess) {
                self.genres = ((GZEGenreListRsp *)rsp).genres;
                !completion ?: completion(self.genres);
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
        }];
    } else {
        !completion ?: completion(self.genres);
    }
}

@end
