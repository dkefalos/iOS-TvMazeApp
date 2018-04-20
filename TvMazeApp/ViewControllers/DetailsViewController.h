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
#import "StripHTML.h"
#import "ImageFullScreenVC.h"

@interface DetailsViewController : UIViewController <ImageFullScreenDelegate>

@property (strong, nonatomic) Show* showToBeDisplayed;

@end
