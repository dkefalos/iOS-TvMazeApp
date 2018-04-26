//
//  ViewController.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "Show.h"
#import "Movie.h"
#import "TVSeries.h"
#import "PickShowVCDelegate.h"
#import "Alerts.h"
#import "MovieTableViewCell.h"
#import "TVSeriesTableViewCell.h"

@interface SearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, PickShowVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIViewController* PickVC;
@property (strong, nonatomic) NSMutableArray <Show *> * showsData;

- (void)getShowData;
- (void)emptySearchBar;
@end

