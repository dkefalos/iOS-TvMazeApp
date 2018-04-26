//
//  SectionCellVC.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 26/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "SectionedSearchVC.h"

@interface SectionedSearchVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *sectionSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sectionLoader;

- (void)showAlertForNoResults;
- (void)populateShowDataWithJsonObject:(NSArray*)jsonObject;

@end

@implementation SectionedSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sectionSearchBar setDelegate:self];
    
    //creation of zero footer so the table doesnt create the empty rows
    self.sectionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add a tap recognizer to the view, so that we can dismiss the keyboard
    UITapGestureRecognizer *tapAnywhere = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapAnywhere.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapAnywhere];
    
    // Hide loader when it is not showed
    self.sectionLoader.hidesWhenStopped = YES;
}

- (void)dismissKeyboard
{
    [self.sectionSearchBar resignFirstResponder];
}

#pragma mark - Data Parsing Methods

- (void)showAlertForNoResults
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sectionLoader stopAnimating];
        
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
            [[Movie alloc] addMovieToShowList:self.moviesData
                          withIterationObject:iterationObj];
        }
        else if ([currentMediaType isEqualToString:@"tv"])
        { // Parsing TVSeries
            [[TVSeries alloc] addTVSeriesToShowList:self.tvSeriesData
                                withIterationObject:iterationObj];
        }
    }
}

/**
 This Function gets the data for the shows from a URL, in a different thread
 */
- (void)getShowData
{
    NSString * searchString = [self.sectionSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //NSString * searchString = [NSString makeURLFriendlyThisString:self.searchBar.text];
    //NSString * searchString = self.searchBar.text;
    //[searchString makeMeURLFriendly];
    //NSLog(@"You Searched : %@", searchString);
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/search/multi?api_key=6b2e856adafcc7be98bdf0d8b076851c&query=%@", searchString];
    NSURL * searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    session.configuration.URLCache = NULL;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        // Getting JSON response
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * jsonObject = [json valueForKey:@"results"];
        
        // Check if we have any data from the response
        if (json.count == 0){ // If we got no results
            [self showAlertForNoResults];
        }
        else
        {
            // If we got results
            // Initializing
            [self.moviesData removeAllObjects];
            [self.tvSeriesData removeAllObjects];
            self.moviesData = [[NSMutableArray alloc] init];
            self.tvSeriesData = [[NSMutableArray alloc] init];
            [self populateShowDataWithJsonObject:jsonObject];
            
            // Reloading the table view data in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sectionLoader stopAnimating];
                [self.sectionsTableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Table View Functions
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) // Movies
    {
        return @"Movies";
    }
    else // if (section == 1) // TVSeries
    {
        return @"TV Series";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0){
        return self.moviesData.count;
    }
    else // if (section == 2)
    {
        return self.tvSeriesData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) // Movies
    {
        // use the cells we have on the xib file for TVSeries
        static NSString *movieCellIdentifier = @"movieCell";
        MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:movieCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        }
        
        // Add the data to the UIElements
        Show* currentMovie = self.moviesData[indexPath.row];
        cell.movieCellTitleLabel.text = currentMovie.title;
        cell.movieCellRatingLabel.text = [NSString stringWithFormat:@"%@", currentMovie.rating];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:currentMovie.imageURL]];
        cell.movieCellImageView.image = [UIImage imageWithData: data];
        cell.movieCellImageView.contentMode = UIViewContentModeScaleAspectFit;
        return cell;
    }
    else // if (indexPath.section == 1) TVSeries
    {
        // use the cells we have on the xib file for TVSeries
        static NSString *seriesCellIdentifier = @"seriesCell";
        TVSeriesTableViewCell *cell = (TVSeriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil] forCellReuseIdentifier:seriesCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        }
        
        // Add the data to the UIElements
        Show* currentTVSeries = self.tvSeriesData[indexPath.row];
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
    if (indexPath.section == 0) // Movies
    {
        detailsVC.showToBeDisplayed = self.moviesData[indexPath.row];
        detailsVC.idToBeDisplayed = self.moviesData[indexPath.row].id;
        
    }
    else // if(indexPath.section == 1) // TV Series
    {
        detailsVC.showToBeDisplayed = self.tvSeriesData[indexPath.row];
        detailsVC.idToBeDisplayed = self.tvSeriesData[indexPath.row].id;
    }
    
    // Start the new ViewController
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - Search Bar Functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] != 0){
        [self.sectionLoader startAnimating];
        [self getShowData];
    }
}

- (void)emptySearchBar{
    self.sectionSearchBar.text = @"";
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
