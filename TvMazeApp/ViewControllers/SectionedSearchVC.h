//
//  SectionCellVC.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 26/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "Show.h"
#import "Movie.h"
#import "TVSeries.h"
#import "PickShowVC.h"
#import "PickShowVCDelegate.h"
#import "Alerts.h"
#import "MovieTableViewCell.h"
#import "TVSeriesTableViewCell.h"

@interface SectionedSearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, PickShowVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (strong, nonatomic) UIViewController* PickVC;
@property (strong, nonatomic) NSMutableArray <Show *> * sectionedShowsData;
@property (strong, nonatomic) NSMutableArray <Show *> * moviesData;
@property (strong, nonatomic) NSMutableArray <Show *> * tvSeriesData;

- (void)getShowData;
- (void)emptySearchBar;
@end
