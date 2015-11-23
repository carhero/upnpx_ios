//
//  NowPlayController.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalDBController.h"
#import "PlayBack.h"

@interface NowPlayController : UIViewController
{
    NSArray *mDevices;
    UILabel *label;
    BOOL updateTimer;
    NSInteger elapsedTimeCnt;
    NSInteger currPlayPosition;
    
    PlayBack *playCtrl;
    BOOL bPlayPause;
}

@property (strong, nonatomic)PlayBack *playCtrl;

@property (strong, nonatomic) IBOutlet UIImageView *imageAlbumArt;
@property GlobalDBController * globalConfig;

@property (weak, nonatomic) IBOutlet UILabel *label_albume;
@property (weak, nonatomic) IBOutlet UILabel *label_artist;
@property (weak, nonatomic) IBOutlet UILabel *label_song;
@property (strong, nonatomic) IBOutlet UISlider *volume_slider;

@property (strong, nonatomic) IBOutlet UISlider *elapsedSlider;
@property (strong, nonatomic) IBOutlet UILabel *elsedTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;


@end
