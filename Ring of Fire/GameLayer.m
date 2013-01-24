//
//  HelloWorldLayer.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "HelpLayer.h"
#import "CCTouchDispatcher.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define CARD_COUNT 52
#define RINGSIZE 300

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
        
        size = [[CCDirector sharedDirector] winSize];        
        settings = [CCSprite spriteWithFile:@"Settings.png"];
        settings.position = ccp(size.width*0.95,size.height*0.075);
        [settings setScale:0.3];
        
        [self addChild:settings];

        [self createCardArray];
        ringBroken = NO;
        centerCard = NULL;
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
    // Get a card by generating a random number between 0 and length(array)
    // then removing that number from the array
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
    
    CGFloat angle = 360.0*(CGFloat)x/(CGFloat)CARD_COUNT;
    
    CGFloat xcoord = RINGSIZE * sinf(angle);
    CGFloat ycoord = RINGSIZE * cosf(angle);
    
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)selectCard:(Card*)cardTouched
{
    centerCard = cardTouched;
    
    // send the card to the front
    [self reorderChild:centerCard z:NSIntegerMax];

    // Disable touch
    self.isTouchEnabled = NO;
    
    // Move into the center
    id moveAction = [CCMoveTo actionWithDuration:0.75 position:ccp(size.width/2, size.height/2)];
    // Make twice as large
    id sizeAction = [CCScaleTo actionWithDuration:0.75 scale:1];
    // Reset rotation, in 0.2 seconds
    // Makes it look a lot less weird than in sync with the rest
    id rotateAction = [CCRotateBy actionWithDuration:0.2 angle:-cardTouched.rotation];
    // Update the texture - half the time needed by the camera so as the rotation flips over,
    // we update the texture (and check for the ring being broken)
    id delay = [CCDelayTime actionWithDuration:(0.75/2)];
    id cameraAction = [CCOrbitCamera actionWithDuration:0.75 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:360 angleX:0 deltaAngleX:0];
    id textureAction = [CCCallFunc actionWithTarget:self selector:@selector(updateTexture)];
    // Re-enable touch
    CCCallBlock* animationComplete = [CCCallBlock actionWithBlock:^{ self.isTouchEnabled = YES; }];
    
    
    [cardTouched runAction:moveAction];
    [cardTouched runAction:rotateAction];
    [cardTouched runAction:cameraAction];
    [cardTouched runAction:[CCSequence actions:delay, textureAction, nil]];
    [cardTouched runAction:[CCSequence actions:sizeAction,animationComplete,nil]];
}

-(void)checkRingIntact
{
    for (int i = 0; i < 360 * 10; i++) {
        
        CGFloat angle = 360.0*(CGFloat)i/(CGFloat)(360*10);
        CGFloat xcoord = RINGSIZE * sinf(angle);
        CGFloat ycoord = RINGSIZE * cosf(angle);
        
        if ([self getCardFromPoint:CGPointMake(size.width/2 + xcoord, size.height/2 + ycoord)] == NULL) {
            NSLog(@"Ring broken!");
            CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"break.png"];
            [centerCard setTexture: tex];
            ringBroken = YES;
            return;
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if (CGRectContainsPoint(settings.boundingBox, location)) {
        [self addChild:[HelpLayer scene:self]];
        return;
    }

    Card *cardTouched = [self getCardFromPoint:location];
    
    // If a card was touched
    if (cardTouched != NULL) {
        // If its the card in the center
        if (cardTouched == centerCard) {
            [self dismissCenterCard];
        }
        // else if its in the ring and there is no card in the middle
        else if (centerCard == NULL) {
            [self selectCard:cardTouched];
        }
        else {
            [self flashCenterCard];
        }
    }
}

-(void)flashCenterCard
{
    id popUp = [CCScaleTo actionWithDuration:0.1 scale:1.1];
    id popBack = [CCScaleTo actionWithDuration:0.1 scale:0.9];
    id popRestore = [CCScaleTo actionWithDuration:0.1 scale:1];
    [centerCard runAction:[CCSequence actions:popUp, popBack, popRestore, nil]];
}

-(void)updateTexture
{
    cardNumber = [cardArray objectAtIndex:0];
    int num = (cardNumber.intValue % 13) + 1;
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%d.png",num]];
    [centerCard setTexture: tex];
    
    if (!ringBroken)
        [self checkRingIntact];
}

-(void)dismissCenterCard
{
    [cardSprites removeObject:centerCard];
    [cardArray removeObject:cardNumber];    
    [centerCard removeFromParentAndCleanup:YES];
    centerCard = NULL;
}

-(Card*)getCardFromPoint:(CGPoint)point
{
    Card* retCard = NULL;
    for (Card *card in cardSprites) {
        if (CGRectContainsPoint(card.boundingBox, point)) {
            retCard = card;
        }
    }
    
    return retCard;
}

-(void)resetGame
{
    for (Card *card in cardSprites) {
        [card removeFromParentAndCleanup:YES];
    }
    
    [cardSprites dealloc];
    [cardArray dealloc];
    
    [self createCardArray];
}

@end
