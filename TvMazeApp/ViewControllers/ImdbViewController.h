//
//  ImdbViewController.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 03/05/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImdbViewControllerDelegate.h"

@interface ImdbViewController : UIViewController

@property (strong, nonatomic) NSString * imdbLinkToBeDisplayed;
@property (strong, nonatomic) id <ImdbViewControllerDelegate> delegate;

@end
