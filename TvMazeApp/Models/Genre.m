//
//  Genre.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 02/05/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "Genre.h"

@interface Genre ()

+ (NSMutableArray*)addToGenreList:(NSMutableArray <Genre*> *)genreList withURLPart:(NSString *)urlPart;
-(BOOL)isAlreadyInGenreList:(NSMutableArray <Genre*> *)genreList;

@end

@implementation Genre

- (instancetype)initGenreWithId:(NSString *)genreId andGenreName:(NSString *)genreName
{
    self = [super init];
    if (self)
    {
        self.genreId = [NSString stringWithFormat:@"%@", genreId];
        self.genreName = genreName;
    }
    return self;
}

/**
 Downloads the genre ids and names and puts them in the correct Array
 
 @param genreArray the array in which we put the genre ids and names
 @return genreArray returning the array filled with data || TODO: is the return value needed????
 */
+ (NSMutableArray *)setGenreList:(NSMutableArray <Genre *> *)genreArray
{
    genreArray = [[NSMutableArray alloc] init];
    
    genreArray = [Genre addToGenreList:genreArray withURLPart:@"movie"];
    genreArray = [Genre addToGenreList:genreArray withURLPart:@"tv"];
    
    return genreArray;
}

- (BOOL)isAlreadyInGenreList:(NSMutableArray <Genre *> *)genreList
{
    for(Genre *iterationGenre in genreList)
    {
        if ([iterationGenre.genreId isEqualToString:self.genreId])
        {
            return YES;
        }
    }
    return NO;
}

+ (NSMutableArray*)addToGenreList:(NSMutableArray <Genre *> *)genreList withURLPart:(NSString *)urlPart
{
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/genre/%@/list?api_key=6b2e856adafcc7be98bdf0d8b076851c", urlPart];
    NSURL * searchURL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    session.configuration.URLCache = NULL;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        // Getting JSON response
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * jsonObject = [json valueForKey:@"genres"];
        
        // Check if we have any data from the response
        if (jsonObject.count == 0) // If we got no results
        {
            NSLog(@"No Movie Genres");
        }
        else
        {
            Genre* currentGenre;
            for (NSDictionary* iterationObj in jsonObject)
            {
                currentGenre = [[Genre alloc] initGenreWithId:iterationObj[@"id"] andGenreName:iterationObj[@"name"]];
                if (![currentGenre isAlreadyInGenreList:genreList])
                {
                    [genreList addObject:currentGenre];
                }
            }
        }
        
    }];
    [dataTask resume];
    return genreList;
}

@end
