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

#import <Simperium/Simperium.h>
#import "Player.h"
#import "Match.h"

#import "TTAppDelegate.h"
#import "TTCoreDataManager.h"



#pragma mark =====================================================================================
#pragma mark Constants
#pragma mark =====================================================================================

NSTimeInterval const TTAlertviewDelay	= (0.5f);
NSInteger const TTMatchRetryDelayMax	= (5);


#pragma mark =====================================================================================
#pragma mark Private
#pragma mark =====================================================================================

@interface TTGameplayViewController () <TTBoardViewDataSource, TTBoardViewDelegate, SPBucketDelegate>

@property (nonatomic, weak,   readwrite) IBOutlet UILabel*		statusLabel;
@property (nonatomic, weak,   readwrite) IBOutlet UILabel*		playersLabel;
@property (nonatomic, weak,   readwrite) IBOutlet TTBoardView*	boardView;

@property (nonatomic, strong, readwrite) TTGameController*		controller;
@property (nonatomic, strong, readwrite) Player*				player;
@property (nonatomic, strong, readwrite) Match*					match;

@property (nonatomic, strong, readwrite) NSDictionary*			bucketHandlersMap;

@end


#pragma mark =====================================================================================
#pragma mark TTGameViewController
#pragma mark =====================================================================================

@implementation TTGameplayViewController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		self.controller = [TTGameController new];
		[self.controller startNewGame];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.boardView.delegate   = self;
	self.boardView.datasource = self;
	
	[self registerNewPlayer];
	[self listenForNotifications];
	[self listenForBucketUpdates];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self startMatchWithRandomPlayerAfterDelay];
	[self refreshUserInterface];
}


#pragma mark =====================================================================================
#pragma mark TTBoardView Datasource
#pragma mark =====================================================================================

- (BOOL)isGameActive
{
	return self.match != nil;
}

- (BOOL)isPlayerTurn
{
	return [self.match isPlayerTurn:self.player.playerID];
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
	TTBoardPieceKind myKind = [self.match kindOfPieceForPlayer:self.player.playerID];
	[self.controller.board setPiece:myKind atIndex:index];
	
	// Sync with others + toggle turns
	TTBoardPieceKind opponentKind	= (myKind == TTBoardPieceKindCircle ? TTBoardPieceKindCross : TTBoardPieceKindCircle);
	
	TTCoreDataManager *manager		= [TTCoreDataManager sharedInstance];
	Match *match					= self.match;
	match.matrix					= [self.controller.board matrix];
	match.nextPieceKind				= @(opponentKind);
	[manager save];
	
	// Refresh UI + Check for Winners
	[self refreshUserInterface];
	[self verifyGameStatus];
}


#pragma mark =====================================================================================
#pragma mark Player Presence!
#pragma mark =====================================================================================

- (void)listenForNotifications
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(registerNewPlayer)		name:UIApplicationDidBecomeActiveNotification  object:nil];
	[nc addObserver:self selector:@selector(cleanupMatchAndPlayer)	name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)registerNewPlayer
{
	if (self.player)
	{
		return;
	}
	
	Simperium* simperium	= [[TTAppDelegate sharedDelegate] simperium];
	Player *player			= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Player class]) inManagedObjectContext:simperium.managedObjectContext];
	player.playerID			= simperium.clientID;
	[simperium save];

	self.player = player;
}

- (void)cleanupMatchAndPlayer
{
	// Player + Match will be automatically removed by Simperium's presence mechanism
	self.player = nil;
	self.match = nil;
}


#pragma mark =====================================================================================
#pragma mark Listening for Bucket Changes
#pragma mark =====================================================================================

- (void)listenForBucketUpdates
{
	Simperium *simperium	= [[TTAppDelegate sharedDelegate] simperium];
	NSArray *buckets		= @[ NSStringFromClass([Player class]), NSStringFromClass([Match class]) ];
	
	for (NSString *name in buckets)
	{
		SPBucket *bucket	= [simperium bucketForName:name];
		NSAssert(bucket != nil, @"Bucket not initialized");
		
		bucket.delegate		= self;
	}
}

- (NSDictionary *)bucketHandlersMap
{
	if (_bucketHandlersMap)
	{
		return _bucketHandlersMap;
	}
	
	_bucketHandlersMap = @{
		NSStringFromClass([Player class])	:
		  @{
			  @(SPBucketChangeInsert) : NSStringFromSelector(@selector(handlePlayerInserted:)),
			  @(SPBucketChangeDelete) : NSStringFromSelector(@selector(handlePlayerDeleted:))
		  },
		NSStringFromClass([Match class])	:
		  @{
			  @(SPBucketChangeInsert) : NSStringFromSelector(@selector(handleMatchInserted:)),
			  @(SPBucketChangeUpdate) : NSStringFromSelector(@selector(handleMatchUpdated:)),
			  @(SPBucketChangeDelete) : NSStringFromSelector(@selector(handleMatchDeleted:))
		  }
	};
	
	return _bucketHandlersMap;
}

- (void)bucket:(SPBucket *)bucket didChangeObjectForKey:(NSString *)key forChangeType:(SPBucketChangeType)changeType memberNames:(NSArray *)memberNames
{
	NSString *target = self.bucketHandlersMap[bucket.name][@(changeType)];
	if (target)
	{
		[self performSelector:NSSelectorFromString(target) withObject:key];
	}
}

- (void)handlePlayerInserted:(NSString *)key
{
	[self refreshActivePlayers];
}

