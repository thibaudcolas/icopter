//
//  Obus.m
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Obus.h"

extern FMOD_EVENTPROJECT *project;
extern FMOD_EVENTGROUP *tankGroup;

@implementation Obus

- (id) init:(float)x yCoord:(float)y targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta
{
	self = [super init];
	speed= 1;
	delta= aDelta;
	xCoord= x;
	yCoord= y;
	directionX= targetX;
	directionY= targetY;
    launcherX= x;
    launcherY= y;
    direction= launcherX>targetX?-1:1;
    
    //NSString *path= @"missile.png";
	//skin= [[Image alloc] initWithImageNamed:path filter:GL_LINEAR];
    //sprite:432x63,12pics,2rows
    spriteSheet = [[SpriteSheet alloc] initWithImageNamed:@"rocket.png" spriteSize:CGSizeMake(36, 31) spacing:0 margin:self->direction==1?31:0 imageFilter:GL_LINEAR];
    float animationDelay= .4f;
    
    animation = [[Animation alloc] init];
    animation.type = kAnimationType_Repeating;
    animation.state = kAnimationState_Running;
    animation.bounceFrame = 12;
    Image* tmpImage;
    for(int i = 0; i < 12; i++) {
        tmpImage = [spriteSheet spriteImageAtCoords:CGPointMake(i, self->direction==1?0:1)];
        
        [animation addFrameWithImage:tmpImage delay:animationDelay];
    }

    // create an instance of the FMOD event
    FMOD_EventGroup_GetEvent(tankGroup, "tank_shoot_sound", FMOD_EVENT_DEFAULT, &obusEvent);
    // trigger the event
    FMOD_Event_Start(obusEvent);
    
	return self;
}


- (Boolean) move
{
	//speed= speed;
	float coeffDir= (directionY-launcherY)/(directionX-launcherX);
    //float ordOrigin= launcherY-coeffDir*launcherX;
    
    xCoord+= directionX>=launcherX?(delta+speed):-(delta+speed);
    yCoord+= directionX>=launcherX?coeffDir*(delta+speed):-coeffDir*(delta+speed);//+ordOrigin;

    return !(self->xCoord<0 || self->xCoord>screenBounds.size.height || self->yCoord>screenBounds.size.width);
}

- (void) update:(float)aDelta
{
    [animation updateWithDelta:aDelta];
}


- (void) render//suppression de l'objet si explosion ou sortie d'ecran
{
    //Render the sprite of the ROCKET
	//CGPoint obusLocation= CGPointMake(round(self->xCoord), round(self->yCoord));
	//hitBox = CGRectMake(self->xCoord,self->yCoord,width,height);
	
	//[skin renderCenteredAtPoint:obusLocation];
	[animation renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
}

- (void) die
{
    //FMOD_Event_Stop(obusEvent, false);
    [self dealloc];
}
@end
