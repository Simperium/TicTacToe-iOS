//
//  TTAppDelegate.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 1/31/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Simperium/Simperium.h>




#pragma mark =====================================================================================
#pragma mark Tic Tac Toe AppDelegate
#pragma mark =====================================================================================

@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

@property (readwrite, strong, nonatomic) UIWindow	*window;
@property (readwrite, strong, nonatomic) Simperium	*simperium;

+ (TTAppDelegate *)sharedDelegate;

@end
