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
	self->xCoord= x+10;
	self->yCoord= y-17;
	self->skin= [[Image alloc] initWithImageNamed:path filter:GL_LINEAR];

    // create an instance of the FMOD event
    FMOD_EventGroup_GetEvent(helicopterGroup, "helicopter_shoot_sound", FMOD_EVENT_DEFAULT, &missileEvent);
    // trigger the event
    FMOD_Event_Start(missileEvent);

    return self;
}


- (Boolean) move
{
	speed= speed-1 - chute*deltat;
	xCoord= xCoord + 2*0.2;
	yCoord= yCoord + speed*deltat;
        
    return yCoord > -10;
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
    FMOD_Event_Stop(missileEvent, false);
    [self dealloc];
}

@end