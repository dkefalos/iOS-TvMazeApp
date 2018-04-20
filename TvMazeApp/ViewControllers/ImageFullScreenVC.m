//
//  ImageFullScreenVC.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 19/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "ImageFullScreenVC.h"
#import "DetailsViewController.h"

@interface ImageFullScreenVC ()
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;

@end

@implementation ImageFullScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add a tap recognizer to the view, so that we can see
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickView)];
    [self.view addGestureRecognizer:tap];
    
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.imageURL]];
    self.fullScreenImageView.image = [UIImage imageWithData: data];
    self.fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) didClickView
{
    [self.delegate ImageFullScreenClicked];
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
