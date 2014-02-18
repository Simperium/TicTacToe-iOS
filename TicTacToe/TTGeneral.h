//
//  TTGeneral.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/3/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark =====================================================================================
#pragma mark Constants
#pragma mark =====================================================================================

extern const NSInteger TTGameBoardSize;
extern const NSInteger TTGameBoardRows;
extern const NSInteger TTGameBoardColumns;

extern NSString* TTSimperiumAppId;
extern NSString* TTSimperiumAppKey;
extern NSString* TTSimperiumToken;

typedef NS_ENUM(NSInteger, TTBoardPieceKind) {
	TTBoardPieceKindNone	= 0,
	TTBoardPieceKindCross	= 1,
	TTBoardPieceKindCircle	= 2
};
