//
//  GlobalDBController.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import "GlobalDBController.h"

@interface GlobalDBController ()

@end

@implementation GlobalDBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//@synthesize deviceName;
//@synthesize scPass;
//@synthesize ssidName;
static GlobalDBController *instance =nil;
@synthesize selectIndex;


+(GlobalDBController *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
//            NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [NSNumber numberWithBool:YES], @"show_device_name",
//                                                  [NSNumber numberWithBool:NO], @"open_device_list",
//                                                  [NSNumber numberWithBool:NO], @"show_sc_pass",
//                                                  nil];
//            [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
//            
//            
//            
            instance= [GlobalDBController new];
//
//            // temp empty device table
//            NSMutableDictionary *devices = [[NSMutableDictionary alloc] init];
//            [[NSUserDefaults standardUserDefaults] setObject:devices forKey:@"devices"];
//            
        }
    }
//    [instance updateValues];
    return instance;
}

-(void) emptyDeviceList
{
    NSMutableDictionary *devices = [[NSMutableDictionary alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:devices forKey:@"devices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"devices"]);
}

-(void) updateValues
{
    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.showDeviceName = [[NSUserDefaults standardUserDefaults] boolForKey:@"show_device_name"];
//    self.openDeviceList = [[NSUserDefaults standardUserDefaults] boolForKey:@"open_device_list"];
//    self.showScPass = [[NSUserDefaults standardUserDefaults] boolForKey:@"show_sc_pass"];
//    self.enableOOB = [[NSUserDefaults standardUserDefaults] boolForKey:@"enable_oob"];
//    self.skipOOB = [[NSUserDefaults standardUserDefaults] boolForKey:@"skip_oob"];
    self.selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"select_index"];
    //self.mDevices = [[NSUserDefaults standardUserDefaults] objectForKey:@"media_data"];
    self.albumArtUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"albume_art"];
}

-(void) setValue:(BOOL)value forOption:(NSString*)name
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:name];
    [self updateValues];
    
}

-(void) setValue1:(NSInteger)value forOption:(NSString*)name
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:name];
    [self updateValues];
}

-(void) setString:(NSString *)value forOption:(NSString*)name
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
    [self updateValues];
}

-(void) setValueArray:(MediaServer1BasicObject*)value forOption:(NSString*)name
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
    [self updateValues];
}

-(void) addDevice:(NSDictionary * )device withKey:(NSString *)key
{
    NSMutableDictionary *devices = [self getDevices];
    
    [devices setValue:device forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:devices forKey:@"devices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

-(NSMutableDictionary*) getDevices {
    return[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"devices"] mutableCopy];
}


@end
