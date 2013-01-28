//
//  Rocket.h
//  iCopter
//
//  Created by Patch on 09/11/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h"

@class RocketLauncher;

@interface Rocket : Projectile
{
	float delta;
	float directionX;
	float directionY;
    float launcherX;
    float launcherY;
    
    FMOD_EVENT *rocketEvent;
}

- (id) init:(float)xCoord yCoord:(float)yCoord targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (void) update:(float)delta;
- (Boolean) move;
- (void) die;
@end
