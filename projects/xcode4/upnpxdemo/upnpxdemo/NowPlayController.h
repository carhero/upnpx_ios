//
//  NowPlayController.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalDBController.h"

@interface NowPlayController : UIViewController
{
    NSArray *mDevices;
    UILabel *label;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageAlbumArt;
@property GlobalDBController * globalConfig;

@property (weak, nonatomic) IBOutlet UILabel *label_albume;
@property (weak, nonatomic) IBOutlet UILabel *label_artist;
@property (weak, nonatomic) IBOutlet UILabel *label_song;



@end
