//
//  SelectController.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/9/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//
#import "RootViewController.h"
#import "GlobalDBController.h"

#import "SelectController.h"

@interface SelectController ()
{
    //    NSMutableArray *_object;
    NSInteger viewCnt;
}
@end

@implementation SelectController

//@synthesize selectMenuView;
//@synthesize selectView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.globalConfig = [GlobalDBController getInstance];
    
    // 최초 실행 page는 이 navigation tab bar가 필요없다.

}

- (IBAction)buttonDMSClicked:(id)sender {
    NSLog(@"buttonDMSClicked");
    
    RootViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"RootView"];
    [self.navigationController pushViewController:rootView animated:YES];
}

- (IBAction)buttonDMRClicked:(id)sender {
    
    NSLog(@"buttonDMRClicked");
    UIViewController *uiView = [[UIViewController alloc]init];
    [self.navigationController pushViewController:uiView animated:YES];
}

- (IBAction)buttonBrowseClicked:(id)sender {
    
    NSLog(@"buttonBrowseClicked");
//    UIViewController *uiView = [[UIViewController alloc]init];
//    [self.navigationController pushViewController:uiView animated:YES];
//    [self.tabBarController setSelectedIndex:1];
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
