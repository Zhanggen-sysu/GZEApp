//
//  GZEAudioEncoder.h
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZEAudioEncoder : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAudioBitrate:(NSInteger)audioBitrate;

// 音频编码码率
@property (nonatomic, assign, readonly) NSInteger audioBitrate;
// 音频编码数据回调
@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample);
// 音频编码错误回调
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

// 编码
- (void)encodeSampleBuffer:(CMSampleBufferRef)buffer;

@end

NS_ASSUME_NONNULL_END
