//
//  TTGame.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/3/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "TTGameController.h"
#import "TTGeneral.h"



#pragma mark =====================================================================================
#pragma mark Private
#pragma mark =====================================================================================

@interface TTGameController ()
@property (nonatomic, strong, readwrite) TTGameBoard* board;
@end


#pragma mark =====================================================================================
#pragma mark TTGameController
#pragma mark =====================================================================================

@implementation TTGameController

- (void)startNewGame
{
	self.board = [TTGameBoard new];
}

- (BOOL)hasWinners:(NSIndexSet **)winnerIndexes
{
	NSAssert(self.board, @"Board not initialized");
	NSAssert(winnerIndexes, @"You must provide an indexes pointer");
	
	NSIndexSet* indexes		= nil;
	BOOL hasRowWinner		= [self hasWinnerRow:&indexes];
	BOOL hasColumnWinner    = [self hasWinnerColumn:&indexes];
	BOOL hasDiagonalWinner  = [self hasWinnerDiagonal:&indexes];
	BOOL hasAntidiagWinner  = [self hasWinnerAntidiag:&indexes];
	
	if (winnerIndexes)
	{
		*winnerIndexes = indexes;
	}
	
	return ( hasRowWinner || hasColumnWinner || hasDiagonalWinner || hasAntidiagWinner );
}

- (BOOL)hasFinished
{
	NSAssert(self.board, @"Board not initialized");
	for (NSNumber* slot in self.board.matrix)
	{
		if(slot.intValue == TTBoardPieceKindNone)
		{
			return NO;
		}
	}
	
	return YES;
}


#pragma mark =====================================================================================
#pragma mark Private Methods
#pragma mark =====================================================================================

- (BOOL)hasWinnerRow:(NSIndexSet **)indexes
{
	NSMutableIndexSet *path = [NSMutableIndexSet indexSet];
	
	for (NSInteger row = -1; ++row < TTGameBoardRows; )
	{
		BOOL isWinner = YES;
		
		for (NSInteger column = TTGameBoardColumns; --column > 0 && isWinner; )
		{
			NSUInteger indexCurrent			= row * TTGameBoardColumns + column;
			NSUInteger indexPrevious		= indexCurrent - 1;
			
			TTBoardPieceKind pieceCurrent	= [self.board[indexCurrent] intValue];
			TTBoardPieceKind pieceprevious	= [self.board[indexPrevious] intValue];
			
			[path addIndex:indexCurrent];
			[path addIndex:indexPrevious];
			
			isWinner = ( pieceCurrent != TTBoardPieceKindNone && pieceCurrent == pieceprevious );
		}
		
		if (isWinner)
		{
			*indexes = path;
			return YES;
		}
		
		[path removeAllIndexes];
	}
	
	return NO;
}

- (BOOL)hasWinnerColumn:(NSIndexSet **)indexes
{
	NSMutableIndexSet *path = [NSMutableIndexSet indexSet];
	
	for (NSInteger column = -1; ++column < TTGameBoardColumns; )
	{
		BOOL isWinner = YES;
		
		for (NSInteger row = TTGameBoardRows; --row > 0 && isWinner; )
		{
			NSUInteger indexCurrent			= row * TTGameBoardColumns + column;
			NSUInteger indexPrevious		= (row - 1) * TTGameBoardColumns + column;
						
			TTBoardPieceKind pieceCurrent	= [self.board[indexCurrent] intValue];
			TTBoardPieceKind pieceprevious	= [self.board[indexPrevious] intValue];
			
			[path addIndex:indexCurrent];
			[path addIndex:indexPrevious];
			
			isWinner = ( pieceCurrent != TTBoardPieceKindNone && pieceCurrent == pieceprevious );
		}
		
		if (isWinner)
		{
			*indexes = path;
			return YES;
		}
		
		[path removeAllIndexes];
	}
	
	return NO;
}

- (BOOL)hasWinnerDiagonal:(NSIndexSet **)indexes
{
	NSMutableIndexSet *path = [NSMutableIndexSet indexSet];
	
	for (NSInteger row = TTGameBoardRows; --row > 0; )
	{
		NSUInteger indexCurrent			= row * TTGameBoardColumns + row;
		NSUInteger indexPrevious		= (row - 1) * TTGameBoardColumns + row - 1;
		
		TTBoardPieceKind pieceCurrent	= [self.board[indexCurrent] intValue];
		TTBoardPieceKind pieceprevious	= [self.board[indexPrevious] intValue];
		
		if ( pieceCurrent != pieceprevious || pieceCurrent == TTBoardPieceKindNone)
		{
			return NO;
		}
		
		[path addIndex:indexCurrent];
		[path addIndex:indexPrevious];
	}
	
	*indexes = path;
	return YES;
}

- (BOOL)hasWinnerAntidiag:(NSIndexSet **)indexes
{
	NSMutableIndexSet *path = [NSMutableIndexSet indexSet];
	
	for (NSInteger row = TTGameBoardRows; --row > 0; )
	{
		NSUInteger indexCurrent			= (row * TTGameBoardColumns) + (TTGameBoardColumns - row - 1);
		NSUInteger indexPrevious		= (row - 1) * TTGameBoardColumns + (TTGameBoardColumns - row);
		
		TTBoardPieceKind pieceCurrent	= [self.board[indexCurrent] intValue];
		TTBoardPieceKind pieceprevious	= [self.board[indexPrevious] intValue];
		
		if ( pieceCurrent != pieceprevious || pieceCurrent == TTBoardPieceKindNone)
		{
			return NO;
		}
		
		[path addIndex:indexCurrent];
		[path addIndex:indexPrevious];
	}
	
	*indexes = path;
	return YES;
}

@end
