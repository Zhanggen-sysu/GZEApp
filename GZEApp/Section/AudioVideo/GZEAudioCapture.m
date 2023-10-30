//
//  GZEAudioCapture.m
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import "GZEAudioCapture.h"
#import <AVFoundation/AVFoundation.h>
#import <mach/mach_time.h>
#import "GZEAudioConfig.h"
#import "Macro.h"

@interface GZEAudioCapture ()

// 音频采集实例
@property (nonatomic, assign) AudioComponentInstance audioCaptureInstance;
// 音视频采集参数
@property (nonatomic, assign) AudioStreamBasicDescription audioFormat;
// 采集队列，串行队列
@property (nonatomic, strong) dispatch_queue_t captureQueue;
// 采集出错
@property (nonatomic, assign) BOOL isError;
// 配置信息
@property (nonatomic, strong, readwrite) GZEAudioConfig *config;

@end

@implementation GZEAudioCapture

- (instancetype)initWithConfig:(GZEAudioConfig *)config
{
    if (self = [super init]) {
        _config = config;
        _captureQueue = dispatch_queue_create("com.GZEApp.audioCapture", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc
{
    if (_audioCaptureInstance) {
        AudioOutputUnitStop(_audioCaptureInstance);
        AudioComponentInstanceDispose(_audioCaptureInstance);
        _audioCaptureInstance = nil;
    }
}

// 开始采集音频数据
- (void)startRunning
{
    if (self.isError) {
        return;
    }
    
    WeakSelf(self)
    dispatch_async(_captureQueue, ^{
        StrongSelfReturnNil(self)
        if (!self.audioCaptureInstance) {
            NSError *error = nil;
            [self setupAudioCaptureInstance:&error];
            if (error) {
                [self callBackError:error];
                return;
            }
        }
        
        // 开始采集
        OSStatus startStatus = AudioOutputUnitStart(self.audioCaptureInstance);
        if (startStatus != noErr) {
            [self callBackError:[NSError errorWithDomain:NSStringFromClass([GZEAudioCapture class]) code:startStatus userInfo:nil]];
        }
    });
}

- (void)stopRunning
{
    if (self.isError) {
        return;
    }
    
    WeakSelf(self)
    dispatch_async(_captureQueue, ^{
        StrongSelfReturnNil(self)
        if (self.audioCaptureInstance) {
            OSStatus stopStatus = AudioOutputUnitStop(self.audioCaptureInstance);
            if (stopStatus != noErr) {
                [self callBackError:[NSError errorWithDomain:NSStringFromClass([GZEAudioCapture class]) code:stopStatus userInfo:nil]];
            }
        }
    });
}

- (void)setupAudioCaptureInstance:(NSError **)error
{
    // 1. 设置音频组件描述
    AudioComponentDescription acd = {
        .componentType = kAudioUnitType_Output,
        // 回声消除模式
//        .componentSubType = kAudioUnitSubType_VoiceProcessingIO,
        .componentSubType = kAudioUnitSubType_RemoteIO,
        .componentManufacturer = kAudioUnitManufacturer_Apple,
        .componentFlags = 0,
        .componentFlagsMask = 0,
    };
    
    // 2. 查找复合指定描述的音频组件
    AudioComponent component = AudioComponentFindNext(NULL, &acd);
    
    // 3. 创建音频组件实例
    OSStatus status = AudioComponentInstanceNew(component, &_audioCaptureInstance);
    if (status != noErr) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:status userInfo:nil];
        return;
    }
    
    // 4. 设置实例的属性：可读写。0 不可读写，1 可读写
    UInt32 flagOne = 1;
    AudioUnitSetProperty(_audioCaptureInstance, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &flagOne, sizeof(flagOne));
    
    // 5. 设置实例的属性：音频参数，如：数据格式、声道数、采样位深、采样率等
    AudioStreamBasicDescription asbd = {0};
    // 原始数据为PCM，采用声道交错格式
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    // 每帧声道数
    asbd.mChannelsPerFrame = (UInt32)self.config.channels;
    // 每个数据包帧数
    asbd.mFramesPerPacket = 1;
    // 采样位深
    asbd.mBitsPerChannel = (UInt32)self.config.bitDepth;
    // 每帧字节数（byte = bit / 8）
    asbd.mBytesPerFrame = asbd.mChannelsPerFrame * asbd.mBitsPerChannel / 8;
    // 每个包的字节数
    asbd.mBytesPerPacket = asbd.mFramesPerPacket * asbd.mBytesPerFrame;
    // 采样率
    asbd.mSampleRate = self.config.sampleRate;
    self.audioFormat = asbd;
    status = AudioUnitSetProperty(_audioCaptureInstance, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &asbd, sizeof(asbd));
    if (status != noErr) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:status userInfo:nil];
        return;
    }
    
    // 6. 设置实例的属性，数据回调函数
    AURenderCallbackStruct cb;
    cb.inputProcRefCon = (__bridge void *)self;
    cb.inputProc = audioBufferCallBack;
    status = AudioUnitSetProperty(_audioCaptureInstance, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, 1, &cb, sizeof(cb));
    if (status != noErr) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:status userInfo:nil];
        return;
    }
    
    // 7. 初始化实例
    status = AudioUnitInitialize(_audioCaptureInstance);
    if (status != noErr) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:status userInfo:nil];
        return;
    }
}

