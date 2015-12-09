//
//  PlayStateController.h
//  upnpxdemo
//
//  Created by yhcha on 2015. 12. 10..
//  Copyright © 2015년 Bruno Keymolen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    ePLAY_STATUS_STOP,
    ePLAY_STATUS_PLAY,
    ePLAY_STATUS_PAUSE,
    
    ePLAY_STATUS_MAX
    
} ePLAY_STATUS_IDX;

typedef enum
{
    eREPEAT_STATUS_NONE,
    eREPEAT_STATUS_ONE,
    eREPEAT_STATUS_ALL,
    
    eREPEAT_STATUS_MAX
    
} eREPEAT_STATUS_IDX;

typedef enum
{
    eSHUFFLE_STATUS_OFF,
    eSHUFFLE_STATUS_ON,
    
    eSHUFFLE_STATUS_MAX
    
} eSHUFFLE_STATUS_IDX;

@interface PlayStateController : NSObject
{
    ePLAY_STATUS_IDX ePlay;
    eREPEAT_STATUS_IDX eRepeat;
    eSHUFFLE_STATUS_IDX eShuffle;
}

@property ePLAY_STATUS_IDX ePlay;
@property eREPEAT_STATUS_IDX eRepeat;
@property eSHUFFLE_STATUS_IDX eShuffle;



@end










