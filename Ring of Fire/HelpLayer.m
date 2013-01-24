//
//  Help.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 23/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"


@implementation HelpLayer

+(CCScene *)scene:(GameLayer*)game
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelpLayer *layer = [HelpLayer node];
	[layer setGame:game];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)setGame:(GameLayer*)game
{
    gameLayer = game;
}

- (void)createMenu
{
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"Reset" target:self selector:@selector(Reset)];
    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:@"Instructions" target:self selector:@selector(Instructions)];
    CCMenuItemFont *menuItem3 = [CCMenuItemFont itemWithString:@"Credits" target:self selector:@selector(Credits)];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    
    [menuItem1 setColor:ccc3(0,0,0)];
    [menuItem2 setColor:ccc3(0,0,0)];
    [menuItem3 setColor:ccc3(0,0,0)];
    
    menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    [menu alignItemsVerticallyWithPadding:60];
    [self addChild:menu];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        helpImage = [CCSprite spriteWithFile:@"blank.png"];
        helpImage.position = ccp(size.width/2,size.height/2);
        helpImage.scale = 1;
        
        [self addChild:helpImage];
        [self reorderChild:helpImage z:NSIntegerMin];
        
        [self createMenu];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void)Reset
{
    NSLog(@"Reset");
    [gameLayer resetGame];
    [self removeFromParentAndCleanup:YES];
}

-(void)Instructions
{
    NSLog(@"Instructions");
    [menu removeFromParentAndCleanup:YES];
    
    CCMenuItemFont *menuItem = [CCMenuItemFont itemWithString:@"Ring of Fire" target:self selector:@selector(DismissMenu)];
    [CCMenuItemFont setFontName:@"Helvetica"];
    
    [menuItem setColor:ccc3(0,0,0)];
    
    menu = [CCMenu menuWithItems:menuItem, nil];
    [menu alignItemsVertically];
    [self addChild:menu];
}

-(void)Credits
{
    NSLog(@"Credits");
    [menu removeFromParentAndCleanup:YES];
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"Programmer\n\nMichael Thorpe" target:self selector:@selector(DismissMenu)];
    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:@"Designer\n\nAlister Savage" target:self selector:@selector(DismissMenu)];
    CCMenuItemFont *menuItem3 = [CCMenuItemFont itemWithString:@"Copyright 2013" target:self selector:@selector(DismissMenu)];
    [CCMenuItemFont setFontName:@"Helvetica"];
    
    [menuItem1 setColor:ccc3(0,0,0)];
    [menuItem2 setColor:ccc3(0,0,0)];
    [menuItem3 setColor:ccc3(0,0,0)];
    
    menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    [menu alignItemsVerticallyWithPadding:100];
    [self addChild:menu];
}

-(void)DismissMenu
{
    [menu removeFromParentAndCleanup:YES];
    [self createMenu];
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
