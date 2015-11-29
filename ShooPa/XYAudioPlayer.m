//
//  XYAudioPlayer.m
//  XiaoYingSDK
//
//  Created by xuxinyuan on 9/15/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface XYAudioPlayer ()
{
    AVPlayer *audioPlayer;
    id audioPlayerObserver;
}
@end

@implementation XYAudioPlayer

+(XYAudioPlayer *)sharedInstance
{
    static XYAudioPlayer * sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[XYAudioPlayer alloc] init];
        [sharedInstance initPlayer];
    });
    return sharedInstance;
}

#pragma mark - Music player methods

-(void) initPlayer {
    audioPlayer = [[AVPlayer alloc] init];
}

-(void) initPlayer:(NSURL *)url {
    audioPlayer = [[AVPlayer alloc] init];
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:url];
    [audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
}

- (void)uninitPlayer
{
    if(audioPlayerObserver){
        [audioPlayer removeTimeObserver:audioPlayerObserver];
        audioPlayerObserver = nil;
    }
    [audioPlayer pause];
    audioPlayer = nil;
}

- (void)play:(NSURL *)url playToTheEndBlock:(void (^)(void))playToTheEndBlock
{
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:url];
    [audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    [audioPlayer play];
    [self addObserver:currentItem playToTheEndBlock:playToTheEndBlock];
}

- (void)pause
{
    [audioPlayer pause];
}

- (void)resume
{
    [audioPlayer play];
}

- (void)resume:(NSURL *)url progress:(CGFloat)progress
{
    AVPlayerItem * currentItem = [audioPlayer currentItem];
    if(!currentItem){
        currentItem = [AVPlayerItem playerItemWithURL:url];
        [audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    }
    
    if(currentItem.duration.timescale != 0){
        [self seek:progress];
    }else{
        [audioPlayer play];
    }
}

- (void)seek:(CGFloat)progress
{
    AVPlayerItem * currentItem = [audioPlayer currentItem];
    CMTime time = CMTimeMakeWithSeconds(progress/1000.0, currentItem.duration.timescale);
    [audioPlayer seekToTime:time completionHandler:^(BOOL finished) {
        [self resume];
    }];
}

- (void)seekWithOutAutoPlay:(CGFloat)progress
{
    AVPlayerItem * currentItem = [audioPlayer currentItem];
    CMTime time = CMTimeMakeWithSeconds(progress/1000.0, currentItem.duration.timescale);
    [audioPlayer seekToTime:time completionHandler:^(BOOL finished) {

    }];
}

- (BOOL)isPlaying
{
    if(audioPlayer && audioPlayer.rate != 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)addObserver:(AVPlayerItem *)currentItem playToTheEndBlock:(void (^)(void))playToTheEndBlock
{
    if(audioPlayerObserver){
        [audioPlayer removeTimeObserver:audioPlayerObserver];
        audioPlayerObserver = nil;
    }
    Float64 durationSeconds = CMTimeGetSeconds([[currentItem asset] duration]);
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds, 1);
    NSArray *times = @[[NSValue valueWithCMTime:firstThird]];
    __block XYAudioPlayer * weakSelf = self;
    audioPlayerObserver = [audioPlayer addBoundaryTimeObserverForTimes:times queue:NULL usingBlock:^{
        // code
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf pause];
            if(playToTheEndBlock) {
                playToTheEndBlock();
            }
        });
    }];
}

@end
