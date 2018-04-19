//
//  PickShowVCDelegate.h
//  TvMazeApp
//
//  Created by Dimitris Kefalos on 19/04/2018.
//  Copyright © 2018 dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PickShowVCDelegate <NSObject>

-(void) didPickShowType:(int)ShowTypeFlag;

@end
