//
//  ShowType.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 30/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"

@interface ShowGroupModel : NSObject

@property (strong, nonatomic) NSMutableArray <Show *> *showList;
@property (strong, nonatomic) NSString *genreId;
@property (strong, nonatomic) NSString *genreName;

// Instance Methods
- (instancetype)initGroupModelWithGenreId:(NSString *)typeName;
- (void)addShowToShowListFromJsonDictionary:(NSDictionary *)iterationObject;

+ (ShowGroupModel *)indexOfThisGenreId:(NSString *)genreIdToBeCheked inThisArray:(NSMutableArray<ShowGroupModel *> *)genreArray;


@end
