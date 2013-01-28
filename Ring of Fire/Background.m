//
//  Background.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "GameLayer.h"


@implementation Background

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Background *layer = [Background node];
	
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
        
        CCSprite *bg = [CCSprite spriteWithFile:@"Background.png"];
        bg.tag = 1;
        bg.anchorPoint = CGPointMake(0, 0);
        [bg setScale:SCALE];
        [self addChild:bg];
        
        // create and initialize a Label
		CCSprite *label = [CCSprite spriteWithFile:@"Logo.png"];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp(size.width/2 , size.height/2);
        [label setScale: 0.2*SCALE];
        
        [self addChild:label];
        [self addChild:[GameLayer node]];
        
    }
    
    return self;
}



@end
