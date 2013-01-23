//
//  Help.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 23/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"


@implementation HelpLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelpLayer *layer = [HelpLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        helpImage = [CCSprite spriteWithFile:@"Logo.png"];
        helpImage.position = ccp(size.width/2,size.height/2);
        helpImage.scale = 0.5;
        
        [self addChild:helpImage];
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self removeFromParentAndCleanup:YES];
}



@end
