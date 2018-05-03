//
//  ShowType.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 30/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "ShowGroupModel.h"
#import "Alerts.h"

@implementation ShowGroupModel

- (instancetype)initGroupModelWithGenreId:(NSString *)typeName
{
    self = [super init];
    if (self)
    {
        self.genreId = [NSString stringWithFormat:@"%@", typeName];
        self.showList = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 This Function searches and returns the pointer to the object that has a specific id from an array
 of ShowGroupModels, if any
 
 @param genreIdToBeCheked the ID that we are looking for
 @param genreArray the array with all the data, from which we need to get the specific object
 @return the pointer to the object that we are looking for or nil it is not present in the array
 */
+ (ShowGroupModel *)indexOfThisGenreId:(NSString *)genreIdToBeCheked inThisArray:(NSMutableArray<ShowGroupModel *> *)genreArray
{
    int i;
    for (i=0; i<genreArray.count; i++)
    {
        if ([genreArray[i].genreId isEqualToString:[NSString stringWithFormat:@"%@", genreIdToBeCheked]])
        {
            // if we find the object, we exit through here
            return genreArray[i];
        }
    }
    // if we do not find the object, we exit through here
    return nil;
}

- (void)addShowToShowListFromJsonDictionary:(NSDictionary *)iterationObject
{
    NSString *currentId;
    NSString *currentTitle;
    NSString *currentMediaType;
    NSString *currentSummary;
    NSString *currentRating;
    NSString *currentImageURL;
    NSString *currentBigImageURL;
    NSString *currentImdbLink;
    
    currentId = iterationObject[@"id"];
    if ([iterationObject[@"media_type"] isEqualToString:@"movie"])
    { // Parsing movies
        currentTitle = ([iterationObject[@"original_title"] isEqual:NULL] ? @"No Title" : iterationObject[@"original_title"]);
        currentImdbLink = iterationObject[@"imdb_id"];
        currentMediaType = @"Movie";
    }
    else
    { // Parsing TV Series
        currentTitle = ([iterationObject[@"original_name"] isEqual:NULL] ? @"No Title" : iterationObject[@"original_name"]);
        currentImdbLink = nil;
        currentMediaType = @"TvSeries";
    }
    currentSummary = ([iterationObject[@"overview"] isEqual:[NSNull null]] ? @"No Summary" : iterationObject[@"overview"]);
    currentRating = ([iterationObject[@"vote_average"] isEqual:[NSNull null]] ? @"No Rating avalable" : [NSString stringWithFormat:@"%.1lf/10", [iterationObject[@"vote_average"] floatValue]]);
    if ([iterationObject[@"poster_path"] isEqual:nil])
    {
        currentImageURL = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
        currentBigImageURL = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
    }
    else
    {
        currentImageURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w185/%@", iterationObject[@"poster_path"]];
        currentBigImageURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w1280/%@", iterationObject[@"poster_path"]];
    }
    
    
    Show * curShow = [[Show alloc] initShowWithId:currentId
                                         andTitle:currentTitle
                                          andType:currentMediaType
                                       andSummary:currentSummary
                                        andRating:currentRating
                                      andImageURL:currentImageURL
                                   andBigImageURL:currentBigImageURL
                                      andImdbLink:currentImdbLink];
    
    // Adding it to the list of objects
    [self.showList addObject:curShow];
}

@end
