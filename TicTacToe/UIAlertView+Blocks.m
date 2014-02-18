//
//  UIAlertView+Blocks.m
//  TicTacToe
//
//  Created by Jorge Leandro Perez on 9/3/13.
//  Copyright (c) 2013 Automattic. All rights reserved.
//

#import "UIAlertView+Blocks.h"



@interface UIAlertView (ExtensionsPrivateMethods) <UIAlertViewDelegate>
- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
  cancelButtonTitle:(NSString*)cancelButtonTitle
  otherButtonTitles:(NSArray*)otherButtonTitles
		 completion:(UIAlertViewCompletion)completion;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
+ (NSMutableDictionary*)blockMap;
@end



#pragma mark =====================================================================================
#pragma mark UIAlertView Helpers
#pragma mark =====================================================================================

@implementation UIAlertView (Blocks)

- (id)initWithTitle:(NSString*)title
			message:(NSString*)message
  cancelButtonTitle:(NSString*)cancelButtonTitle
  otherButtonTitles:(NSArray*)otherButtonTitles
		 completion:(UIAlertViewCompletion)completion {
	
    if((self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil])) {
		
        UIAlertViewCompletion copy = [completion copy];
        [[[self class] blockMap] setObject:copy forKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
        
        // Add the otherButtonTitles
        for(NSString* buttonTitle in otherButtonTitles) {
            [self addButtonWithTitle:buttonTitle];
        }
    }
    
	return self;
}


#pragma mark Public Methods

+(void)showAlertViewWithTitle:(NSString*)title
                      message:(NSString*)message
                  buttonTitle:(NSString*)buttonTitle {
	
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:buttonTitle, nil];
    [av show];
}


+(void)showAlertViewWithTitle:(NSString*)title
                      message:(NSString*)message
            cancelButtonTitle:(NSString*)cancelButtonTitle
            otherButtonTitles:(NSArray*)otherButtonTitles
				   completion:(UIAlertViewCompletion)completion {
	
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles completion:completion];
    [av show];
}


#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    NSMutableDictionary* map = [[self class] blockMap];
    id mapKey = [NSValue valueWithPointer:(__bridge const void *)(alertView)];
	UIAlertViewCompletion completion = [map objectForKey:mapKey];
	completion(buttonIndex);
    
	[map removeObjectForKey:mapKey];
}


#pragma mark Static Helpers

+ (NSMutableDictionary*)blockMap {
	
    static NSMutableDictionary* _blockMap;
    static dispatch_once_t      _once;
    
    dispatch_once(&_once, ^{
                      _blockMap = [[NSMutableDictionary alloc] init];
                  });
    
    return _blockMap;
}

@end
