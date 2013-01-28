//
//  Missile.m
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Missile.h"

extern FMOD_EVENTGROUP *helicopterGroup;


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

    // create an instance of the FMOD event
    FMOD_EventGroup_GetEvent(helicopterGroup, "helicopter_shoot", FMOD_EVENT_DEFAULT, &missileEvent);
    // trigger the event
    FMOD_Event_Start(missileEvent);

    return self;
}


- (Boolean) move
{
	speed= speed-1 - chute*deltat;
	xCoord= xCoord + 2*0.2;
	yCoord= yCoord + speed*deltat;
        
    return yCoord > 70;
    //-10 pour etre sur que le missile est bien completement sorti de l'ecran (pour pas voir le missile disparaitre subitement)
}


- (void) render
{
    //Render the sprite of the ROCKET
	CGPoint missileLocation= CGPointMake(round(self->xCoord), round(self->yCoord));
	//hitBox = CGRectMake(self->xCoord,self->yCoord,width,height);
	//NSLog(@"hitbox %i",hitBox);
	
	[skin renderCenteredAtPoint:missileLocation];
}

- (void) die
{
    //FMOD_EventGroup_GetEvent(helicopterGroup, "helicopter_missile_detonates", FMOD_EVENT_DEFAULT, &missileExplosionEvent);
    //FMOD_Event_Start(missileExplosionEvent);
    //FMOD_Event_Release(missileExplosionEvent, false,1);
    [sharedExplosionManager add:bAnimation_missileDetonates position:CGPointMake(xCoord, yCoord)];
    FMOD_Event_Stop(missileEvent, false);
    FMOD_Event_Release(missileEvent, false,1);
    [self dealloc];
}

@end
