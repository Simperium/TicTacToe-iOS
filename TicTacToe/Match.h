//
//  Match.h
//  TicTacToe-Simperium
//
//  Created by Jorge Leandro Perez on 2/12/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Simperium/SPManagedObject.h>



#pragma mark =====================================================================================
#pragma mark Match
#pragma mark =====================================================================================

@interface Match : SPManagedObject

@property (nonatomic, copy)   NSString* ghostData;
@property (nonatomic, copy)	  NSString* simperiumKey;

@property (nonatomic, retain) NSString* circlePlayerID;
@property (nonatomic, retain) NSString* crossPlayerID;
@property (nonatomic, retain) NSNumber* nextPieceKind;
@property (nonatomic, retain) NSArray*	matrix;

@end
