//
//  TTGameBoard.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/12/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "TTGameBoard.h"



#pragma mark =====================================================================================
#pragma mark Private
#pragma mark =====================================================================================

@interface TTGameBoard ()
@property (nonatomic, strong, readwrite) NSMutableArray* matrix;
@end


#pragma mark =====================================================================================
#pragma mark TTGameBoard
#pragma mark =====================================================================================

@implementation TTGameBoard

- (instancetype)init
{
	if ((self = [super init]))
	{
		[self reset];
	}
	
	return self;
}

- (BOOL)isIndexAvailable:(NSInteger)index
{
	return [self pieceAtIndex:index] == TTBoardPieceKindNone;
}

- (void)setPiece:(TTBoardPieceKind)kind atIndex:(NSInteger)index
{
	NSAssert(self.matrix, @"Matrix not initialized");
	NSAssert(index >= 0 && index < TTGameBoardSize, @"Index out of bounds");
	
	self[index] = @(kind);
}

- (TTBoardPieceKind)pieceAtIndex:(NSInteger)index
{
	NSAssert(self.matrix, @"Matrix not initialized");
	NSAssert(index >= 0 && index < TTGameBoardSize, @"Index out of bounds");
	
	return [self[index] intValue];
}

- (void)updateWithArray:(NSArray *)array
{
	if (!array)
	{
		[self reset];
	}
	else
	{
		NSAssert(array.count == TTGameBoardSize, @"Array should have the same size as the current board");
		self.matrix = [array mutableCopy];
	}
}


#pragma mark =====================================================================================
#pragma mark Keyed Subscript
#pragma mark =====================================================================================

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return self.matrix[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
	self.matrix[idx] = obj;
}


#pragma mark =====================================================================================
#pragma mark Helpers
#pragma mark =====================================================================================

- (void)reset
{
	NSMutableArray* slots = [NSMutableArray array];
	for (NSInteger i = -1; ++i < TTGameBoardSize; )
	{
		[slots addObject:@(TTBoardPieceKindNone)];
	}
	
	self.matrix = slots;
}

@end
