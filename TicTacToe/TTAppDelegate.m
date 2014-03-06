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
	[self authenticateSimperiumIfNeeded];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[self authenticateSimperiumIfNeeded];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[self.simperium signOutAndRemoveLocalData:YES completion:nil];
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
	
	self.simperium = [[Simperium alloc] initWithModel:manager.managedObjectModel
											  context:manager.managedObjectContext
										  coordinator:manager.persistentStoreCoordinator];
	
	self.simperium.verboseLoggingEnabled = YES;
}

- (void)authenticateSimperiumIfNeeded
{
	if (self.simperium.user.authenticated) {
		return;
	}
	
	[self.simperium authenticateWithAppID:TTSimperiumAppId token:TTSimperiumToken];
}

@end
