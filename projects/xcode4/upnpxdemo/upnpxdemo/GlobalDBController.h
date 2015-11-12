//
//  GlobalDBController.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1BasicObject.h"
#import "MediaRenderer1Device.h"

@interface GlobalDBController : UIViewController
{
    
}

+(GlobalDBController*)getInstance;

@property(nonatomic) NSInteger selectIndex;
//@property(nonatomic, retain) MediaServer1BasicObject *mDevices;
@property(nonatomic, retain) NSString *albumArtUrl;

@property(nonatomic, retain) NSString *label_albume;
@property(nonatomic, retain) NSString *label_artist;
@property(nonatomic, retain) NSString *label_song;
@property(nonatomic, retain) MediaRenderer1Device *mediaRenderer;

-(void) updateValues;

-(void) setValue:(BOOL)value forOption:(NSString*)name;
-(void) setValue1:(NSInteger)value forOption:(NSString*)name;
-(void) setMediaRendererDevice:(MediaRenderer1Device*)value forOption:(NSString*)name;
-(void) setString:(NSString *)value forOption:(NSString*)name;
@end
