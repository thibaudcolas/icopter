//
//  RocketLauncher.m
//  projet
//
//  Created by disadb on 10/12/12.
//


#import "RocketLauncher.h"

@implementation RocketLauncher


- (id) init
{
	self= [super init];
	
    self->kindOfRocketLauncher= (arc4random()%2)+1;//random entre 1 et 2
    self->shootTimeout= 5;
    self->shootTimer= self->shootTimeout;
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
    self->rockets= [[NSMutableArray alloc] initWithObjects:nil];
    self->readyToShoot= false;
    
    //=================== son ====================//
    FMOD_EventProject_GetGroup(project, "rocketLauncher", 1, &rocketLauncherGroup);
    // create an instance of the FMOD event
    FMOD_EventGroup_GetEvent(rocketLauncherGroup, "rocketLauncher", FMOD_EVENT_DEFAULT, &rocketLauncherEvent);
    // trigger the event
    FMOD_Event_Start(rocketLauncherEvent);
    //============================================//
    
    
    //============== animations ==================//
    SpriteSheet *spriteSheet= [[SpriteSheet alloc] initWithImageNamed:@"rocket-launcher-base.png" spriteSize:CGSizeMake(60, 21) spacing:0
                                                  margin:self->direction==1?21:0 imageFilter:GL_LINEAR];
    float animationDelay = 0.1f;
    animation = [[Animation alloc] init];
    animation.type = kAnimationType_Repeating;
    animation.state = kAnimationState_Running;
    animation.bounceFrame = 8;
    Image* tmpImage;
    for(int i = 0; i < 8; i++)
    {
        tmpImage = [spriteSheet spriteImageAtCoords:CGPointMake(i, self->direction==1?0:1)];
        [animation addFrameWithImage:tmpImage delay:animationDelay];
    }
    
    SpriteSheet *spriteSheetC= [[SpriteSheet alloc] initWithImageNamed:@"rocket-launcher-canon.png" spriteSize:CGSizeMake(53, 51)
                               spacing:0 margin:self->direction==1?51:0 imageFilter:GL_LINEAR];
    float animationCDelay= .05f;
    animationC= [[Animation alloc] init];
    animationC.type= kAnimationType_PingPong;
    animationC.state= kAnimationState_Stopped;
    animationC.bounceFrame= 16;
    Image *tmpImageC;
    for(int i = 0; i < 16; i++)
    {
        tmpImageC= [spriteSheetC spriteImageAtCoords:CGPointMake(i, self->direction==1?0:1)];
        [animationC addFrameWithImage:tmpImageC delay:animationCDelay];
    }
    //============================================//
    [spriteSheet release];
    return self;
}


- (void) move//fait avancer le RocketLauncher dans sa direction predefinie
{
	//une fois sorti vivant de l'ecran, le lance rocket revient de l'autre cote
	if (self->xCoord+self->width/2 < 0 && self->direction<0) self->xCoord= screenBounds.size.height+self->width/2;
	if (self->xCoord-self->width/2 > screenBounds.size.height && self->direction>0) self->xCoord= 0-self->width/2;
    else
    {
        self->xCoord+= self->direction>0?speed:-speed;
        if (   self->xCoord+self->width/2 >= [helicopter getXCoord]-helicopter->width/2
            && self->xCoord-self->width/2 <= [helicopter getXCoord]+helicopter->width/2
            && self->yCoord+self->height/2 >= [helicopter getYCoord]-helicopter->height/2
            && self->yCoord-self->height/2 <= [helicopter getYCoord]+helicopter->height/2)
        {
            NSLog(@"HELICOPTER CRASHED IN A ROCKET LAUNCHER!");
            [self die];
            [helicopter die];
        }
    }
}

- (void) update:(float)delta
{
    [animation updateWithDelta:delta];
    [animationC updateWithDelta:delta];
    if (animationC.direction<0 && animationC.currentFrame<=1) animationC.state= kAnimationState_Stopped;
}

/*
 viser l'helicoptere (acquerir la position x & y et animation du canon)
 1- calculer la trajectoire du missile pour orienter le canon du lance-rocket
 2- orienter le canon
 3- mettre en pause l'animation quand l'orientation du canon est bonne
 4- tirer
 5- faire reprendre l'animation pour remettre le canon a sa position initiale
 */
- (void) aim:(float)targetX targetY:(float)targetY aDelta:(float)aDelta;
{
    float opposed= targetY-self->yCoord;
    float adjacent= targetX-self->xCoord;
    float angle= atan(opposed/adjacent)*100;
    if (abs(angle)<90 && ((self->direction==1 && angle>0) || (self->direction==-1 && angle<0)))
    {
        //angle de 0 a 90 deg & 16 frames
        int frameNum= round(abs(angle)*16/90);
        if (animationC.currentFrame < frameNum) animationC.state= kAnimationState_Running;
        else
        {
            animationC.state= kAnimationState_Stopped;
            self->readyToShoot= true;
        }
    }
}

/*
 tirer sur l'helico (targetX & targetY == coordonnees helico)
 */
- (void) shoot:(float)targetX targetY:(float)targetY aDelta:(float)aDelta
{
    NSLog(@"shoot tank");
    //ajout d'un nouvel rockets dans le tableau
    [self->rockets addObject:[[Rocket alloc] init:(float)self->xCoord yCoord:(float)self->yCoord targetX:(float)targetX targetY:(float)targetY aDelta:(float)aDelta]];
    self->shootTimer= self->shootTimeout;//reinitialise le timer au bout duquel le RocketLauncher tire
    self->readyToShoot= false;
    if (animationC.direction>0) animationC.direction= -1;
    animationC.state= kAnimationState_Running;
}


- (void) render//rendu
{
    [animation renderCenteredAtPoint: CGPointMake(round(self->xCoord), round(self->yCoord))];
    [animationC renderCenteredAtPoint: CGPointMake(round(self->xCoord)+(self->direction>0?-4:4), round(self->yCoord)+22)];
}

-(void) die
{
    killedRocketLaunchers++;
    [rocketLaunchers removeObject: self];
    //================== son =====================//
    FMOD_Event_Stop(rocketLauncherEvent, false);
    FMOD_Event_Release(rocketLauncherEvent, false,1);

    FMOD_EVENT *explosionEvent;
    FMOD_EventGroup_GetEvent(rocketLauncherGroup, "rocketLauncher_explosion", FMOD_EVENT_DEFAULT, &explosionEvent);
    FMOD_Event_Start(explosionEvent);
    FMOD_Event_Release(explosionEvent, false,1);
    //============================================//
    
    [sharedExplosionManager add:bAnimation_rocketLauncherDestroyed position:CGPointMake(xCoord, yCoord)];
    [animationC release];
    [super die];
    NSLog(@"ROCKET LAUNCHER DESTROYED!");
}

@end
