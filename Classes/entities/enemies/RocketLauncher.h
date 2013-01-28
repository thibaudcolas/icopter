//
//  RocketLauncher.h
//  projet
//
//  Created by disadb on 10/12/12.
//  Copyright (c) 2012 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
#import "Rocket.h"
#import "Helicopter.h"

@class Rocket;

extern Helicopter *helicopter;
extern NSMutableArray *rocketLaunchers;

@interface RocketLauncher : Enemy
{
    @public
    int kindOfRocketLauncher;//les differents types de rocketLaunchers
    int shootTimeout;//temps en seconde entre chaque tir
    float shootTimer;
    Boolean readyToShoot;
	NSMutableArray *rockets;
    Animation *animationC;
}

- (void) update:(float)delta;
- (void) aim:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (void) shoot:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (void) die;

@end
