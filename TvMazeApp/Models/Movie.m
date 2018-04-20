//
//  Movie.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "Movie.h"

@implementation Movie

// Initializer
- (instancetype)initMovieWithTitle:(NSString *)showTitle
                           summary:(NSString *)showSummary
                            rating:(NSString *)showRating
                          imageURL:(NSString *)showImageURL
                       bigImageURL:(NSString *)showBigImageURL
{
    self = [super initShowWithTitle:showTitle
                            summary:showSummary
                             rating:showRating
                           imageURL:showImageURL
                        bigImageURL:showBigImageURL];

    return self;
}

- (void)getMovieSummary
{
    NSLog(@"This is the movie summary");
}

@end
