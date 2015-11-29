//
//  XYAudioPlayer.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 9/15/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface XYAudioPlayer : NSObject

+(XYAudioPlayer *)sharedInstance;
- (void)initPlayer;
-(void) initPlayer:(NSURL *)url;
- (void)uninitPlayer;
- (void)play:(NSURL *)url playToTheEndBlock:(void (^)(void))playToTheEndBlock;
- (void)pause;
- (void)resume;
- (void)resume:(NSURL *)url progress:(CGFloat)progress;
- (void)seek:(CGFloat)progress;
- (void)seekWithOutAutoPlay:(CGFloat)progress;
- (BOOL)isPlaying;

@end
