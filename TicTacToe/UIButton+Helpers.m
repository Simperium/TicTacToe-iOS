//
//  UIButton+Helpers.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 2/10/14.
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "UIButton+Helpers.h"



#pragma mark =====================================================================================
#pragma mark Constants
#pragma mark =====================================================================================

static CGFloat const UIButtonHelperAnimationDuration = 0.3f;
static CGPoint const UIButtonHelperAnchorCenter = {0.5f, 0.5f};


#pragma mark =====================================================================================
#pragma mark UIButton Helpers
#pragma mark =====================================================================================

@implementation UIButton (Helpers)

- (void)setImageForAllStates:(UIImage *)image
{
	NSArray *states = @[ @(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateSelected) ];
	
	for (NSNumber *state in states)
	{
		[self setImage:image forState:state.intValue];
	}
}

- (void)enhanceAndShrink
{
	self.layer.anchorPoint = UIButtonHelperAnchorCenter;
	
	[UIView animateWithDuration:UIButtonHelperAnimationDuration animations:^{
		self.transform	= CGAffineTransformMakeScale(0.75, 0.75);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:UIButtonHelperAnimationDuration animations:^{
			self.transform = CGAffineTransformIdentity;
		}];
	}];
}

@end
