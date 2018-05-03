//
//  ArraySearchVC.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 30/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "GenreSearchVC.h"

@interface GenreSearchVC ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@property (strong, nonatomic) NSMutableArray <Genre*> *genreArray;
@property (strong, nonatomic) NSMutableArray <ShowGroupModel*> *showGroups;

- (void)showAlertForNoResults;
- (void)populateShowsListWithJsonObject:(NSArray *)jsonObject;
- (void)populateGenreNames;

@end

@implementation GenreSearchVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    
    // Get the genre list. By the time the user makes a search, this should have returned the list
    self.genreArray = [Genre setGenreList:self.genreArray];
    //creation of zero footer so the table doesnt create the empty rows
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add a tap recognizer to the view, so that we can dismiss the keyboard
    UITapGestureRecognizer *tapAnywhere = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapAnywhere.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapAnywhere];
    
    // Hide loader when it is not showed
    self.activityLoader.hidesWhenStopped = YES;
}

#pragma mark - Show Data Parsing Methods

- (void)showAlertForNoResults
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityLoader stopAnimating];
        
        [Alerts generateAlertWithTitle:@"No Results"
                       andAlertMessage:@"Sorry! We could not find your movie!"
                        andButtonTitle:@"OK"
                      inViewController:self];
    });
}

/**
 Populates the names of the used genre IDs, in the show group array
 */
- (void)populateGenreNames
{
    BOOL genreFoundFlag = NO;
    for (ShowGroupModel *iterationShowGroup in self.showGroups)
    {
        for(Genre* iterationGenre in self.genreArray)
        {
            if ([iterationShowGroup.genreId isEqual:iterationGenre.genreId])
            {
                iterationShowGroup.genreName = iterationGenre.genreName;
                genreFoundFlag = YES;
                break;
            }
        }
        if (genreFoundFlag == NO)
        {
            iterationShowGroup.genreName = @"Other";
        }
    }
}

/**
 Fills the show group array, with the show data

 @param jsonObject the object that we got from JSON
 */
- (void)populateShowsListWithJsonObject:(NSArray*)jsonObject
{
    self.showGroups = [[NSMutableArray alloc] init];
    for (NSDictionary* iterationObj in jsonObject)
    {
        if (iterationObj[@"genre_ids"] != nil && [iterationObj[@"genre_ids"] count] != 0)
        {
            ShowGroupModel* newShowGroup;
            newShowGroup = [ShowGroupModel indexOfThisGenreId:iterationObj[@"genre_ids"][0] inThisArray:self.showGroups];
            
            if (newShowGroup == nil) // Group not Found
            {
                newShowGroup = [[ShowGroupModel alloc] initGroupModelWithGenreId:iterationObj[@"genre_ids"][0]];
                
                [newShowGroup addShowToShowListFromJsonDictionary:iterationObj];
                [self.showGroups addObject:newShowGroup];
            }
            else // Group Found
            {
                [newShowGroup addShowToShowListFromJsonDictionary:iterationObj];
            }
        }
        else
        {
            ShowGroupModel* newShowGroup;
            newShowGroup = [ShowGroupModel indexOfThisGenreId:iterationObj[@"Other"] inThisArray:self.showGroups];
            
            if (newShowGroup == nil) // Group not Found
            {
                newShowGroup = [[ShowGroupModel alloc] initGroupModelWithGenreId:iterationObj[@"Other"]];
                
                [newShowGroup addShowToShowListFromJsonDictionary:iterationObj];
                [self.showGroups addObject:newShowGroup];
            }
            else // Group Found
            {
                [newShowGroup addShowToShowListFromJsonDictionary:iterationObj];
            }
        }
    }
    [self populateGenreNames];
}

/**
 This Function gets the data for the shows from a URL, in a different thread
 */
- (void)getShowData
{
    NSString *searchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
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
        if (jsonObject.count == 0) // If we got no results
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertForNoResults];
            });
        }
        else
        {
            // If we got results
            [self populateShowsListWithJsonObject:jsonObject];
            
            // Reloading the table view data in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityLoader stopAnimating];
                [self.listTableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Table View Functions

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // make the move
    Show* showToBeMoved = self.showGroups[sourceIndexPath.section].showList[sourceIndexPath.row];
    [self.showGroups[sourceIndexPath.section].showList removeObjectAtIndex:sourceIndexPath.row];
    [self.showGroups[destinationIndexPath.section].showList insertObject:showToBeMoved atIndex:destinationIndexPath.row];
    
    // remove section if there are no shows in it
    if (self.showGroups[sourceIndexPath.section].showList.count == 0)
    {
        [self.showGroups removeObjectAtIndex:sourceIndexPath.section];
    }
    
    // Show alert if we move between sections
    [Alerts generateAlertWithTitle:@"Warning"
                   andAlertMessage:@"You are moving a show in a different genre"
                    andButtonTitle:@"OK"
                  inViewController:self];
    
    [self.listTableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
    
    // Delete show from show array
    [self.showGroups[indexPath.section].showList removeObjectAtIndex:indexPath.row];
    if(self.showGroups[indexPath.section].showList.count == 0)
    {
        [self.showGroups removeObjectAtIndex:indexPath.section];
    }

    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showGroups[section].genreName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.showGroups[section].showList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self.showGroups[indexPath.section].showList[indexPath.row].showType isEqualToString:@"Movie"]) // Movies
    {
        // use the cells we have on the xib file for TVSeries
        static NSString *movieCellIdentifier = @"movieCell";
        MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:movieCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        }
        // Add the data to the UIElements
        Show* currentMovie = self.showGroups[indexPath.section].showList[indexPath.row];
        [cell setMovieCellWithMovie:currentMovie];
        
        return cell;
    }
    else // TVSeries
    {
        // use the cells we have on the xib file for TVSeries
        static NSString *seriesCellIdentifier = @"seriesCell";
        TVSeriesTableViewCell *cell = (TVSeriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil] forCellReuseIdentifier:seriesCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier];
        }
        
        // Add the data to the UIElements
        Show* currentTVSeries = self.showGroups[indexPath.section].showList[indexPath.row];
        [cell setTVSeriesCellWithTVSeries:currentTVSeries];
        
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
    detailsVC.showToBeDisplayed = self.showGroups[indexPath.section].showList[indexPath.row];
    detailsVC.idToBeDisplayed = self.showGroups[indexPath.section].showList[indexPath.row].showId;
    
    // Start the new ViewController
    [self.navigationController pushViewController:detailsVC animated:YES];
    [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search Bar Functions
- (void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // if we have text in the searchbar, we initiate the show search
    if ([searchBar.text length] != 0)
    {
        [self.activityLoader startAnimating];
        [self getShowData];
    }
}

- (void)emptySearchBar
{
    self.searchBar.text = @"";
}

- (IBAction)lockUnlockButtonPressed:(UIButton *)sender
{
    if (self.listTableView.editing == YES)
    {
        self.listTableView.editing = NO;
        sender.titleLabel.text = @"Lock";
    }
    else
    {
        self.listTableView.editing = YES;
        sender.titleLabel.text = @"Unlock";
    }
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
