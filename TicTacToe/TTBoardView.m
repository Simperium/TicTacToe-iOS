//
//  TTBoardView.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/3/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "TTBoardView.h"
#import "UIButton+Helpers.h"



#pragma mark =====================================================================================
#pragma mark Constants
#pragma mark =====================================================================================

NSInteger const TTGameBoardFirstPieceTag	= 10;
NSString* const TTCircleImageName			= @"circle";
NSString* const TTCrossImageName			= @"cross";


#pragma mark =====================================================================================
#pragma mark Private
#pragma mark =====================================================================================

@interface TTBoardView ()
@property (nonatomic, strong, readwrite) NSDictionary*	imageMap;
@end


#pragma mark =====================================================================================
#pragma mark TTBoardView
#pragma mark =====================================================================================

@implementation TTBoardView

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.imageMap = @{
		@(TTBoardPieceKindCross)  : [UIImage imageNamed:TTCrossImageName],
		@(TTBoardPieceKindCircle) : [UIImage imageNamed:TTCircleImageName]
	};
	
	// Setup Delegate's
	for (UIButton *button in self.subviews)
	{
		if ([button isKindOfClass:[UIButton class]])
		{
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			button.contentMode = UIViewContentModeScaleToFill;
		}
	}
}

- (void)buttonPressed:(UIButton *)button
{
	if ([self.datasource isGameActive] == NO)
	{
		return;
	}
	
	if ([self.datasource isPlayerTurn] == NO)
	{
		return;
	}
	
	NSInteger index = button.tag - TTGameBoardFirstPieceTag;
	if ([self.delegate boardView:self canPressCellAtIndex:index] == NO)
	{
		return;
	}
	
	[self.delegate boardView:self didPressCellAtIndex:index];
}

- (void)setPieceKind:(TTBoardPieceKind)kind forButton:(UIButton *)button
{
	UIImage *image = self.imageMap[@(kind)];
	[button setImageForAllStates:image];
}


#pragma mark =====================================================================================
#pragma mark Public Methods
#pragma mark =====================================================================================

- (void)animatePiecesAtIndexes:(NSIndexSet *)indexes
{
	NSInteger index = indexes.firstIndex;
	while (index != NSNotFound)
	{
		UIButton *piece	= (UIButton *)[self viewWithTag:(index + TTGameBoardFirstPieceTag)];
		if ([piece isKindOfClass:[UIButton class]])
		{
			[piece enhanceAndShrink];
		}
		
		index = [indexes indexGreaterThanIndex:index];
	}
}

- (void)reload
{
	NSInteger index  = 0;
	UIButton *button = (UIButton *)[self viewWithTag:TTGameBoardFirstPieceTag + index];
	
	while (button != nil)
	{
		NSAssert([button isKindOfClass:[UIButton class]], @"Piece superclass should be UIButton");
		
		TTBoardPieceKind kind = [self.datasource kindOfPieceAtIndex:index];
		[self setPieceKind:kind forButton:button];
		
		++index;
		button = (UIButton *)[self viewWithTag:TTGameBoardFirstPieceTag + index];
	}
}

@end
