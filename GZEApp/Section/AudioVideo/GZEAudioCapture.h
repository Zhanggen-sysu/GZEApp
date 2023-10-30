//
//  GZEAudioCapture.h
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@class GZEAudioConfig;

NS_ASSUME_NONNULL_BEGIN

@interface GZEAudioCapture : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(GZEAudioConfig *)config;

@property (nonatomic, strong, readonly) GZEAudioConfig *config;
// 音频采集数据回调
@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample);
// 音频采集错误回调
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

// 开始采集音频数据
- (void)startRunning;
// 停止采集音频数据
- (void)stopRunning;

@end

NS_ASSUME_NONNULL_END