- (void)callBackError:(NSError *)error
{
    self.isError = YES;
    if (error && self.errorCallBack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorCallBack(error);
        });
    }
}

+ (CMSampleBufferRef)sampleBufferFromAudioBufferList:(AudioBufferList)buffers
                                         inTimeStamp:(const AudioTimeStamp *)inTimeStamp
                                      inNumberFrames:(UInt32)inNumberFrames
                                         description:(AudioStreamBasicDescription)description
{
    // 待生成的CMSampleBuffer实例的引用
    CMSampleBufferRef sampleBuffer = NULL;
    
    // 1. 创建音频流的格式描述信息
    CMFormatDescriptionRef format = NULL;
    OSStatus status = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &description, 0, NULL, 0, NULL, NULL, &format);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    // 2. 处理音频帧的时间戳信息
    mach_timebase_info_data_t info = {0, 0};
    mach_timebase_info(&info);
    uint64_t time = inTimeStamp->mHostTime;
    // 转换为纳秒
    time *= info.numer;
    time /= info.denom;
    // PTS
    CMTime presentationTime = CMTimeMake(time, 1000000000.0f);
    // 对于音频，PTS和DTS是一样的
    CMSampleTimingInfo timing = {CMTimeMake(1, description.mSampleRate), presentationTime, presentationTime};
    
    // 3. 创建CMSampleBuffer实例
    status = CMSampleBufferCreate(kCFAllocatorDefault, NULL, false, NULL, NULL, format, (CMItemCount)inNumberFrames, 1, &timing, 0, NULL, &sampleBuffer);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    // 4. 创建CMBlockBuffer实例，其中数据拷贝自AudioBufferList，并将CMBlockBuffer实例关联到CMSampleBuffer实例
    status = CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer, kCFAllocatorDefault, kCFAllocatorDefault, 0, &buffers);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    CFRelease(format);
    return sampleBuffer;
}


static OSStatus audioBufferCallBack(void *inRefCon,
                                    AudioUnitRenderActionFlags *ioActionFlags,
                                    const AudioTimeStamp *inTimeStamp,
                                    UInt32 inBusNumber,
                                    UInt32 inNumberFrames,
                                    AudioBufferList *ioData)
{
    @autoreleasepool {
        GZEAudioCapture *capture = (__bridge GZEAudioCapture *)inRefCon;
        if (!capture) {
            return -1;
        }
        
        // 1. 创建AudioBufferList空间，用来创建采集回来的数据
        AudioBuffer buffer;
        buffer.mData = NULL;
        buffer.mDataByteSize = 0;
        // 采集的时候设置了数据格式是kAudioFormatLinearPCM，即声道交错格式，所以即使是双声道这里也设置mNumberChannels为1
        // 对于双声道的数据，会按照采样位深16bit每组，一组接一组进行两个声道数据的交错拼接
        buffer.mNumberChannels = 1;
        AudioBufferList buffers;
        buffers.mNumberBuffers = 1;
        buffers.mBuffers[0] = buffer;
        
        // 2. 获取音频PCM数据，存储到AudioBufferList中
        // （1）每帧的字节数为4（2声道，16位深），inNumberFrames是返回数据的帧数，一次回调回来的数据字节数为4 * inNumberFrames
        // （2）这个数据回调的频率与音频采样率（mSampleRate 44100）是没关系的，声道数、采样位深和采样率共同决定设备单位时间里的采样数据的大小，这些数据会缓冲起来，然后一块一块通过这个回调给我们
        // （3）这个数据回调的间隔是[AVAudioSession sharedInstance].preferredIOBufferDuration，频率是其倒数，可以通过[[AVAudioSession sharedInstance] setPreferredIOBufferDuration:1 error:nil]设置回调间隔（频率）
        OSStatus status = AudioUnitRender(capture.audioCaptureInstance,
                                          ioActionFlags,
                                          inTimeStamp,
                                          inBusNumber,
                                          inNumberFrames,
                                          &buffers);
        
        // 3. 数据封装及回调
        if (status == noErr) {
            // 使用工具方法将数据封装为CMSampleBuffer
            CMSampleBufferRef sampleBuffer = [GZEAudioCapture sampleBufferFromAudioBufferList:buffers inTimeStamp:inTimeStamp inNumberFrames:inNumberFrames description:capture.audioFormat];
            // 回调数据
            if (capture.sampleBufferOutputCallBack) {
                capture.sampleBufferOutputCallBack(sampleBuffer);
            }
            if (sampleBuffer) {
                CFRelease(sampleBuffer);
            }
        }
        return status;
    }
}

@end
