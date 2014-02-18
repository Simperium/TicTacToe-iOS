//
//  TTCoreDataManager.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 1/31/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



#pragma mark =====================================================================================
#pragma mark TTCoreDataManager
#pragma mark =====================================================================================

@interface TTCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext			*managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel			*managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator	*persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (void)save;

@end
