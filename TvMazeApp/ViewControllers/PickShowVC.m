//
//  PickShowVC.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 18/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "PickShowVC.h"

@interface PickShowVC ()

@end

@implementation PickShowVC
- (IBAction)pickedTVSeries:(UIButton *)sender
{
    [self.kitsos didPickShowType:0];
}

- (IBAction)pickedMovie:(UIButton *)sender
{
    [self.kitsos didPickShowType:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
