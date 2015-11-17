//
//  FolderViewController.m
//  upnpxdemo
//
//  Created by Bruno Keymolen on 02/07/11.
//  Copyright 2011 Bruno Keymolen. All rights reserved.
//

#import "FolderViewController.h"

#import "MediaServerBasicObjectParser.h"
#import "MediaServer1ItemObject.h"
#import "MediaServer1ContainerObject.h"
#import "PlayBack.h"


MediaServer1ItemObject *mItem;
MediaServer1ItemRes *mResource;

BOOL bIsSongJustPlayed;

@implementation FolderViewController

@synthesize titleLabel;

-(instancetype)initWithMediaDevice:(MediaServer1Device*)device andHeader:(NSString*)header andRootId:(NSString*)rootId{
    self = [super init];
    
    if (self) {
        /* TODO: Properties are not retained. Possible issue? */
        m_device = device;
        m_rootId=rootId;
        m_title=header;
        
        m_playList = [[NSMutableArray alloc] init];
        
        self.globalConfig = [GlobalDBController getInstance];
        //yhcha add
        //[self.globalConfig setValue1:indexPath.row forOption:@"select_index"];
    }

    return self;
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.globalConfig = [GlobalDBController getInstance];
    
    
    // Before we do anything, some devices do not support sorting and will fail if we try to sort on our request
    NSString *sortCriteria = @"";
    NSMutableString *outSortCaps = [[NSMutableString alloc] init];
    [[m_device contentDirectory] GetSortCapabilitiesWithOutSortCaps:outSortCaps];
    
    if ([outSortCaps rangeOfString:@"dc:title"].location != NSNotFound)
    {
        sortCriteria = @"+dc:title";
    }

    //Allocate NMSutableString's to read the results
    NSMutableString *outResult = [[NSMutableString alloc] init];
    NSMutableString *outNumberReturned = [[NSMutableString alloc] init];
    NSMutableString *outTotalMatches = [[NSMutableString alloc] init];
    NSMutableString *outUpdateID = [[NSMutableString alloc] init];
    
    [[m_device contentDirectory] BrowseWithObjectID:m_rootId BrowseFlag:@"BrowseDirectChildren" Filter:@"*" StartingIndex:@"0" RequestedCount:@"0" SortCriteria:sortCriteria OutResult:outResult OutNumberReturned:outNumberReturned OutTotalMatches:outTotalMatches OutUpdateID:outUpdateID];
    
    SoapActionsAVTransport1* _avTransport = [m_device avTransport];
    SoapActionsConnectionManager1* _connectionManager = [m_device connectionManager];
    
    //The collections are returned as DIDL Xml in the string 'outResult'
    //upnpx provide a helper class to parse the DIDL Xml in usable MediaServer1BasicObject object
    //(MediaServer1ContainerObject and MediaServer1ItemObject)
    //Parse the return DIDL and store all entries as objects in the 'mediaObjects' array
    [m_playList removeAllObjects];
    NSData *didl = [outResult dataUsingEncoding:NSUTF8StringEncoding]; 
    MediaServerBasicObjectParser *parser = [[MediaServerBasicObjectParser alloc] initWithMediaObjectArray:m_playList itemsOnly:NO];
    [parser parseFromData:didl];
    
    
    
    self.navigationController.toolbarHidden = YES;
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, self.navigationController.view.frame.size.width, 21.0f)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Verdana" size:18]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0]];
    
    if([[PlayBack GetInstance] renderer] == nil){
        [self.titleLabel setText:@"No Renderer Selected"];        
    }else{
        [self.titleLabel setText:[[[PlayBack GetInstance] renderer] friendlyName] ];
    }
    
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    UIBarButtonItem *ttitle = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    NSArray *items = @[ttitle]; 
    self.toolbarItems = items; 

    
    self.title = m_title;    
    
//    mItem = [[MediaServer1ItemObject alloc]init];
//    mResource = [[MediaServer1ItemRes alloc]init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_playList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MediaServer1BasicObject *item = m_playList[indexPath.row];
   [[cell textLabel] setText:[item title]];
    NSLog(@"[item title]:%@", [item title]);
    
    cell.accessoryType = item.isContainer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    // yhcha, icon image settings
    NSLog(@"item.albumArt = %@", item.albumArt);

#if 1 // 여기를 활성화 하고 Song Play를 시키면 Memory 관련 Fault 가 발생한다.
    if(item.albumArt != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.albumArt]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //CustomTableViewCell * cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                // assign cell image on main thread
                cell.imageView.image = img;
            });
        });
    }
#endif
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MediaServer1BasicObject *item = m_playList[indexPath.row];
    
    if([item isContainer]){
        MediaServer1ContainerObject *container = m_playList[indexPath.row];
        FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:m_device andHeader:[container title] andRootId:[container objectID]];
        [[self navigationController] pushViewController:targetViewController animated:YES];
    }else{
        
        // UITableView update 필요함.
        //[tableView reloadData];
        
        MediaServer1ItemObject *item = m_playList[indexPath.row];
        mItem = m_playList[indexPath.row];
        
        MediaServer1ItemRes *resource = nil;		
        NSEnumerator *e = [[item resources] objectEnumerator];
        while((resource = (MediaServer1ItemRes*)[e nextObject])){
            
            mResource = (MediaServer1ItemRes*)[e nextObject];
            NSLog(@"%@ - %d, %@, %d, %lld, %d, %@", [item title], [resource bitrate], [resource duration], [resource nrAudioChannels], [resource size],  [resource durationInSeconds],  [resource protocolInfo] );
        }	    

        [[PlayBack GetInstance] Play:m_playList position:indexPath.row];
        
        // yhcha, save media data
        //[self.globalConfig setValueArray:item forOption:@"media_data"];
        [self.globalConfig setValue1:indexPath.row forOption:@"select_index"];
        [self.globalConfig setString:item.albumArt forOption:@"albume_art"];
        
        NSLog(@"item.album : %@", item.album);
        NSLog(@"item.artist : %@", item.artist);
        NSLog(@"item.title : %@", item.title);
        
        [self.globalConfig setString:item.album forOption:@"label_albume"];
        [self.globalConfig setString:item.artist forOption:@"label_artist"];
        [self.globalConfig setString:item.title forOption:@"label_song"];
        
        // to save global class variable
        bIsSongJustPlayed = TRUE;
        
        [self.tabBarController setSelectedIndex:1]; // nowplay page 전환됨.
    }
}



@end
