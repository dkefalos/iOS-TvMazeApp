//
//  Genre.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 02/05/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#define MOVIES 0
#define TV_SERIES 1

#import <Foundation/Foundation.h>
#import "ShowGroupModel.h"

@interface Genre : NSObject

@property (strong, nonatomic) NSString *genreId;
@property (strong, nonatomic) NSString *genreName;

// Instance Methods
- (instancetype)initGenreWithId:(NSString *)genreId andGenreName:(NSString *)genreName;
+ (NSMutableArray*)setGenreList:(NSMutableArray <Genre *> *)genreArray;

@end
