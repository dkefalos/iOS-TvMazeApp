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

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIViewController* PickVC;
@property (strong, nonatomic) NSMutableArray <Show *> * showsData;

- (void)getShowData;
@end

