//
//  Card.m
//  Ring of Fire
//
//  Created by Michael Thorpe on 22/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Card.h"


@implementation Card

-(id)init
{
    if (self = [super init]) {
        central = NO;
    }
    
    return self;
}

-(BOOL)central
{
    return self->central;
}

-(void)toggleCentral
{
    self->central = !self->central;
}

@end
