//
//  ExperimentAudioOutput.m
//  phyphox
//
//  Created by Jonas Gessner on 16.03.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

#import "ExperimentAudioOutput.h"
#import "phyphox-swift.h"

@interface ExperimentAudioOutput () {
//    EZOutput *_output;
    NSUInteger _lastIndex;
    BOOL _stopPlayback;
    
    BOOL _playing;
}

@end

@implementation ExperimentAudioOutput

- (instancetype)initWithSampleRate:(NSUInteger)sampleRate loop:(BOOL)loop dataSource:(DataBuffer *)dataBuffer {
    self = [super init];
    
    if (self) {
//        AudioStreamBasicDescription inputFormat = [EZAudioUtilities monoFloatFormatWithSampleRate:sampleRate];
//        _output = [EZOutput outputWithDataSource:self inputFormat:inputFormat];
        
        _dataSource = dataBuffer;
        _sampleRate = sampleRate;
        _loop = loop;
    }
    
    return self;
}

//Setting pointers in swift is virtually impossible (especially with arrays), therefore this entire class is written in Objc
//- (OSStatus)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames timestamp:(const AudioTimeStamp *)timestamp {
    if (_stopPlayback) {
        _stopPlayback = NO;
        [self pause];
        return -1;
    }
    
    if (_dataSource.count == 0) {
        return noErr;
    }
    
    Float32 *buffer = (Float32 *)audioBufferList->mBuffers[0].mData;
    
    NSArray <NSNumber *> *array = _dataSource.toArray;
    
    for (UInt32 frame = 0; frame < frames; frame++) {
        if (!_loop) {
            if (frame < array.count) {
                buffer[frame] = array[frame].floatValue;
            }
            else {
                buffer[frame] = 0.0f;
                _stopPlayback = YES;
            }
        }
        else {
            NSUInteger index = (_lastIndex+frame) % array.count;
            
            buffer[frame] = array[index].floatValue;
        }
    }
    
    _lastIndex = (_lastIndex+frames-1) % array.count;
    
    return noErr;
//}

- (void)play {
    if (!_playing) {
        _playing = YES;
        _stopPlayback = NO;
//        [_output startPlayback];
    }
}

- (void)pause {
    if (_playing) {
        _lastIndex = 0;
//        [_output stopPlayback];
        _playing = NO;
    }
}

@end
