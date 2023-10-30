//
//  GZEAudioCaptureVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/8/3.
//

#import "GZEAudioCaptureVC.h"
#import "GZEAudioCapture.h"
#import "GZEAudioConfig.h"
#import "Macro.h"
#import <AVFoundation/AVFoundation.h>

@interface GZEAudioCaptureVC ()

@property (nonatomic, strong) GZEAudioConfig *audioConfig;
@property (nonatomic, strong) GZEAudioCapture *audioCapture;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation GZEAudioCaptureVC

- (GZEAudioConfig *)audioConfig
{
    if (!_audioConfig) {
        _audioConfig = [GZEAudioConfig defaultConfig];
    }
    return _audioConfig;
}

- (GZEAudioCapture *)audioCapture
{
    if (!_audioCapture) {
        _audioCapture = [[GZEAudioCapture alloc] initWithConfig:self.audioConfig];
        _audioCapture.errorCallBack = ^(NSError * _Nonnull error) {
            NSLog(@"GZEAudioCapture error: %zi %@", error.code, error.localizedDescription);
        };
        WeakSelf(self)
        _audioCapture.sampleBufferOutputCallBack = ^(CMSampleBufferRef  _Nonnull sample) {
            StrongSelfReturnNil(self)
            if (sample) {
                // 1. 获取CMBlockBuffer，这里面封装着PCM数据
                CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sample);
                size_t lengthAtOffsetOutput, totalLengthOutput;
                char *dataPointer;
                
                // 2. 从CMBlockBuffer中获取PCM数据存储到文件中
                CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffsetOutput, &totalLengthOutput, &dataPointer);
                [self.fileHandle writeData:[NSData dataWithBytes:dataPointer length:totalLengthOutput]];
            }
        };
    }
    return _audioCapture;
}

- (NSFileHandle *)fileHandle
{
    if (!_fileHandle) {
        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.pcm"];
        NSLog(@"PCM file path: %@", audioPath);
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:audioPath contents:nil attributes:nil];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:audioPath];
    }
    return _fileHandle;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAudioSession];
    [self setupUI];
}

- (void)dealloc
{
    if (_fileHandle) {
        [_fileHandle closeFile];
    }
}

- (void)setupUI
{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"Audio Capture";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    UIBarButtonItem *stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    self.navigationItem.rightBarButtonItems = @[startBarButton, stopBarButton];
}

- (void)setupAudioSession
{
    NSError *error = nil;
    
    // 1. 获取音频会话实例
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 2. 设置分类和选项
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    if (error) {
        NSLog(@"AVAudioSession setCategory error.");
        error = nil;
        return;
    }
    
    // 3. 设置模式
    [session setMode:AVAudioSessionModeVideoRecording error:&error];
    if (error) {
        NSLog(@"AVAudioSession setMode error.");
        error = nil;
        return;
    }
    
    // 4. 激活会话
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive error.");
        error = nil;
        return;
    }
}

- (void)start
{
    [self.audioCapture startRunning];
}

- (void)stop
{
    [self.audioCapture stopRunning];
}

@end
