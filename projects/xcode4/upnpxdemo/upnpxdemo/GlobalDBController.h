//
//  GlobalDBController.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1BasicObject.h"

@interface GlobalDBController : UIViewController
{
    
}

@property(nonatomic) NSInteger selectIndex;
@property(nonatomic, retain) MediaServer1BasicObject *mDevices;
@property(nonatomic, retain) NSString *albumArtUrl;

+(GlobalDBController*)getInstance;

-(void) updateValues;

-(void) setValue:(BOOL)value forOption:(NSString*)name;
-(void) setValue1:(NSInteger)value forOption:(NSString*)name;
-(void) setValueArray:(MediaServer1BasicObject*)value forOption:(NSString*)name;
-(void) setString:(NSString *)value forOption:(NSString*)name;
@end
