//
//  HelloWorldLayer.h
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Card.h"

@interface GameLayer : CCLayer
{
    CCSprite *settings;
    CGSize size;
    NSMutableArray *cardArray;
    NSMutableArray *cardSprites;
    NSNumber *cardNumber;
    Card *centerCard;
    
    BOOL ringBroken;
}

// returns a CCScene as the only child
+(CCScene *) scene;
-(void)resetGame;

@end
