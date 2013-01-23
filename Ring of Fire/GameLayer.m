//
//  HelloWorldLayer.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "Background.h"
#import "Card.h"
#import "CCTouchDispatcher.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define CARD_COUNT 52

// HelloWorldLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {

        [self createCardArray];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) createCardArray
{
    cardArray = [NSMutableArray new];
    cardSprites = [NSMutableArray new];
    
    // Create the range of numbers of 0 to 51
    // Get a card by generating a random number between 0 and length(array) then removing that number
    // from the array
    for (int i = 0; i < CARD_COUNT; i++) {

        [cardArray addObject:[NSDecimalNumber numberWithInt:i]];
        [cardSprites addObject:[self createCard:i]];
    }
}

-(Card*)createCard:(int)x
{
    Card *card = [Card spriteWithFile:@"CardBack.png"];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CGFloat angle = 360.0*(CGFloat)x/(CGFloat)CARD_COUNT;
    
    CGFloat xcoord = 300 * sinf(angle);
    CGFloat ycoord = 300 * cosf(angle);
    
    CGFloat rotation = 360.0*(float)random()/RAND_MAX;
    
    card.position = ccp(size.width/2 + xcoord, size.height/2 + ycoord);
    [card setScale:0.3];
    [card setRotation:rotation];
    [self addChild:card];
    
    return card;
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];

    Card *cardTouched = [self getCardFromPoint:location];
    
    if (cardTouched != NULL) {
        NSLog(@"card touched");
        
        if ([cardTouched central]) {
            [self popupCard:cardTouched];
        } else {
            CGSize size = [[CCDirector sharedDirector] winSize];
            cardTouched.position = ccp(size.width/2, size.height/2);
            [cardTouched toggleCentral];
        }
    }
}

-(void)popupCard:(Card*)cardTouched
{
    cardTouched.scale *= 2;
}

-(Card*)getCardFromPoint:(CGPoint)point
{
    Card *retCard = NULL;
    for (Card *card in cardSprites) {
        if (CGRectContainsPoint(card.boundingBox, point)) {
            retCard = card;
        }
    }
    
    return retCard;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
