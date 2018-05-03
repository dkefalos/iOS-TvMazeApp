//
//  MovieTableViewCell.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 25/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovieCellWithMovie:(Show*) currentMovie
{
    // set the labels
    self.movieCellTitleLabel.text = currentMovie.title;
    self.movieCellRatingLabel.text = [NSString stringWithFormat:@"%@", currentMovie.rating];
    
    // set the image view
    NSURL * imageURL = [NSURL URLWithString:currentMovie.imageURL];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:imageURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse * response, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.movieCellImageView.image = [[UIImage alloc] initWithData:data];
            self.movieCellImageView.contentMode = UIViewContentModeScaleAspectFit;
        });
    }];
    [dataTask resume];
}

@end
