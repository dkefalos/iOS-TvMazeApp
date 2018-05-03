//
//  MovieTableViewCell.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 25/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieCellRatingLabel;

- (void)setMovieCellWithMovie:(Show*) currentMovie;

@end
