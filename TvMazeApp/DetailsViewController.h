//
//  DetailsViewController.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 11/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "Movie.h"
#import "TVSeries.h"

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *showTitle;
@property (strong, nonatomic) NSString *showSummary;
@property (strong, nonatomic) NSString *showImageURL;
@property (strong, nonatomic) NSString *showRating;
@property (strong, nonatomic) Show* showToBeDisplayed;

@end
