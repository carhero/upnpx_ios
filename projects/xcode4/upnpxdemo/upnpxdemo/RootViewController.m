//
//  RootViewController.m
//  upnpxdemo
//
//  Created by Bruno Keymolen on 28/05/11.
//  Copyright 2011 Bruno Keymolen. All rights reserved.
//

#import "RootViewController.h"
#import "UPnPManager.h"
#import "FolderViewController.h"
#import "PlayBack.h"

@interface RootViewController() <UPnPDBObserver>

@end

@implementation RootViewController

@synthesize menuView;
@synthesize titleLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // Select page로부터 선택된 item들만 display한다.
    self.globalConfig = [GlobalDBController getInstance];
    //NSInteger getValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"select_index"];
    
    NSLog(@"viewWillAppear-selectIndex : %ld", self.globalConfig.selectIndex);
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    
    UPnPDB* db = [[UPnPManager GetInstance] DB];
    
    mDevices = [db rootDevices]; //BasicUPnPDevice
    
    [db addObserver:self];
    
    mServer = [[NSArray alloc]init];
    mRenderer = [[NSArray alloc]init];
    
    //Optional; set User Agent
    [[[UPnPManager GetInstance] SSDP] setUserAgentProduct:@"upnpxdemo/1.0" andOS:@"OSX"];
    
    //Search for UPnP Devices 
    [[[UPnPManager GetInstance] SSDP] searchSSDP];      
    
    self.title = @"My UPNPX";
    self.navigationController.toolbarHidden = YES;


    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, self.navigationController.view.frame.size.width, 21.0f)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [self.titleLabel setText:@""];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];

    UIBarButtonItem *ttitle = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];

    NSArray *items = @[ttitle]; 
    self.toolbarItems = items; 
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger devNum = 0;
    
//    BasicUPnPDevice *device = mDevices[section];
//    BOOL isMediaServer = [device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"];
    
    NSLog(@"[mDevices count] : %ld",[mDevices count]);

    
    for(BasicUPnPDevice *device in mDevices)
    {
        if([device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"] )
        {
            devNum += 1;
//            [mServer arrayByAddingObject:device];
        }
        else if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaRenderer:1"])
        {
            devNum += 1;
//            [mRenderer arrayByAddingObject:device];
        }
    }
    
//    return [mDevices count];
    return devNum;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell.
    BasicUPnPDevice *device = mDevices[indexPath.row];
//     [[cell textLabel] setText:[device friendlyName]];
    BOOL isMediaServer = [device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"];
//    cell.accessoryType = isMediaServer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    if (self.globalConfig.selectIndex == 0)
    {
        //media server
        if ([device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"])
        {
            [[cell textLabel] setText:[device friendlyName]];
            cell.accessoryType = isMediaServer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            // yhcha, icon image settings
            cell.imageView.image = device.smallIcon;
        }
    }
    else if(self.globalConfig.selectIndex == 1)
    {
        // media renederer
        if ([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaRenderer:1"])
        {
            [[cell textLabel] setText:[device friendlyName]];
            cell.accessoryType = isMediaServer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            // yhcha, icon image settings
            cell.imageView.image = device.smallIcon;
        }
    }
    
    
    NSLog(@"%ld %@, urn '%@'", (long)indexPath.row, [device friendlyName], device.urn);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicUPnPDevice *device = mDevices[indexPath.row];
    if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"]) // media server
    {
        MediaServer1Device *server = (MediaServer1Device*)device;        
        FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:server andHeader:@"root" andRootId:@"0" ];
        [[self navigationController] pushViewController:targetViewController animated:YES];
        [[PlayBack GetInstance] setServer:server];
    }
    else if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaRenderer:1"])  // media renederer
    {
        [self.titleLabel setText:[device friendlyName]];
        MediaRenderer1Device *render = (MediaRenderer1Device*)device;
        [[PlayBack GetInstance] setRenderer:render];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark - protocol UPnPDBObserver

-(void)UPnPDBWillUpdate:(UPnPDB*)sender{
    NSLog(@"UPnPDBWillUpdate %lu", (unsigned long)[mDevices count]);
}

-(void)UPnPDBUpdated:(UPnPDB*)sender{
    NSLog(@"UPnPDBUpdated %lu", (unsigned long)[mDevices count]);
    [menuView performSelectorOnMainThread : @ selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
