//
//  Alerts.m
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 23/04/2018.
//  Copyright © 2018 Afse. All rights reserved.
//

#import "Alerts.h"

@implementation Alerts

+ (void)generateAlertWithTitle:(NSString*)alertTitle
               andAlertMessage:(NSString*)alertMessage
                andButtonTitle:(NSString*)buttonTitle
              inViewController:(UIViewController*)viewController
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
            if ([viewController respondsToSelector:@selector(emptySearchBar)]){
                [viewController performSelector:@selector(emptySearchBar)];
            }
        }];
    
    [alert addAction:defaultAction];
    [viewController presentViewController:alert animated:YES completion:nil];
    
}
@end
