//
//  ImageFullScreenVC.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 19/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFullScreenDelegate.h"

@interface ImageFullScreenVC : UIViewController

@property (weak,nonatomic) NSString* imageURL;
@property (weak, nonatomic) id <ImageFullScreenDelegate> delegate;

@end
