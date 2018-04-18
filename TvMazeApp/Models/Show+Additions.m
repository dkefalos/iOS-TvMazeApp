//
//  Show+Additions.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 17/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import "Show+Additions.h"

@implementation Show (Additions)

- (void)formatTitle
{
    self.title = [NSString stringWithFormat:@"Title : %@", self.title];
}

@end
