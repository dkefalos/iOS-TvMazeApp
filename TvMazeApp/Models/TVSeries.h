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

- (instancetype)initSeriesWithTitle:(NSString *)showTitle
                            summary:(NSString *)showSummary
                             rating:(NSString *)showRating
                           imageURL:(NSString *)showImageURL
                        bigImageURL:(NSString *)showBigImageURL;

- (void)getEpisodeSummary;

@end
