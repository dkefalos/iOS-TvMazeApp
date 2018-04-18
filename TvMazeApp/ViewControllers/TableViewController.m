//
//  ViewController.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "TableViewController.h"
#import "NSArray+RandomObject.h"
#import "../NSString+URLFriendly.m"
#import "PickShowVC.h"

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSDictionary * dataDict;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    
    //creation of zero footer so the table doesnt create the empty rows
    self.listTableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
    
    // Add a tap recognizer to the view, so that we get
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (void)getShowData
{
    NSString * searchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //NSString * searchString = [NSString makeURLFriendlyThisString:self.searchBar.text];
    //NSString * searchString = self.searchBar.text;
    //[searchString makeMeURLFriendly];
    //NSLog(@"You Searched : %@", searchString);
    
    NSString *urlString = [NSString stringWithFormat: @"http://api.tvmaze.com/search/shows?q=%@", searchString];
    NSURL * searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError* error) {

        // Getting JSON response
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * jsonObject = [json valueForKey:@"show"];

        // Check if we have any data from the response
        if (json.count == 0){ // If we got no results
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Results"
                                                                               message:@"Sorry! We could not find your movie!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        } else { // If we got results
            // Initializing
            self.showsData = [[NSMutableArray alloc] init];
            int i=0;
            NSString* currentSummary;
            NSString* currentRating;
            NSString* currentImageURL;
            
            // Parsing the response and putting in an object we need
            for (NSDictionary* iterationObj in jsonObject) {
                // Checking for Nullity and using the checked variables
                currentSummary = ([iterationObj[@"summary"] isEqual:[NSNull null]] ? @"No Summary" : iterationObj[@"summary"]);
                if ([iterationObj[@"rating"] isEqual:[NSNull null]]){
                    currentRating = @"No Rating avalable";
                } else {
                    currentRating = ([iterationObj[@"rating"][@"average"] isEqual:[NSNull null]] ? @"No Rating avalable" : [NSString stringWithFormat:@"%.1lf/10", [iterationObj[@"rating"][@"average"] floatValue]]);
                }
                if ([iterationObj[@"image"] isEqual:[NSNull null]]){
                    currentImageURL = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
                } else {
                    currentImageURL = ([iterationObj[@"image"][@"medium"] isEqual:[NSNull null]] ? @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png" : iterationObj[@"image"][@"medium"]);
                }
                
                // Allocating and initializing the object
                if (i%2==0){
                    Show * curShow = [[Movie alloc] initMovieWithTitle:iterationObj[@"name"]
                                                               summary:currentSummary
                                                                rating:currentRating
                                                              imageURL:currentImageURL];
                    // Adding it to the list of objects
                    [self.showsData addObject:curShow];
                } else {
                    Show * curShow = [[TVSeries alloc] initSeriesWithTitle:iterationObj[@"name"]
                                                                   summary:currentSummary
                                                                    rating:currentRating
                                                                  imageURL:currentImageURL];
                    // Adding it to the list of objects
                    [self.showsData addObject:curShow];
                }
                i++;
            }
            
            // Reloading the table view data in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listTableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.showsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *simpleTableIdentifier = @"showCell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.showTitleLabel.text = self.showsData[indexPath.row].title;
    cell.showRatingLabel.text = [NSString stringWithFormat:@"%@", self.showsData[indexPath.row].rating];
    cell.showSummaryLabel.text = self.showsData[indexPath.row].summary;
    
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.showsData[indexPath.row].imageURL]];
    cell.showImageView.image = [UIImage imageWithData: data];
    cell.showImageView.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}

//Customize cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize a new ViewController
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsViewController"];
    
    // Pass the parameter to the new controller
    detailsVC.showToBeDisplayed = self.showsData[indexPath.row];
    
    // Start the new ViewController
    [self.navigationController pushViewController:detailsVC animated:YES];
}

// Search Bar Functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text length] != 0){
        [self getShowData];
    }
}

- (IBAction)pickShowButtonPressed:(id)sender {
    NSLog(@"Bar Button Pressed");
    
    // Initilize a Pick Show ViewController
    PickShowVC* pickShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PickShow"];
    
    
    // Present the Pick Show ViewController
    [self.navigationController presentViewController:pickShowVC animated:YES completion:NULL];
}

// Memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
