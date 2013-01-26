//
//  Obus.h
//  iCopter
//
//  Created by Patch on 09/11/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectiles.h"

@class Tank;

@interface Obus : Projectiles
{
	float delta;
	float directionX;
	float directionY;
    float launcherX;
    float launcherY;
    
    FMOD_EVENT *obusEvent;
}

- (id) init:(float)xCoord yCoord:(float)yCoord targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (Boolean) move;
- (void) die;
@end
