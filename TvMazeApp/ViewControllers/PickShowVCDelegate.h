//
//  PickShowVCDelegate.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 19/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickShowVC;
@protocol PickShowVCDelegate <NSObject>

- (void)didPickShowType:(int)ShowTypeFlag;
- (void)pickShowTypeVC:(PickShowVC*)pickShowTypeVC
       DidPickShowType:(int)ShowTypeFlag;

@end
