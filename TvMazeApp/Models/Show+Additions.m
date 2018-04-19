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
    // Format the title only when we have to
    const char * testString = [self.title UTF8String];
    if (self.title.length > 8)
    {
        if (memcmp(testString, "Title : ", 8) != 0)
        {
            self.title = [NSString stringWithFormat:@"Title : %@", self.title];
        }
    }
    else
    {
        self.title = [NSString stringWithFormat:@"Title : %@", self.title];
    }
}

@end
