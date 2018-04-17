//
//  Show.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 12/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* summary;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSString* imageURL;

- (instancetype)initShowWithTitle:(NSString*)showTitle
                          summary:(NSString*)showSummary
                           rating:(NSString*)showRating
                         imageURL:(NSString*)showImageURL;

@end
