//
//  BatteryLevel.m
//  iCopter
//
//  Created by Thibaud Colas on 29/01/13.
//  Copyright (c) 2013 Patches. All rights reserved.
//

#import "BatteryLevel.h"

@implementation BatteryLevel

- (id)init:(Animation*)anim
{
	self = [super init];
    
	if (self!= nil)
    {
        position = CGPointMake(310, 290);
        nbBatteriesLeft = 3;
        blinkingDuration = 0;
		animation = anim;
	}
	return self;
	
}

- (void)update:(float)delta left:(int)batteriesLeft
{
    [animation updateWithDelta:delta];
    if (nbBatteriesLeft > batteriesLeft) {
        blinkingDuration = 3;
        nbBatteriesLeft = batteriesLeft;
    }
    
    if (blinkingDuration > 0) {
        animation.state = animation.state == kAnimationState_Running ? kAnimationState_Stopped : kAnimationState_Running;
        blinkingDuration -= delta;
    } else {
        animation.state = kAnimationState_Running;
    }
}

- (void)render
{
    if (animation.state == kAnimationState_Running) {
        for(int i = 0; i < nbBatteriesLeft; i++) {
            [animation renderAtPoint:CGPointMake(position.x - i * 27, position.y)];
        }
    }

}

@end
