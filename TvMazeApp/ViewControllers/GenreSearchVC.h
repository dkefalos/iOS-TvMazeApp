//
//  ArraySearchVC.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 30/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "Show.h"
#import "ShowGroupModel.h"
#import "Movie.h"
#import "TVSeries.h"
#import "PickShowVC.h"
#import "PickShowVCDelegate.h"
#import "Alerts.h"
#import "MovieTableViewCell.h"
#import "TVSeriesTableViewCell.h"
#import "Genre.h"

@interface GenreSearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, PickShowVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIViewController *PickVC;

- (void)getShowData;
- (void)emptySearchBar;

@end
