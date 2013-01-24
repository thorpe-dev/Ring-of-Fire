//
//  Help.h
//  Ring of Fire
//
//  Created by Michael Thorpe on 23/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
#import "cocos2d.h"

@interface HelpLayer : CCLayer {
    CCSprite *helpImage;
    GameLayer *gameLayer;
}

+(CCScene *)scene:(GameLayer*)game;

@end
