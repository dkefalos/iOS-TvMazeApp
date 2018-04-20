//
//  DetailsViewController.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "DetailsViewController.h"
#import "Show+Additions.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailsSummaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the data to the corresponding UI Elements
    [self.showToBeDisplayed formatTitle];
    self.detailsTitleLabel.text = self.showToBeDisplayed.title;
    self.detailsSummaryLabel.text = [self.showToBeDisplayed.summary stripHtml];
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.showToBeDisplayed.imageURL]];
    self.detailsImageView.image = [UIImage imageWithData: data];
    self.detailsImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Use selector to get the appropriate summary type
    if([self.showToBeDisplayed respondsToSelector:@selector(getMovieSummary)]){
        [self.showToBeDisplayed performSelector:@selector(getMovieSummary)];
    } else if ([self.showToBeDisplayed respondsToSelector:@selector(getEpisodeSummary)]){
        [self.showToBeDisplayed performSelector:@selector(getEpisodeSummary)];
    } else {
        NSLog(@"Cannot display symmary type");
    }
    
    // Add a tap recognizer to the view, so that we can see
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage)];
    self.detailsImageView.userInteractionEnabled = YES;
    //tap.cancelsTouchesInView = NO;
    [self.detailsImageView addGestureRecognizer:tap];
}

- (void) didClickImage
{
    // Instantiate the ImageFullScreenVC
    ImageFullScreenVC * imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"imageFullScreenVC"];
    
    // Pass the needed data to the ImageFullScreenVC
    imageVC.imageURL = self.showToBeDisplayed.bigImageURL;
    imageVC.delegate = self;
    
    [self.navigationController presentViewController:imageVC animated:YES completion:NULL];
}


- (void) fullScreenImageClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
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
