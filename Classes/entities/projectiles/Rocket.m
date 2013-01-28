//
//  Rocket.m
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Rocket.h"

@implementation Rocket

- (id) init:(float)x yCoord:(float)y targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta
{
	self = [super init];
	speed= 1.5;
	delta= aDelta;
	xCoord= x;
	yCoord= y;
	directionX= targetX;
	directionY= targetY;
    launcherX= x;
    launcherY= y;
    direction= launcherX>targetX?-1:1;

    SpriteSheet *spriteSheet= [[SpriteSheet alloc] initWithImageNamed:@"rocket.png" spriteSize:CGSizeMake(40, 40) spacing:0
                 margin:self->direction==1?40:0 imageFilter:GL_LINEAR];
    float animationDelay= .1;
    
    animation= [[Animation alloc] init];
    animation.state= kAnimationState_Stopped;
    animation.type = kAnimationType_Once;
    
    float opposed= targetY-self->launcherY;
    float adjacent= targetX-self->launcherX;
    float angle= atan(opposed/adjacent)*100;
    //angle de 0 a 90 deg & 10 frames
    int frameNum= self->direction==1?10-round(abs(angle)*10/90):round(abs(angle)*10/90);
    animation.bounceFrame= frameNum;
    Image *tmpImage= [spriteSheet spriteImageAtCoords:CGPointMake(frameNum, self->direction==1?0:1)];
    [animation addFrameWithImage:tmpImage delay:animationDelay];

    [sharedFmodSoundManager newInstance:rocketLauncherShoot];
    [spriteSheet release];
	return self;
}


- (Boolean) move
{
	float coeffDir= (directionY-launcherY)/(directionX-launcherX);
    //float ordOrigin= launcherY-coeffDir*launcherX;
    
    xCoord+= directionX>=launcherX?(delta+speed):-(delta+speed);
    yCoord+= directionX>=launcherX?coeffDir*(delta+speed):-coeffDir*(delta+speed);//+ordOrigin;

    return !(self->xCoord<0 || self->xCoord>screenBounds.size.height || self->yCoord>screenBounds.size.width);
}

- (void) update:(float)aDelta
{
    //[animation updateWithDelta:aDelta];//pas necessaire car toujours la meme trajectoire
}


- (void) render//suppression de l'objet si explosion ou sortie d'ecran
{
	[animation renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
}

- (void) die
{
    [sharedFmodSoundManager stop:rocketLauncherShoot immediate:true];
    [sharedFmodSoundManager release:rocketLauncherShoot immediate:true];
    [super die];
    
}
@end
