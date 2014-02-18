//
//  TTAppDelegate.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 1/31/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTGeneral.h"
#import "TTCoreDataManager.h"




#pragma mark =====================================================================================
#pragma mark Tic Tac Toe AppDelegate
#pragma mark =====================================================================================

@implementation TTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self startSimperium];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[self.simperium authenticateWithToken:TTSimperiumToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[self.simperium signOutAndRemoveLocalData:YES];
}

+ (TTAppDelegate *)sharedDelegate
{
	return (TTAppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark =====================================================================================
#pragma mark Simperium
#pragma mark =====================================================================================

- (void)startSimperium
{
	TTCoreDataManager* manager = [TTCoreDataManager sharedInstance];
	
	self.simperium = [[Simperium alloc] initWithRootViewController:self.window.rootViewController];
	self.simperium.authenticationEnabled = NO;
	self.simperium.verboseLoggingEnabled = YES;
	[self.simperium startWithAppID:TTSimperiumAppId
							APIKey:TTSimperiumAppKey
							 model:manager.managedObjectModel
						   context:manager.managedObjectContext
					   coordinator:manager.persistentStoreCoordinator];
}

@end
