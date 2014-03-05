//
//  Match.m
//  TicTacToe-Simperium
//
//  Created by Jorge Leandro Perez on 2/12/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "Match.h"



#pragma mark =====================================================================================
#pragma mark Match
#pragma mark =====================================================================================

@implementation Match

@dynamic circlePlayerID;
@dynamic crossPlayerID;
@dynamic ghostData;
@dynamic matrix;
@dynamic simperiumKey;
@dynamic nextPieceKind;

- (BOOL)hasPlayerID:(NSString *)playerID
{
	return [self.circlePlayerID isEqualToString:playerID] || [self.crossPlayerID isEqualToString:playerID];
}

- (TTBoardPieceKind)kindOfPieceForPlayer:(NSString *)playerID
{
	BOOL isCross = [self.crossPlayerID isEqualToString:playerID];
	return (isCross ? TTBoardPieceKindCross : TTBoardPieceKindCircle);
}

- (BOOL)isPlayerTurn:(NSString *)playerID
{
	return (self.nextPieceKind.intValue == [self kindOfPieceForPlayer:playerID]);
}

- (NSString *)nextPieceDescription
{
	return (self.nextPieceKind.intValue == TTBoardPieceKindCross)? @"Cross" : @"Circle";
}

@end
