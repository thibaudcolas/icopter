//
//  Tank.m
//  projet
//
//  Created by disadb on 10/12/12.
//

#import "Tank.h"

extern FMOD_EVENTPROJECT *project;

@implementation Tank


- (id) init
{
	self= [super init];
	
    self->kindOfTank= (arc4random()%2)+1;//random entre 1 et 2
    self->shootTimeout= 3;
    self->shootTimer= 0;
    self->direction= (arc4random()%2)*2-1;//random entre 1 et -1
    self->speed= (self->direction<0)?((arc4random()%1)+2)*0.5:((arc4random()%5)+2)*0.12;//random entre 1 et 10
    self->width= 75;
    self->height= 24;
    self->xCoord= (self->direction>0)?0-self->width/2:480+self->width/2;
    self->yCoord= (self->direction>0)?75:100;
    self->hitBox= CGRectMake(self->direction>0?self->xCoord-self->width:self->xCoord+self->width,
                             self->direction>0?self->yCoord-self->height:self->xCoord+self->width,
                             self->width,
                             self->height);
            
    //NSString *path= [@"" stringByAppendingFormat:@"tank%d-%@.png",self->kindOfTank,self->direction==1?@"r":@"l"];
    //self->skin= [[Image alloc] initWithImageNamed:path filter:GL_LINEAR];

    self->obus= [[NSMutableArray alloc] initWithObjects:nil];
   
    FMOD_EventProject_GetGroup(project, "tank", 1, &tankGroup);
    // create an instance of the FMOD event
    FMOD_EventGroup_GetEvent(tankGroup, "tank_sound", FMOD_EVENT_DEFAULT, &tankEvent);
    // trigger the event
    FMOD_Event_Start(tankEvent);
    
    
    spriteSheet = [[SpriteSheet alloc] initWithImageNamed:@"rocket-launcher.png" spriteSize:CGSizeMake(60, 58) spacing:0 margin:self->direction==1?58:0 imageFilter:GL_LINEAR];
    float animationDelay = 0.1f;
    
    animation = [[Animation alloc] init];
    animation.type = kAnimationType_Repeating;
    animation.state = kAnimationState_Running;
    animation.bounceFrame = 8;
    Image* tmpImage;
    for(int i = 0; i < 8; i++) {
        tmpImage = [spriteSheet spriteImageAtCoords:CGPointMake(i, self->direction==1?0:1)];
        
        [animation addFrameWithImage:tmpImage delay:animationDelay];
    }

    return self;
}


- (void) move//fait avancer le tank dans sa direction predefinie
{
	// Stop the player moving beyond the bounds of the screen
	if (self->xCoord+self->width/2 < 0 && self->direction<0) self->xCoord= screenBounds.size.height+self->width/2;
	if (self->xCoord-self->width/2 > screenBounds.size.height && self->direction>0) self->xCoord= 0-self->width/2;
    else
    {
        if (self->direction>0) self->xCoord+= speed;
        if (self->direction<0) self->xCoord-= speed;
    }
}

- (void) update:(float)delta
{
    [animation updateWithDelta:delta];
}

- (void) aim:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;//viser l'helicoptere (acquerir la position x & y et animation du canon)
{
    [self shoot:(float)targetX targetY:(float)targetY aDelta:(float)aDelta];
}


- (void) shoot:(float)targetX targetY:(float)targetY aDelta:(float)aDelta//tirer sur l'helico (targetX & targetY == coordonnees helico)
{
    //ajout d'un nouvel obus dans le tableau
    [self->obus addObject:[[Obus alloc] init:(float)self->xCoord yCoord:(float)self->yCoord targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta]];
}


- (void) render//rendu
{
	//Render the sprite of the tank
    //CGPoint tankLocation= CGPointMake(round(self->xCoord), round(self->yCoord));
	//[skin renderCenteredAtPoint:tankLocation];
	[animation renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
}


-(void) die
{
    FMOD_Event_Stop(tankEvent, false);
    FMOD_EVENT *explosionEvent;
    [sharedExplosionManager add:bAnimation_tankDestroyed position:CGPointMake(xCoord, yCoord)];
    FMOD_EventGroup_GetEvent(tankGroup, "explosion_sound", FMOD_EVENT_DEFAULT, &explosionEvent);
    FMOD_Event_Start(explosionEvent);
    [self dealloc];
}

@end
