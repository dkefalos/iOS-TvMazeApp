//
//  ViewController.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "SearchVC.h"
#import "NSString+URLFriendly.h"
#import "PickShowVC.h"

@interface SearchVC ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (void)showAlertForNoResults;
- (void)populateShowDataWithJsonObject:(NSArray*)jsonObject;

@end

@implementation SearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    
    //creation of zero footer so the table doesnt create the empty rows
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add a tap recognizer to the view, so that we can dismiss the keyboard
    UITapGestureRecognizer *tapAnywhere = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapAnywhere.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapAnywhere];
    
    // Hide loader when it is not showed
    self.loader.hidesWhenStopped = YES;
}

- (void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Data Parsing Methods

- (void)showAlertForNoResults
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loader stopAnimating];

        [Alerts generateAlertWithTitle:@"No Results"
                       andAlertMessage:@"Sorry! We could not find your movie!"
                        andButtonTitle:@"OK"
                      inViewController:self];
    });
}

- (void)populateShowDataWithJsonObject:(NSArray*)jsonObject
{
    NSString* currentMediaType;
    
    // Parsing the response and putting in an object we need
    for (NSDictionary* iterationObj in jsonObject) {
        // Parsing data that are identical for Movies and TVSeries
        currentMediaType = iterationObj[@"media_type"];
        
        if([currentMediaType isEqualToString:@"movie"])
        { // Parsing movies
            [[Movie alloc] addMovieToShowList:self.showsData
                          withIterationObject:iterationObj];
        }
        else if ([currentMediaType isEqualToString:@"tv"])
        { // Parsing TVSeries
            [[TVSeries alloc] addTVSeriesToShowList:self.showsData
                                withIterationObject:iterationObj];
            
        }
    }
}

/**
 This Function gets the data for the shows from a URL, in a different thread
 */
- (void)getShowData
{
    NSString * searchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/search/multi?api_key=6b2e856adafcc7be98bdf0d8b076851c&query=%@", searchString];
    NSURL * searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    session.configuration.URLCache = NULL;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {

        // Getting JSON response
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * jsonObject = [json valueForKey:@"results"];

        if (jsonObject.count == 0){ // If we got no results
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertForNoResults];
            });
        }
        else
        {
            // If we got results
            // Initializing
            [self.showsData removeAllObjects];
            self.showsData = [[NSMutableArray alloc] init];
            [self populateShowDataWithJsonObject:jsonObject];
            
            // Reloading the table view data in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loader stopAnimating];
                [self.listTableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Table View Functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.showsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *movieCellIdentifier = @"movieCell";
    static NSString *seriesCellIdentifier = @"seriesCell";
    
    if ([self.showsData[indexPath.row].showType isEqualToString:@"Movie"])
    {
        // use the cells we have on the xib file for Movie
        MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:movieCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        }
        
        // Add the data to the UIElements
        Show* currentMovie = self.showsData[indexPath.row];
        cell.movieCellTitleLabel.text = currentMovie.title;
        cell.movieCellRatingLabel.text = [NSString stringWithFormat:@"%@", currentMovie.rating];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:currentMovie.imageURL]];
        cell.movieCellImageView.image = [UIImage imageWithData: data];
        cell.movieCellImageView.contentMode = UIViewContentModeScaleAspectFit;
        return cell;
    }
    else
    {
        // use the cells we have on the xib file for TVSeries
        TVSeriesTableViewCell *cell = (TVSeriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil] forCellReuseIdentifier:seriesCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        }
        
        // Add the data to the UIElements
        Show* currentTVSeries = self.showsData[indexPath.row];
        cell.seriesCellTitleLabel.text = currentTVSeries.title;
        cell.seriesCellRatingLabel.text = currentTVSeries.rating;
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:currentTVSeries.imageURL]];
        cell.seriesCellImageView.image = [UIImage imageWithData: data];
        cell.seriesCellImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        return cell;
    }
}

//Customize cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize a new ViewController
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsViewController"];

    // Pass the parameter to the new controller
    detailsVC.showToBeDisplayed = self.showsData[indexPath.row];
    detailsVC.idToBeDisplayed = self.showsData[indexPath.row].showId;

    // Start the new ViewController
    [self.navigationController pushViewController:detailsVC animated:YES];
    [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search Bar Functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] != 0){
        [self.loader startAnimating];
        [self getShowData];
    }
}

- (void)emptySearchBar{
    self.searchBar.text = @"";
}

#pragma mark - Pick Show VC Protocol
- (IBAction)pickShowButtonPressed:(id)sender
{
    // Initilize a Pick Show ViewController
    PickShowVC* pickShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PickShow"];
    pickShowVC.delegate = self;
    
    // Present the Pick Show ViewController
    [self.navigationController presentViewController:pickShowVC animated:YES completion:NULL];
}

- (void)didPickShowType:(int)ShowTypeFlag
{
    // Dismissing the pick VC to have the alerts
    [self dismissViewControllerAnimated:YES completion:^{
    
        //Separating the selections
        if(ShowTypeFlag == 0) // TV series
        {
            [Alerts generateAlertWithTitle:@"TV series"
                           andAlertMessage:@"You are now searching for TV series"
                            andButtonTitle:@"OK"
                          inViewController:self];
        }
        else if (ShowTypeFlag == 1) // Movies
        {
            [Alerts generateAlertWithTitle:@"Movies"
                           andAlertMessage:@"You are now searching for movies"
                            andButtonTitle:@"OK"
                          inViewController:self];
        }
        else // Unknown
        {
            [Alerts generateAlertWithTitle:@"Unknown Selection"
                           andAlertMessage:@"An Error has occured"
                            andButtonTitle:@"OK"
                          inViewController:self];
        }
    }];
}

- (void)pickShowTypeVC:(PickShowVC*)pickShowTypeVC
       DidPickShowType:(int)ShowTypeFlag
{
    //We will not need the Pick Show VC for now, so we are using the other protocol method in this one
    [self didPickShowType:ShowTypeFlag];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