- (void)handlePlayerDeleted:(NSString *)key
{
	// Our oponent was deleted
	if ([self.match hasPlayerID:key])
	{
		[self reset];
	}
	
	[self refreshActivePlayers];
}

- (void)handleMatchInserted:(NSString *)key
{
	Simperium *simperium	= [[TTAppDelegate sharedDelegate] simperium];
	SPBucket *bucket		= [simperium bucketForName:NSStringFromClass([Match class])];
	Match *newMatch			= [bucket objectForKey:key];
	
	if ([newMatch hasPlayerID:self.player.playerID])
	{
		// If we already had a match: nuke the new object
		if ([self isGameActive] && [newMatch.simperiumKey isEqual:self.match.simperiumKey] == NO)
		{
			[bucket deleteObject:newMatch];
			[simperium save];
		}
		// We have a new game!
		else
		{
			self.match = newMatch;
			[self refreshUserInterface];
		}
	}
}

- (void)handleMatchUpdated:(NSString *)key
{
	if ([key isEqual:[self.match simperiumKey]])
	{
		[self refreshUserInterface];
		[self verifyGameStatus];
	}
}

- (void)handleMatchDeleted:(NSString *)key
{
	if ([key isEqual:self.match.simperiumKey])
	{
		self.match = nil;
		[self startMatchWithRandomPlayerAfterDelay];
		[self refreshUserInterface];
	}
}


#pragma mark =====================================================================================
#pragma mark Game Initialization
#pragma mark =====================================================================================

- (void)startMatchWithRandomPlayerAfterDelay
{
	NSTimeInterval delay = arc4random() % TTMatchRetryDelayMax;
	[self performSelector:@selector(startMatchWithRandomPlayer) withObject:nil afterDelay:delay];
}

- (void)reset
{
	[self removeCurrentMatch];
	[self startMatchWithRandomPlayerAfterDelay];
	[self refreshUserInterface];
}

- (void)startMatchWithRandomPlayer
{
	if (self.isGameActive)
	{
		return;
	}

	// Retry after a while, if there are no available players
	Player *opponent = nil;
	if (![self randomAvailablePlayer:&opponent])
	{
		[self startMatchWithRandomPlayerAfterDelay];
		return;
	}
	
	// Initiate a game with our oponent
	TTCoreDataManager* manager	= [TTCoreDataManager sharedInstance];
	Match *match				= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Match class]) inManagedObjectContext:manager.managedObjectContext];
	match.circlePlayerID		= self.player.playerID;
	match.crossPlayerID			= opponent.playerID;
	match.nextPieceKind			= @(TTBoardPieceKindCircle);
	[manager save];
	
	// Keep a reference to the match
	self.match = match;
	
	// Refresh UI, at last
	[self refreshUserInterface];
}

- (void)removeCurrentMatch
{
	if (!self.isGameActive)
	{
		return;
	}

	TTCoreDataManager* manager = [TTCoreDataManager sharedInstance];
	[manager.managedObjectContext deleteObject:self.match];
	[manager save];
	self.match = nil;
}

- (BOOL)randomAvailablePlayer:(Player **)player
{
	Simperium *simperium	= [[TTAppDelegate sharedDelegate] simperium];
	SPBucket *bucket		= [simperium bucketForName:NSStringFromClass([Player class])];
	
	for (Player* thePlayer in bucket.allObjects)
	{
		// Don't begin a match against ourselves, please
		if ([thePlayer.playerID isEqual:self.player.playerID] == NO)
		{
			// Don't begin a match with a busy player
			if ([self isPlayerAvailable:thePlayer.playerID])
			{
				*player = thePlayer;
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)isPlayerAvailable:(NSString *)playerID
{
	NSString *bucketName			= NSStringFromClass([Match class]);
	NSManagedObjectContext *context = [[TTCoreDataManager sharedInstance] managedObjectContext];
	
    NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
    fetchRequest.entity				= [NSEntityDescription entityForName:bucketName inManagedObjectContext:context];
    fetchRequest.predicate			= [NSPredicate predicateWithFormat:@"crossPlayerID == %@ OR circlePlayerID == %@", playerID, playerID];
	
    NSError *error;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];

    return (count == 0);
}


#pragma mark =====================================================================================
#pragma mark Helpers
#pragma mark =====================================================================================

- (void)verifyGameStatus
{
	NSIndexSet* indexes = nil;;
	if ([self.controller hasWinners:&indexes])
	{
		[self.boardView animatePiecesAtIndexes:indexes];
		[self performSelector:@selector(displayWinnerAlert) withObject:nil afterDelay:TTAlertviewDelay];
	}
	else if([self.controller hasFinished])
	{
		[self displayDrawAlert];
	}
}

- (void)refreshUserInterface
{
	// Load the matrix from the match's array
	[self.controller.board updateWithArray:self.match.matrix];
	[self.boardView reload];

	// Status Label
	NSString *status = nil;
	if (![self isGameActive])
	{
		status = @"Looking for an oponent...";
	}
	else if ([self isPlayerTurn])
	{
		status = @"It's your turn!";
	}
	else
	{
		status = @"Waiting for your oponent...";
	}
	
	self.statusLabel.text = status;
}

- (void)refreshActivePlayers
{
	Simperium *simperium	= [[TTAppDelegate sharedDelegate] simperium];
	SPBucket *bucket		= [simperium bucketForName:NSStringFromClass([Player class])];
	self.playersLabel.text	= [NSString stringWithFormat:@"Active Players: %lu", (unsigned long)bucket.allObjects.count];
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
								 [self reset];
							 }];
	
}

@end
