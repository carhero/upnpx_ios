//
//  TestView1.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 11/11/15.
//  Copyright © 2015 Bruno Keymolen. All rights reserved.
//

#import "TestView1.h"

@interface TestView1 ()

@end

@implementation TestView1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"TestView1-viewDidLoad");
    self.navigationController.navigationBarHidden = NO;
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
