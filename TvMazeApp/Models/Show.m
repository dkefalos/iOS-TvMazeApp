//
//  Show.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "Show.h"

@implementation Show

// Initializer
- (instancetype)initShowWithId:(NSString *)showId
                      andTitle:(NSString *)showTitle
                       andType:(NSString *)showType
                    andSummary:(NSString *)showSummary
                     andRating:(NSString *)showRating
                   andImageURL:(NSString *)showImageURL
                andBigImageURL:(NSString *)showBigImageURL
{
    
    self = [super init];
    if (self){
        self.showId = showId;
        self.title = showTitle;
        self.showType = showType;
        self.summary = showSummary;
        self.rating = showRating;
        self.imageURL = showImageURL;
        self.bigImageURL = showBigImageURL;
    }
    return self;
}

@end
