//
//  DetailsViewController.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailsSummaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailsTitleLabel.text = self.showTitle;
    self.detailsSummaryLabel.text = self.showSummary;
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.showImageURL]];
    self.detailsImageView.image = [UIImage imageWithData: data];
    self.detailsImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if([self.showToBeDisplayed respondsToSelector:@selector(getMovieSummary)]){
        [self.showToBeDisplayed performSelector:@selector(getMovieSummary)];
    } else if ([self.showToBeDisplayed respondsToSelector:@selector(getEpisodeSummary)]){
        [self.showToBeDisplayed performSelector:@selector(getEpisodeSummary)];
    } else {
        NSLog(@"Cannot display symmary type");
    }
    
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
