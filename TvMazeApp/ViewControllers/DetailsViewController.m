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

@property (strong, nonatomic) NSString* movieBudget;
@property (strong, nonatomic) NSString* seriesNoEpisodes;

@property (weak, nonatomic) IBOutlet UILabel *detailsSummaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreDetailsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *detailsLoader;


- (void)setMovieExtraDetailsFromId:(NSString*)currentShowId;
- (void)setSeriesExtraDetailsFromId:(NSString*)currentShowId;
- (void)getShowDetailsFromShow:(Show*) show;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Loader Settings
    self.detailsLoader.hidesWhenStopped = YES;
    [self.detailsLoader startAnimating];
    
    Show* displayedShow = self.showToBeDisplayed;
    [self getShowDetailsFromShow:displayedShow];
   
    // Set the data to the corresponding generic UI Elements
    self.detailsTitleLabel.text = self.showToBeDisplayed.title;
    self.detailsSummaryLabel.text = [self.showToBeDisplayed.summary stripHtml];
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.showToBeDisplayed.imageURL]];
    self.detailsImageView.image = [UIImage imageWithData: data];
    self.detailsImageView.contentMode = UIViewContentModeScaleAspectFit;

    // Add a tap recognizer to the view, so that we can see
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage)];
    self.detailsImageView.userInteractionEnabled = YES;
    //tap.cancelsTouchesInView = NO;
    [self.detailsImageView addGestureRecognizer:tap];
}

- (void)getShowDetailsFromShow:(Show *)show
{
    // Distinguish between Movie and Series
    if ([show.showType isEqualToString:@"Movie"])
    {
        [self setMovieExtraDetailsFromId:self.showToBeDisplayed.id];
    }
    else if ([show.showType isEqualToString:@"TvSeries"])
    {
        [self setSeriesExtraDetailsFromId:self.showToBeDisplayed.id];
    }
    else
    {
        self.moreDetailsLabel.text = @"N/A";
        NSLog(@"No Selector");
    }
}


/**
 Gets the extra data and sets the UI Elements for the Extra details for Movie

 @param currentShowId The ID of the Movie that is displayed
 */
- (void)setMovieExtraDetailsFromId:(NSString*)currentShowId
{
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@?api_key=6b2e856adafcc7be98bdf0d8b076851c", currentShowId];
    NSURL *searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSString* budget;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            budget = [jsonObject valueForKey:@"budget"];
            self.movieBudget = (budget != nil ? budget : @"N/A");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.moreDetailsLabel.text = [NSString stringWithFormat:@"Budget : %@", self.movieBudget];
                [self.detailsLoader stopAnimating];
            });
            
        }
    }];
    [dataTask resume];
}

/**
 Gets the extra data and sets the UI Elements for the Extra details for Series
 
 @param currentShowId The ID of the Series that is displayed
 */
- (void)setSeriesExtraDetailsFromId:(NSString*)currentShowId
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%@?api_key=6b2e856adafcc7be98bdf0d8b076851c", currentShowId];
    NSURL *searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSString* NoEpisodes;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NoEpisodes = [jsonObject valueForKey:@"number_of_episodes"];
            self.seriesNoEpisodes = (NoEpisodes != nil ? NoEpisodes : @"N/A");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.moreDetailsLabel.text = [NSString stringWithFormat:@"No Episodes : %@", self.seriesNoEpisodes];
                [self.detailsLoader stopAnimating];
            });
            
        }
    }];
    [dataTask resume];
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
