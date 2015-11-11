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
    
    NSString *text = @"imagine this is a huge wall of text\n\n\n";
    
    [self.label_albume setNumberOfLines:0];
    [self.label_artist setNumberOfLines:0];
    [self.label_song setNumberOfLines:0];
    
    CGSize labelSize = [text sizeWithFont:self.label_albume.font constrainedToSize:CGSizeMake(280, 240) lineBreakMode:self.label_albume];
    self.label_albume.frame = CGRectMake(0, 0, 280, labelSize.height);
    
    CGSize labelSize1 = [text sizeWithFont:self.label_song.font constrainedToSize:CGSizeMake(280, 240) lineBreakMode:self.label_song];
    self.label_song.frame = CGRectMake(0, 0, 280, labelSize1.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.globalConfig = [GlobalDBController getInstance];
    
    // albume, artist, song label display
    self.label_albume.text = self.globalConfig.label_albume;
    self.label_artist.text = self.globalConfig.label_artist;
    self.label_song.text = self.globalConfig.label_song;
    
    NSLog(@"self.globalConfig.albumArtUrl : %@", self.globalConfig.albumArtUrl);
    if (self.globalConfig.albumArtUrl != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.globalConfig.albumArtUrl]]];
        
            dispatch_async(dispatch_get_main_queue(), ^{

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
