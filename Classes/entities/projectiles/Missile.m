//
//  Missile.m
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Missile.h"


@implementation Missile

- (id) init:(float)x yCoord:(float)y
{
	self= [super init];
	
    self->speed= 1.9;
    self->deltat= 0.02;
    self->chute= 9.81;
	NSString *path= @"missile.png";
	self->xCoord= x+25;
	self->yCoord= y-25;
	self->skin= [[Image alloc] initWithImageNamed:path filter:GL_LINEAR];

    [sharedFmodSoundManager add:helicopterShoot];
    
    return self;
}


- (Boolean) move
{
	speed= speed-1 - chute*deltat;
	xCoord= xCoord + 2*0.2;
	yCoord= yCoord + speed*deltat;
        
    if (yCoord<80)
    {
        [self die];
        return false;
    }
    return true;
}


- (void) render
{
    [skin renderCenteredAtPoint:CGPointMake(round(self->xCoord), round(self->yCoord))];
}

- (void) die
{
    [sharedFmodSoundManager stop:helicopterShoot immediate:true];
    [sharedFmodSoundManager release:helicopterShoot immediate:false];
    [sharedFmodSoundManager add:helicopterMissileDetonates];
    [sharedFmodSoundManager release:helicopterMissileDetonates immediate:false];
    
    [sharedExplosionManager add:bAnimation_missileDetonates position:CGPointMake(xCoord, yCoord)];
    [super die];
}

@end
