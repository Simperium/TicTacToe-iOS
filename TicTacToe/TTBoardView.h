//
//  TTBoardView.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/3/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGeneral.h"



#pragma mark =====================================================================================
#pragma mark TTBoardView Protocols
#pragma mark =====================================================================================

@class TTBoardView;

@protocol TTBoardViewDataSource <NSObject>
- (BOOL)isPlayerTurn;
- (BOOL)isGameActive;
- (TTBoardPieceKind)kindOfPieceAtIndex:(NSInteger)index;
@end

@protocol TTBoardViewDelegate <NSObject>
- (BOOL)boardView:(TTBoardView *)sender canPressCellAtIndex:(NSInteger)index;
- (void)boardView:(TTBoardView *)sender didPressCellAtIndex:(NSInteger)index;
@end


#pragma mark =====================================================================================
#pragma mark TTBoardView
#pragma mark =====================================================================================

@interface TTBoardView : UIView

@property (nonatomic, weak, readwrite) id<TTBoardViewDataSource> datasource;
@property (nonatomic, weak, readwrite) id<TTBoardViewDelegate> delegate;

- (void)animatePiecesAtIndexes:(NSIndexSet *)indexes;
- (void)reload;

@end
