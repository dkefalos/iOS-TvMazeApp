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

@property (strong, nonatomic) NSString *budget;

//Initializer
- (instancetype)initMovieWithId:(NSString *)showId
                       andTitle:(NSString *)showTitle
                        andType:(NSString *)showType
                     andSummary:(NSString *)showSummary
                      andRating:(NSString *)showRating
                    andImageURL:(NSString *)showImageURL
                 andBigImageURL:(NSString *)showBigImageURL
                    andImdbLink:(NSString *)showImdbLink;

// Instance Methods
- (void)addMovieToShowList:(NSMutableArray *)showsData
       withIterationObject:(NSDictionary *)iterationObj;
- (void)addDetailsToMovieWithBudget:(NSString *) showBudget;
- (void)getMovieSummary;

@end
