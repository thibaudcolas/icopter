//
//  Tank.h
//  projet
//
//  Created by disadb on 10/12/12.
//  Copyright (c) 2012 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ennemies.h"
#import "Obus.h"

@class Obus;

FMOD_EVENTGROUP *tankGroup;
FMOD_EVENT *tankEvent;

@interface Tank : Ennemies
{
    @public
    int kindOfTank;//les differents types de tanks
    int shootTimeout;//temps en seconde entre chaque tir
    float shootTimer;
	NSMutableArray *obus;
    
}

- (void) aim:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (void) shoot:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
- (void) die;

@end
