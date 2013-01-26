//
//  Helicopter.m
//  iCopter
//
//  Created by Patch on 09/11/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Helicopter.h"

extern FMOD_EVENTPROJECT *project;
extern FMOD_EVENTGROUP *generalGroup;

@implementation Helicopter

- (id) init
{
	self= [super init];
	
    self->width= 85;
    self->height= 69;
    self->xCoord= self->width/2+20;//helico initialement place a 20 pixels du coin superieur gauche
    self->yCoord= screenBounds.size.width-self->height/2-20;
	self->direction= 1;
	/*if (self->direction>0)
        self->hitBox= CGRectMake(self->xCoord-self->width, self->yCoord-self->height,
                                 self->width, self->height);
    else
        self->hitBox= CGRectMake(self->xCoord+self->width, self->yCoord+self->height,
                                 self->width, self->height);*/
	
    //self->skin= [[Image alloc] initWithImageNamed:@"helicopter1.png" filter:GL_LINEAR];
    
    //============== Classe MISSILE ==============//
    self->missiles= [[NSMutableArray alloc] initWithObjects:nil];
    //============================================//
    
    self->skin=[[Image alloc] initWithImageNamed:@"helicopter.png" filter:GL_LINEAR];
    
    spriteSheet = [[SpriteSheet alloc] initWithImageNamed:@"helicopter-rotor.png" spriteSize:CGSizeMake(80,17) spacing:0 margin:0 imageFilter:GL_LINEAR];
    float animationDelay = 0.01f;
    
    animation = [[Animation alloc] init];
    animation.type = kAnimationType_Repeating;
    animation.state = kAnimationState_Running;
    animation.bounceFrame = 10;
    Image* tmpImage;
    for(int i = 0; i < 10; i++) {
        tmpImage = [spriteSheet spriteImageAtCoords:CGPointMake(i, 0)];
        
        [animation addFrameWithImage:tmpImage delay:animationDelay];
    }
    
        
    FMOD_EventProject_GetGroup(project, "helicopter", 1, &helicopterGroup);
    FMOD_EventGroup_GetEvent(helicopterGroup, "helicopter_sound", FMOD_EVENT_DEFAULT, &helicopterEvent);
    // trigger the event
    FMOD_Event_Start(helicopterEvent);
    
    return self;
}


- (void) move:(float)joypadDistance joypadDirection:(float)joypadDirection aDelta:(float)aDelta
{
	self->xCoord-= (aDelta * (10 * joypadDistance)) * sinf(joypadDirection);
	self->yCoord-= (aDelta * (10 * joypadDistance)) * cosf(joypadDirection);
	
	//Stop the player moving beyond the bounds of the screen
	self->xCoord= MIN(MAX(0+self->width/2, self->xCoord),screenBounds.size.height-self->width/2);
	self->yCoord= MIN(MAX(0+self->height/2, self->yCoord),screenBounds.size.width-self->height/2);
    
    [animation updateWithDelta:aDelta];
}

- (void) shoot
{
    //ajout d'un nouveau missile dans le tableau
    [self->missiles addObject:[[Missile alloc] init:(float)self->xCoord yCoord:(float)self->yCoord]];
}

- (void) render
{
	[skin renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
	[animation renderCenteredAtPoint: CGPointMake(round(self->xCoord)+15, round(self->yCoord)+7)];
}


- (void) die
{
    NSLog(@"GAME OVER.");
    FMOD_Event_Stop(helicopterEvent, false);
    [sharedExplosionManager add:bAnimation_helicoAirDestroyed position:CGPointMake(xCoord, yCoord)];
    FMOD_EventGroup_GetEvent(generalGroup, "game_over_sound", FMOD_EVENT_DEFAULT, &gameOverEvent);
    FMOD_Event_Start(gameOverEvent);
    //[self dealloc];
}

@end
