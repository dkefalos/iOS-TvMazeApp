//
//  TVSeriesTableViewCell.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 25/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVSeriesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *seriesCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesCellRatingLabel;


@end
