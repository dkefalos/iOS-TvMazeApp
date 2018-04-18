//
//  NSString+URLFriendly.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 18/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLFriendly)

+ (NSString*)makeURLFriendlyThisString:(NSString*) NotURLFrieldlyString;
- (instancetype)makeMeURLFriendly;

@end
