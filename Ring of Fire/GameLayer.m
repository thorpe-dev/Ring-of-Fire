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
        cardInCenter = NO;
        cardNumber = [NSNumber numberWithInt:-1];
        
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

        [cardArray addObject:[NSNumber numberWithInt:i]];
        [cardSprites addObject:[self createCard:i]];
    }
    
    [self shuffle];
}

- (void)shuffle
{
    NSUInteger count = [cardArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [cardArray exchangeObjectAtIndex:i withObjectAtIndex:n];
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
    
    // If a card was touched
    if (cardTouched != NULL) {
        NSLog(@"card touched");
        
        // If its the card in the center
        if ([cardTouched central]) {
            [self dismissCard:cardTouched];
        }
        // else if its in the ring and there is no card in the middle
        else if (!cardInCenter) {
            NSLog(@"not central");
            cardInCenter = YES;
            centerCard = cardTouched;
            [cardTouched toggleCentral];
            
            // send the card to the center
            CGSize size = [[CCDirector sharedDirector] winSize];

            id moveAction = [CCMoveTo actionWithDuration:1 position:ccp(size.width/2, size.height/2)];
            id sizeAction = [CCScaleTo actionWithDuration:1 scale:0.6];
            id rotateAction = [CCRotateBy actionWithDuration:1 angle:-cardTouched.rotation];
            id cameraAction = [CCOrbitCamera actionWithDuration:1 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:180 angleX:0 deltaAngleX:0];
            id textureAction = [CCCallFunc actionWithTarget:self selector:@selector(updateTexture)];
            
            [cardTouched runAction:moveAction];
            [cardTouched runAction:rotateAction];
            [cardTouched runAction:sizeAction];
            [cardTouched runAction:[CCSequence actions:cameraAction,textureAction,nil]];
            
        }
        
        // Do nothing
    }
}

-(void)updateTexture
{
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"Card1.jpg"];
    [centerCard setTexture: tex];
}

-(void)dismissCard:(Card*)cardTouched
{
    cardInCenter = NO;
    [cardSprites removeObject:cardTouched];
    [cardArray removeObject:cardNumber];    
    [cardTouched removeFromParentAndCleanup:YES];
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

- (void) dealloc
{
	[super dealloc];
}

@end
