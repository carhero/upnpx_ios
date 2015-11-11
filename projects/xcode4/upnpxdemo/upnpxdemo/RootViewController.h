//
//  RootViewController.h
//  upnpxdemo
//
//  Created by Bruno Keymolen on 28/05/11.
//  Copyright 2011 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPnPDB.h"
#import "GlobalDBController.h"

@interface RootViewController : UIViewController <UPnPDBObserver, UITableViewDelegate, UITableViewDataSource>{
    UITableView *__weak menuView;
    NSArray *mDevices; //BasicUPnPDevice*
    UILabel *titleLabel;
    
    NSArray *mServer;
    NSArray *mRenderer;
}

@property (weak) IBOutlet UITableView *menuView;
@property (strong) UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITabBar *TabBarCtrl;
@property (strong, nonatomic) IBOutlet UIView *selectView;

@property GlobalDBController * globalConfig;

//protocol UPnPDBObserver
-(void)UPnPDBWillUpdate:(UPnPDB*)sender;
-(void)UPnPDBUpdated:(UPnPDB*)sender;


@end
