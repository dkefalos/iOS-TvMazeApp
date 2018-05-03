//
//  Show.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

@property (strong, nonatomic) NSString *showId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *showType;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *bigImageURL;
@property (strong, nonatomic) NSString *imdbLink;

// Initializer
- (instancetype)initShowWithId:(NSString *)showId
                      andTitle:(NSString *)showTitle
                       andType:(NSString *)showType
                    andSummary:(NSString *)showSummary
                     andRating:(NSString *)showRating
                   andImageURL:(NSString *)showImageURL
                andBigImageURL:(NSString *)showBigImageURL
                   andImdbLink:(NSString *)showImdbLink;

@end
