//
//  TTGameplayViewController.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 1/31/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "TTGameplayViewController.h"
#import "TTBoardView.h"
#import "TTGameController.h"
#import "UIAlertView+Blocks.h"



#pragma mark =====================================================================================
#pragma mark Constants
#pragma mark =====================================================================================

NSTimeInterval const TTAlertviewDelay		= (0.5f);


#pragma mark =====================================================================================
#pragma mark Private
#pragma mark =====================================================================================

@interface TTGameplayViewController () <TTBoardViewDataSource, TTBoardViewDelegate>

@property (nonatomic, weak,   readwrite) IBOutlet UILabel*		statusLabel;
@property (nonatomic, weak,   readwrite) IBOutlet TTBoardView*	boardView;
@property (nonatomic, strong, readwrite) TTGameController*		controller;
@property (nonatomic, assign, readwrite) TTBoardPieceKind		nextPiece;

@end


#pragma mark =====================================================================================
#pragma mark TTGameViewController
#pragma mark =====================================================================================

@implementation TTGameplayViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		self.controller = [TTGameController new];
		[self startNewGame];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.boardView.delegate   = self;
	self.boardView.datasource = self;
	[self refreshUserInterface];
}


#pragma mark =====================================================================================
#pragma mark TTBoardView Datasource
#pragma mark =====================================================================================

- (BOOL)isGameActive
{
	return YES;
}

- (BOOL)isPlayerTurn
{
	return YES;
}

- (TTBoardPieceKind)kindOfPieceAtIndex:(NSInteger)index
{
	return [self.controller.board pieceAtIndex:index];
}


#pragma mark =====================================================================================
#pragma mark TTBoardView Delegate
#pragma mark =====================================================================================

- (BOOL)boardView:(TTBoardView *)sender canPressCellAtIndex:(NSInteger)index
{
	return [self.controller.board isIndexAvailable:index];
}

- (void)boardView:(TTBoardView *)sender didPressCellAtIndex:(NSInteger)index
{
	[self.controller.board setPiece:_nextPiece atIndex:index];
	[self toggleNextPiece];
	[self verifyGameStatus];
	[self refreshUserInterface];
}


#pragma mark =====================================================================================
#pragma mark Helpers
#pragma mark =====================================================================================

- (void)startNewGame
{
	[self.controller startNewGame];
	[self.boardView reload];
	
	self.nextPiece = TTBoardPieceKindCross;
	[self refreshUserInterface];
}

- (void)verifyGameStatus
{
	NSIndexSet* indexes = nil;;
	if ([self.controller hasWinners:&indexes])
	{
		// Display the alert after the PiecesAnimation concludes
		[self performSelector:@selector(displayWinnerAlert) withObject:nil afterDelay:TTAlertviewDelay];
		[self.boardView animatePiecesAtIndexes:indexes];
	}
	else if([self.controller hasFinished])
	{
		[self displayDrawAlert];
	}
}

- (void)refreshUserInterface
{
	NSString *nextPieceString = (_nextPiece == TTBoardPieceKindCross)? @"Cross" : @"Circle";
	self.statusLabel.text = [NSString stringWithFormat:@"Turn: %@", nextPieceString];
	[self.boardView reload];
}

- (void)toggleNextPiece
{
	self.nextPiece = (_nextPiece ==  TTBoardPieceKindCross) ? TTBoardPieceKindCircle : TTBoardPieceKindCross;
}


#pragma mark =====================================================================================
#pragma mark AlertView Helpers
#pragma mark =====================================================================================

- (void)displayWinnerAlert
{
	NSString *title   = @"Winner!";
	NSString *message = @"We have a winner!. Let's play again";
	[self showAlertWithTitle:title message:message];
}

- (void)displayDrawAlert
{
	NSString *title   = @"Draw";
	NSString *message = @"Nobody won. Let's play again!";
	[self showAlertWithTitle:title message:message];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
	[UIAlertView showAlertViewWithTitle:title
								message:message
					  cancelButtonTitle:@"Accept"
					  otherButtonTitles:nil
							 completion:^(NSUInteger buttonIndex) {
								 [self startNewGame];
							 }];
	
}

@end
