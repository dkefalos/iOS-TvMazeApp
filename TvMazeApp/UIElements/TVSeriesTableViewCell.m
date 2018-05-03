//
//  TVSeriesTableViewCell.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 25/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "TVSeriesTableViewCell.h"

@implementation TVSeriesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTVSeriesCellWithTVSeries:(Show*) currentTVSeries
{
    // Set the labels
    self.seriesCellTitleLabel.text = currentTVSeries.title;
    self.seriesCellRatingLabel.text = currentTVSeries.rating;
    
    // Set the image view
    NSURL * imageURL = [NSURL URLWithString:currentTVSeries.imageURL];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:imageURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse * response, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.seriesCellImageView.image = [[UIImage alloc] initWithData:data];
            self.seriesCellImageView.contentMode = UIViewContentModeScaleAspectFit;
        });
    }];
    [dataTask resume];
}

@end
