//
//  Movie.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"

@interface Movie : Show

//Initializer
- (instancetype)initMovieWithTitle:(NSString *)showTitle
                          summary:(NSString *)showSummary
                           rating:(NSString *)showRating
                         imageURL:(NSString *)showImageURL;

- (void)getMovieSummary;

@end
