//
//  TTGame.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/3/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGameBoard.h"



#pragma mark =====================================================================================
#pragma mark TTGameController
#pragma mark =====================================================================================

@interface TTGameController : NSObject

@property (nonatomic, strong, readonly) TTGameBoard* board;

- (void)startNewGame;
- (BOOL)hasWinners:(NSIndexSet **)winnerIndexes;
- (BOOL)hasFinished;

@end
