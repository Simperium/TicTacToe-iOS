//
//  TTGameBoard.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/12/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGeneral.h"



#pragma mark =====================================================================================
#pragma mark TTGameBoard
#pragma mark =====================================================================================

@interface TTGameBoard : NSObject

@property (nonatomic, strong, readonly) NSMutableArray* matrix;

- (BOOL)isIndexAvailable:(NSInteger)index;
- (void)setPiece:(TTBoardPieceKind)kind atIndex:(NSInteger)index;
- (TTBoardPieceKind)pieceAtIndex:(NSInteger)index;

- (void)updateWithArray:(NSArray *)array;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
