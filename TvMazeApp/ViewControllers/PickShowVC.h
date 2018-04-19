//
//  PickShowVC.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 18/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickShowVCDelegate.h"

@interface PickShowVC : UIViewController

@property (weak, nonatomic) id <PickShowVCDelegate> delegate;

@end
