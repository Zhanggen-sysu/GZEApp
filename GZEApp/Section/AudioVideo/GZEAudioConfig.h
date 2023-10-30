//
//  GZEAudioConfig.h
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZEAudioConfig : NSObject

+ (instancetype)defaultConfig;

// 声道数，default: 2
@property (nonatomic, assign) NSUInteger channels;
// 采样率，default: 44100
@property (nonatomic, assign) NSUInteger sampleRate;
// 量化位深，default: 16
@property (nonatomic, assign) NSUInteger bitDepth;

@end

NS_ASSUME_NONNULL_END
