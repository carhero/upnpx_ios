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
#import "SoapActionsRenderingControl1.h"
#import "NSString+TimeToString.h"

//--------------------------------
#import "NowPlayController.h"

@interface NowPlayController ()
{
    
}
@end


//extern MediaRenderer1Device *mRenderer1;
//extern MediaServer1ItemObject *mItem;
//extern MediaServer1ItemRes *mResource;
extern NSMutableArray *mplaylist; // yhcha, for global sync

extern BOOL bIsSongJustPlayed;

@implementation NowPlayController

@synthesize playCtrl;

@synthesize PlayPauseIcon;
@synthesize RepeatIcon;
@synthesize ShuffleIcon;

//@synthesize elapsedTimer;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    PlayBack *Player = [PlayBack GetInstance];
    MediaServer1ItemObject *item = Player.playlist[Player.pos];
    
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
    
    updateTimer = FALSE;
    
    // Elapsed time update start
    self.elapsedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                         target:self
                                                       selector:@selector(elapsedTimer:)
                                                       userInfo:nil
                                                        repeats:YES];
    if(bIsSongJustPlayed)
    {
        bIsSongJustPlayed = FALSE;
        // elapsed timer set
        updateTimer = TRUE;
        elapsedTimeCnt = 0;
        
        self.elsedTimeLabel.text = [NSString stringFromTime:0];
        self.totalTimeLabel.text = [NSString stringFromTime:item.durationInSeconds];
        
        self.elapsedSlider.minimumValue = 0;
        self.elapsedSlider.maximumValue = item.durationInSeconds;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PlayBack *Player = [PlayBack GetInstance];
    MediaServer1ItemObject *item = Player.playlist[Player.pos];
    
    
    // albume, artist, song label display
    self.label_albume.text = item.album;
    self.label_artist.text = item.artist;
    self.label_song.text = item.title;
    
    if(bIsSongJustPlayed)
    {
        bIsSongJustPlayed = FALSE;
        // elapsed timer set
        updateTimer = TRUE;
        elapsedTimeCnt = 0;
        
        self.elsedTimeLabel.text = [NSString stringFromTime:0];
        self.totalTimeLabel.text = [NSString stringFromTime:item.durationInSeconds];
        
        self.elapsedSlider.minimumValue = 0;
        self.elapsedSlider.maximumValue = item.durationInSeconds;
        
        //[self.elapsedTimer invalidate];
    }
    
    // albumart display
    //NSLog(@"self.globalConfig.albumArtUrl : %@", self.globalConfig.albumArtUrl);
    if (item.albumArt != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.albumArt]]];
            
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
    
    
    if (self.elapsedSlider.value) {
        return;
    }
    
    // elapsed timer set
    updateTimer = TRUE;
    elapsedTimeCnt = 0;
    
    self.elsedTimeLabel.text = [NSString stringFromTime:0];
    self.totalTimeLabel.text = [NSString stringFromTime:item.durationInSeconds];
    
    self.elapsedSlider.minimumValue = 0;
    self.elapsedSlider.maximumValue = item.durationInSeconds;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    updateTimer = FALSE;
    
}


- (void)nowplayCtrl_setInit
{
    PlayBack *Player = [PlayBack GetInstance];
    MediaServer1ItemObject *item = Player.playlist[Player.pos];
    
    updateTimer = TRUE;
    elapsedTimeCnt = 0;
    
    self.elsedTimeLabel.text = [NSString stringFromTime:0];
    self.totalTimeLabel.text = [NSString stringFromTime:item.durationInSeconds];
    
    self.elapsedSlider.minimumValue = 0;
    self.elapsedSlider.maximumValue = item.durationInSeconds;
}

// tick timer with 1sec
-(void)elapsedTimer:(id)sender
{
    PlayBack *Player = [PlayBack GetInstance];
    MediaServer1ItemObject *item = Player.playlist[Player.pos];
    
    if(self.elapsedSlider.value >= self.elapsedSlider.maximumValue)
    {
        self.elapsedSlider.value = 0;
        elapsedTimeCnt = 0;
        item.durationInSeconds = 0;
        
        [self playNext:nil];
        //self.elapsedTimer = nil;
    }
    
    if (item.durationInSeconds) {
        elapsedTimeCnt += 1;
        
        [self.elapsedSlider setValue:elapsedTimeCnt animated:YES];
        self.elsedTimeLabel.text = [NSString stringFromTime:elapsedTimeCnt];
    }
    else
    {
        elapsedTimeCnt = 0;
    }
    
    //    NSLog(@"mResource.durationInSeconds:%d", [mItem durationInSeconds]);
    ////    NSLog(@"size:%@", [mItem size]);
    //    NSLog(@"duration%@", [mItem duration]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateUiInfomation
{
    NSLog(@"updateUiInfomation");
    PlayBack *Player = [PlayBack GetInstance];
    MediaServer1ItemObject *item = Player.playlist[Player.pos];
    
    // elapsed timer refresh
    elapsedTimeCnt = 0;
    self.elsedTimeLabel.text = [NSString stringFromTime:0];
    self.totalTimeLabel.text = [NSString stringFromTime:item.durationInSeconds];
    self.elapsedSlider.minimumValue = 0;
    self.elapsedSlider.maximumValue = item.durationInSeconds;
    
    // albume, artist, song label display
    self.label_albume.text = item.album;
    self.label_artist.text = item.artist;
    self.label_song.text = item.title;
    
    // albumart update
    if (item.albumArt != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.albumArt]]];
            
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
    
    
}



