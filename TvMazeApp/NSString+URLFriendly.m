//
//  NSString+URLFriendly.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 18/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "NSString+URLFriendly.h"

@implementation NSString (URLFriendly)

+ (NSString*)makeURLFriendlyThisString:(NSString*) notURLFrieldlyString
{
    notURLFrieldlyString = [notURLFrieldlyString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    notURLFrieldlyString = [notURLFrieldlyString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    notURLFrieldlyString = [notURLFrieldlyString stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return notURLFrieldlyString;
}
- (NSString*)makeMeURLFriendly
{
    /*
    self = [self stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    self = [self stringByReplacingOccurrencesOfString:@"?" withString:@""];
    self = [self stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return self;
    */
    
    NSString* urlFriendlyString;
    
    urlFriendlyString = [self stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlFriendlyString = [urlFriendlyString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    urlFriendlyString = [urlFriendlyString stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return urlFriendlyString;
    
}

@end
