//
//  SelectController.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//
#import "RootViewController.h"
#import "SelectController.h"
#import "GlobalDBController.h"

@interface SelectController ()
{
    //    NSMutableArray *_object;
}
@end

@implementation SelectController

@synthesize selectMenuView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"selectMenuView-viewWillAppear");
    
    //    if (_object.count == 0) {
    //        _object = [[NSMutableArray alloc]initWithObjects:@"AVR DEMO",nil];
    //    }
    //
    //    [self.selectMenuView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.globalConfig = [GlobalDBController getInstance];
    
    self.selectMenuView.dataSource = self;
    self.selectMenuView.delegate = self;
    
    selectItems = [[NSArray alloc]init];
    
    //    selectItems add
    //    _object = []
//    if (_object.count == 0) {
//        _object = [[NSMutableArray alloc]initWithObjects:@"AVR DEMO",nil];
//    }
    _object = [[NSMutableArray alloc]init];
    [_object addObject:@"Select Source"];
    [_object addObject:@"Select Speaier"];
    [_object addObject:@"Browse song list"];
    
    [self.selectMenuView reloadData];
    //    _object = [[NSMutableArray alloc]arrayWithObjects:@"11111111", nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_object count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[_object objectAtIndex:indexPath.row]];
    // Configure the cell.
    //    BasicUPnPDevice *device = mDevices[indexPath.row];
    //    [[cell textLabel] setText:[device friendlyName]];
    //    BOOL isMediaServer = [device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"];
    //    cell.accessoryType = isMediaServer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    // yhcha, icon image settings
    //    cell.imageView.image = device.smallIcon;
    
    //    NSLog(@"%ld %@, urn '%@'", (long)indexPath.row, [device friendlyName], device.urn);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    BasicUPnPDevice *device = mDevices[indexPath.row];
    //    if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"])
    //    {
    //        MediaServer1Device *server = (MediaServer1Device*)device;
    //        FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:server andHeader:@"root" andRootId:@"0" ];
    //        [[self navigationController] pushViewController:targetViewController animated:YES];
    //        [[PlayBack GetInstance] setServer:server];
    //    }
    //    else if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaRenderer:1"])
    //    {
    //        [self.titleLabel setText:[device friendlyName]];
    //        MediaRenderer1Device *render = (MediaRenderer1Device*)device;
    //        [[PlayBack GetInstance] setRenderer:render];
    //    }
    
    [self.globalConfig setValue1:indexPath.row forOption:@"select_index"];
    
    RootViewController *rootViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    [CtrlView updateModelType:[self getAvrModelTypeWithFriendlyName:[_objects objectAtIndex:[indexPath row]]]];
    [self.navigationController pushViewController:rootViewCtrl animated:NO];
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
