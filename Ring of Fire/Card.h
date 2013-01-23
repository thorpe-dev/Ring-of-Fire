//
//  Card.h
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Card : CCSprite
{
    @private
    BOOL central;
    BOOL clicked;
}

-(BOOL)central;
-(void)toggleCentral;
-(BOOL)clicked;
-(void)toggleClicked;


@end
