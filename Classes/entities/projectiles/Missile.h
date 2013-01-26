//
//  Missile.h
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectiles.h"

@class Helicopter;

@interface Missile : Projectiles
{
	float deltat;
	float chute;//9.81
    
    FMOD_EVENT *missileEvent;
}

- (id) init:(float)xCoord yCoord:(float)yCoord;
- (Boolean) move;
- (void) die;
@end
