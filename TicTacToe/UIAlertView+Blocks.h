//
//  UIAlertView+Blocks.h
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 9/3/13.
//  Copyright (c) 2013 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^UIAlertViewCompletion) (NSUInteger buttonIndex);

#pragma mark =====================================================================================
#pragma mark UIAlertView Helpers
#pragma mark =====================================================================================

@interface UIAlertView (Blocks)

+(void)showAlertViewWithTitle:(NSString*)title
                      message:(NSString*)message
                  buttonTitle:(NSString*)buttonTitle;

+(void)showAlertViewWithTitle:(NSString*)title
                      message:(NSString*)message
            cancelButtonTitle:(NSString*)cancelButtonTitle
            otherButtonTitles:(NSArray*)otherButtonTitles
				   completion:(UIAlertViewCompletion)completion;

@end
