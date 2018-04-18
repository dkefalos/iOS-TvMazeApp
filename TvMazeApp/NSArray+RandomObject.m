//
//  NSArray+RandomObject.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 17/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "NSArray+RandomObject.h"

@implementation NSArray (RandomObject)

- (id)randomObject{
    
    NSMutableArray* randomArray = [[NSMutableArray alloc] initWithArray:self.mutableCopy];
    NSInteger index = arc4random() % [randomArray count] - 1;
    id object = [randomArray objectAtIndex:index];
    [randomArray removeObjectAtIndex:index];
    return object;
}

@end
