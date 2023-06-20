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
#import "GZECommonHelper.h"
#import "GZELanguageListReq.h"
#import "GZELanguageItem.h"
#import "GZELanguageListRsp.h"
#import "Macro.h"

@interface GZEGlobalConfig ()

@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *genresDict;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *tvGenresDict;
// 把GZELanguageItem的iso639_1作为key，方便使用
@property (nonatomic, copy) NSDictionary<NSString *, GZELanguageItem *> *allLanguage;
@property (nonatomic, strong) NSDateComponents *dateComponents;

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
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEGenreListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
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

- (void)getAllLanguagesWithCompletion:(void (^)(NSDictionary<NSString *,GZELanguageItem *> * _Nonnull))completion
{
    if (!self.allLanguage) {
        GZELanguageListReq *req = [[GZELanguageListReq alloc] init];
        [req startRequestWithRspClass:[GZELanguageListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            if (isSuccess) {
                GZELanguageListRsp *model = (GZELanguageListRsp *)rsp;
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [model.results enumerateObjectsUsingBlock:^(GZELanguageItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dict setObject:obj forKey:obj.iso639_1];
                }];
                self.allLanguage = dict;
                !completion ?: completion(dict);
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
        }];
    } else {
        !completion ?: completion(self.allLanguage);
    }
}

- (NSArray<NSString *> *)supportLanguages
{
    return @[@"en", @"zh", @"cn", @"ja", @"ko", @"th", @"de", @"fr", @"ru", @"it", @"es", @"sv"];
}

- (NSDateComponents *)dateComponents
{
    if (!_dateComponents) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        _dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    }
    return _dateComponents;
}

- (NSInteger)currentYear
{
    return [self.dateComponents year];
}

- (NSInteger)currentMonth
{
    return [self.dateComponents month];
}

- (NSInteger)currentDay
{
    return [self.dateComponents day];
}

- (NSInteger)currentHour
{
    return [self.dateComponents hour];
}

- (NSInteger)currentMinute
{
    return [self.dateComponents minute];
}

- (NSInteger)currentSecond
{
    return [self.dateComponents second];
}

@end
