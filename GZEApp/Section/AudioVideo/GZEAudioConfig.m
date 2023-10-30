//
//  GZEAudioConfig.m
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import "GZEAudioConfig.h"

@implementation GZEAudioConfig

+ (instancetype)defaultConfig
{
    GZEAudioConfig *config = [[self alloc] init];
    config.channels = 2;
    config.sampleRate = 44100;
    config.bitDepth = 16;
    return config;
}

@end
