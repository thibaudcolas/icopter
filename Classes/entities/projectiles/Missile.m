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
	self->xCoord= x+25;
	self->yCoord= y-25;

    [sharedFmodSoundManager newInstance:helicopterShoot];
    
    SpriteSheet *spriteSheet = [[SpriteSheet alloc] initWithImageNamed:@"missile.png" spriteSize:CGSizeMake(17,19) spacing:0 margin:0 imageFilter:GL_LINEAR];
    float animationDelay= .2;
    
    animation = [[Animation alloc] init];
    animation.type = kAnimationType_Once;
    animation.state = kAnimationState_Running;
    animation.bounceFrame = 4;
    Image* tmpImage;
    for(int i = 0; i < 4; i++) {
         tmpImage = [spriteSheet spriteImageAtCoords:CGPointMake(i, 0)];
         
         [animation addFrameWithImage:tmpImage delay:animationDelay];
        }
    
    [spriteSheet release];
    
    return self;
}


- (Boolean) move
{
	speed= speed-1 - chute*deltat;
	xCoord= xCoord + 2*0.2;
	yCoord= yCoord + speed*deltat;
        
    if (yCoord<70)
    {
        [self die];
        return false;
    }
    return true;
}

- (void) update:(float)delta
{
    [animation updateWithDelta:delta];
}


- (void) render
{
     [animation renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
}

- (void) die
{
    //[sharedFmodSoundManager stop:helicopterShoot immediate:true];
    //[sharedFmodSoundManager release:helicopterShoot immediate:true];
    [sharedFmodSoundManager newInstance:helicopterMissileDetonates];
    //[sharedFmodSoundManager stop:helicopterMissileDetonates immediate:false];
    //[sharedFmodSoundManager release:helicopterMissileDetonates immediate:false];

    [sharedExplosionManager add:bAnimation_missileDetonates position:CGPointMake(xCoord, yCoord + 5)];
}

@end
