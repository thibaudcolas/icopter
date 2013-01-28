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
    
    SpriteSheet *spriteSheet = [[SpriteSheet alloc] initWithImageNamed:@"helicopter-rotor.png" spriteSize:CGSizeMake(80,17) spacing:0 margin:0 imageFilter:GL_LINEAR];
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
        
    [spriteSheet release];
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
    
    //altitude et crash:
    if (self->yCoord<140) [sharedFmodSoundManager play:helicopterAltitudeAlert];
    else [sharedFmodSoundManager pause:helicopterAltitudeAlert];
    if (self->yCoord<100) {NSLog(@"HELICOPTER CRASHED ON THE GROUND!");[self die];}
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
    [sharedFmodSoundManager stop:helicopterSound immediate:false];
    [sharedFmodSoundManager release:helicopterSound immediate:false];
    [sharedFmodSoundManager add:helicopterExplosion];
    [sharedFmodSoundManager stop:helicopterExplosion immediate:false];
    [sharedFmodSoundManager release:helicopterExplosion immediate:false];
    [sharedFmodSoundManager add:gameOverSound];
    [sharedFmodSoundManager stop:gameOverSound immediate:false];
    [sharedFmodSoundManager release:gameOverSound immediate:false];
    
    [sharedExplosionManager add:bAnimation_helicoAirDestroyed position:CGPointMake(xCoord, yCoord)];
    //[super die];
    NSLog(@"GAME OVER.");
}

@end
