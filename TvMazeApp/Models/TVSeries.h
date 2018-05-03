//
//  TV.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"

@interface TVSeries : Show

@property (strong, nonatomic) NSString *NoEpisodes;

- (instancetype)initSeriesWithId:(NSString *)showId
                        andTitle:(NSString *)showTitle
                         andType:(NSString *)showType
                      andSummary:(NSString *)showSummary
                       andRating:(NSString *)showRating
                     andImageURL:(NSString *)showImageURL
                  andBigImageURL:(NSString *)showBigImageURL;

// Instance Methods
- (void)addTVSeriesToShowList:(NSMutableArray *)showsData
       withIterationObject:(NSDictionary *)iterationObj;
- (void)addDetailsToTVSeriesWithNoEpisodes:(NSString *)NoEpisodes;
- (void)getEpisodeSummary;

@end
