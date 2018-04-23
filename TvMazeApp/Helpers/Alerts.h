//
//  Alerts.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 23/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchVC.h"

@interface Alerts : UIViewController

+ (void)generateAlertWithTitle:(NSString*)alertTitle
               andAlertMessage:(NSString*)alertMessage
                andButtonTitle:(NSString*)buttonTitle
              inViewController:(UIViewController*)viewController;

@end
