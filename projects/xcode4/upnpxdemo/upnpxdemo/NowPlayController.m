//
//  NowPlayController.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import "UPnPManager.h"
#import "FolderViewController.h"
#import "PlayBack.h"

#import "NowPlayController.h"

@interface NowPlayController ()

@end

@implementation NowPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"NowPlayController-viewDidLoadCalled");
    
    //    BasicUPnPDevice *device = mDevices[indexPath.row];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.globalConfig = [GlobalDBController getInstance];
    
    //    self.globalConfig = [GlobalDBController getInstance];
    
    //    BasicUPnPDevice *device = mDevices[self.globalConfig.selectIndex];
    
    
    NSLog(@"self.globalConfig.albumArtUrl : %@", self.globalConfig.albumArtUrl);
    if (self.globalConfig.albumArtUrl != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.globalConfig.albumArtUrl]]];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //CustomTableViewCell * cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                // assign cell image on main thread
                if(img != nil)
                {
                    self.imageAlbumArt.image = img;
                }
                else{
                    self.imageAlbumArt.image = [UIImage imageNamed:@"defaultSong.jpg"];
                }
                
            });
        });
    }
    else{
        self.imageAlbumArt.image = [UIImage imageNamed:@"defaultSong.jpg"];
    }
    
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

@end