- (IBAction)sliderSetVolumeControl:(UISlider *)sender {
    
    PlayBack *Player = [PlayBack GetInstance];
    
    int volumeTrans = sender.value;
    NSString *volume = [NSString stringWithFormat:@"%d",volumeTrans];
    
    NSLog(@"sliderSetVolumeControl:%@", volume);
    
    if (Player.renderer != nil) {
        [Player.renderer.renderingControl SetVolumeWithInstanceID:@"0" Channel:@"Master" DesiredVolume:volume];
    }
}

- (IBAction)playNext:(id)sender {
    PlayBack *Player = [PlayBack GetInstance];
    NSLog(@"playNext-Current song index:%ld", (long)Player.pos);
    [[PlayBack GetInstance] Play:Player.playlist position:Player.pos+1];
    
    [self updateUiInfomation];
}

- (IBAction)playPrev:(id)sender {
    PlayBack *Player = [PlayBack GetInstance];
    
    NSLog(@"playPrev-Current song index:%ld", (long)Player.pos);
    [[PlayBack GetInstance] Play:Player.playlist position:Player.pos-1];
    
    [self updateUiInfomation];
}

- (IBAction)playPause:(id)sender {
    NSLog(@"playPause");
    
    PlayBack *Player = [PlayBack GetInstance];
    // Flag error를 방지하기 위해서 Image icon을 trigger해서 play/pause를 하도록 할 것.
    
    //[[PlayBack GetInstance] Pause:Player.pos];
    
//    self.PlayPauseIcon.imageView.image
    NSString *currentImageName = [self getFileName:self.PlayPauseIcon.imageView];
    
    NSLog(@"currentImageName = %@", currentImageName);
    
    self.PlayPauseIcon.imageView.image = [UIImage imageNamed:@"Controls_Pause.png"];
    
    //    if (bPlayPause) {
    //        [[PlayBack GetInstance] Pause:Player.pos];
    //
    //        bPlayPause = 0;
    //    }
    //    else
    //    {
    //        [[PlayBack GetInstance] Play:Player.playlist position:Player.pos];
    //        bPlayPause = 1;
    //    }
}




- (NSString *) getFileName:(UIImageView *)imgView{
    
    NSString *imgName = [imgView image].accessibilityIdentifier;
    
    NSLog(@"%@",imgName);
    
    return imgName;
    
}

typedef enum _REP_STAT
{
    eREP_NONE    = 0,
    eREP_ON,
    eREP_ONE,
    eMAX
} REP_STAT;

int selecter;

- (void)changeImage{
    
    switch (selecter) {
        case eREP_NONE:
        default:
            self.RepeatIcon.imageView.image = [UIImage imageNamed:@"Track_Repeat_Off.png"];
            break;
            
        case eREP_ON:
            self.RepeatIcon.imageView.image = [UIImage imageNamed:@"Track_Repeat_On.png"];
            break;
            
        case eREP_ONE:
            self.RepeatIcon.imageView.image = [UIImage imageNamed:@"Track_Repeat_On_Track.png"];
            break;
            
    }
    
}



- (IBAction)repeatAll:(id)sender {
    NSLog(@"repeatAll");
    
//    static REP_STAT sel = 0;
    
    selecter += 1;
    
    if(selecter >= eMAX)
    {
        selecter = eREP_NONE;
    }
    NSLog(@"sel : %d", selecter);
    
//    [self performSelectorOnMainThread : @selector(changeImage:) withObject:nil waitUntilDone:YES];
//    self.RepeatIcon.imageView.image = [UIImage imageNamed:@"Track_Repeat_On.png"];
}

- (IBAction)shuffle:(id)sender {
    
    NSLog(@"shuffle");
}

- (IBAction)seekSong:(UISlider *)sender {
    PlayBack *Player = [PlayBack GetInstance];
    
    int volumeTrans = sender.value;
    
    if(volumeTrans <= 0)
    {
        volumeTrans = 1;
    }
    NSString *seekTarget = [NSString stringFromSeekTime:volumeTrans];
    
    // elapsed timer refresh
    elapsedTimeCnt = sender.value;
    
    NSLog(@"seekSong-timeTarget:%@", seekTarget);
    [Player Seek:seekTarget];
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
