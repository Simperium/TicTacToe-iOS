//
//  Player.h
//  TicTacToe-Simperium
//
//  Created by Jorge Leandro Perez on 2/11/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Simperium/SPManagedObject.h>



#pragma mark =====================================================================================
#pragma mark Player
#pragma mark =====================================================================================

@interface Player : SPManagedObject

@property (nonatomic, copy)   NSString * simperiumKey;
@property (nonatomic, copy)   NSString * ghostData;
@property (nonatomic, retain) NSString * playerID;

@end
