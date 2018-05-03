//
//  TV.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "TVSeries.h"

@implementation TVSeries

// Initializer
- (instancetype)initSeriesWithId:(NSString *)showId
                        andTitle:(NSString *)showTitle
                         andType:(NSString *)showType
                      andSummary:(NSString *)showSummary
                       andRating:(NSString *)showRating
                     andImageURL:(NSString *)showImageURL
                  andBigImageURL:(NSString *)showBigImageURL

{
    self = [super initShowWithId:showId
                        andTitle:showTitle
                         andType:showType
                      andSummary:showSummary
                       andRating:showRating
                     andImageURL:showImageURL
                  andBigImageURL:showBigImageURL
                     andImdbLink:nil];
    
    return self;
}

- (void)addTVSeriesToShowList:(NSMutableArray *)showsData
       withIterationObject:(NSDictionary *)iterationObj
{
    NSString *currentId;
    NSString *currentTitle;
    NSString *currentSummary;
    NSString *currentRating;
    NSString *currentImageURL;
    NSString *currentBigImageURL;
    
    currentId = iterationObj[@"id"];
    currentSummary = ([iterationObj[@"overview"] isEqual:[NSNull null]] ? @"No Summary" : iterationObj[@"overview"]);
    currentRating = ([iterationObj[@"vote_average"] isEqual:[NSNull null]] ? @"No Rating avalable" : [NSString stringWithFormat:@"%.1lf/10", [iterationObj[@"vote_average"] floatValue]]);
    if ([iterationObj[@"poster_path"] isEqual:nil])
    {
        currentImageURL = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
        currentBigImageURL = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
    }
    else
    {
        currentImageURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w185/%@", iterationObj[@"poster_path"]];
        currentBigImageURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w1280/%@", iterationObj[@"poster_path"]];
    }
    
    // Parsing movies
    currentTitle = ([iterationObj[@"original_name"] isEqual:[NSNull null]] ? @"No Title" : iterationObj[@"original_name"]);
    
    Show * curShow = [[TVSeries alloc] initSeriesWithId:currentId
                                               andTitle:currentTitle
                                                andType:@"TvSeries"
                                             andSummary:currentSummary
                                              andRating:currentRating
                                            andImageURL:currentImageURL
                                         andBigImageURL:currentBigImageURL];
    
    // Adding it to the list of objects
    [showsData addObject:curShow];
}

- (void)addDetailsToTVSeriesWithNoEpisodes:(NSString *)NoEpisodes
{
    self.NoEpisodes = NoEpisodes;
}

- (void)getEpisodeSummary
{
    NSLog(@"This is the episode summary");
}

@end
