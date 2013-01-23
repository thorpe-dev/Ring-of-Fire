//
//  HelloWorldLayer.h
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface GameLayer : CCLayer
{
    NSMutableArray *cardArray;
    NSMutableArray *cardSprites;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
