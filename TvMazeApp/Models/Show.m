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
- (instancetype)initShowWithTitle:(NSString*)showTitle
                          summary:(NSString*)showSummary
                           rating:(NSString*)showRating
                         imageURL:(NSString *)showImageURL
                      bigImageURL:(NSString *)showBigImageURL
{
    self = [super init];
    if (self){
        self.title = showTitle;
        self.summary = showSummary;
        self.rating = showRating;
        self.imageURL = showImageURL;
        self.bigImageURL = showBigImageURL;
    }
    return self;
}

@end
