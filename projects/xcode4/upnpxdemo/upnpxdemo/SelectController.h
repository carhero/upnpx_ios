//
//  SelectController.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDBController.h"
@interface SelectController : UIViewController /*<UITableViewDelegate, UITableViewDataSource>*/
{
    UITableView *selectMenuView;
    NSArray *selectItems;
    NSMutableArray *_object;
    
}
@property GlobalDBController * globalConfig;
//@property (strong, nonatomic) IBOutlet UITableView *selectMenuView;
//@property (strong, nonatomic) IBOutlet UIView *selectView;

@end
