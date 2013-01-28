//
//  Ufo.m
//  CH12_SLQTSOR
//
//  Created by Patch on 19/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Ufo.h"

@implementation Ufo

- (void)dealloc
{
	[super dealloc];
}

- (id) init
{
    // Initialize the ufo	
	self= [super init];	
	
    kindOfUFO= (arc4random()%2)+1;//random entre 1 et 2
    //kindOfUFO= kindOfUFO==2?(arc4random()%2)+1:1;//random entre 1 et 2
	width= 39;//largeur
    height= 33;//hauteur
    image= kindOfUFO==1?@"ufo-classic.png":@"flying-michou.png";
    //coordonées centre de l'objet
    xCoord= screenBounds.size.height; // screenBounds.size.height => largeur
	yCoord= (arc4random()%(int)((screenBounds.size.width/2)-(height/2)))+screenBounds.size.width/2;   //Variation de la hauteur ou screenBounds.width => Hauteur
	speed= (arc4random()%3)+2*0.30;
    direction= -1;
	hitBox= CGRectMake(xCoord,yCoord,width,height);
    imageDim= kindOfUFO==1?CGSizeMake(55.83, 31):CGSizeMake(44, 43);
    framesNum= kindOfUFO==1?12:16;
	numberMax= 4;
    sinModifier= 0;//cree une sinusoide
    sinModifierIncrease= true;
	timeApparition= ((arc4random()%9)+1)*0.1;//random entre 1 et 10
    
    SpriteSheet *spriteSheet= [[SpriteSheet alloc] initWithImageNamed:image spriteSize:imageDim spacing:0 margin:0 imageFilter:GL_LINEAR];

    float animationDelay = 0.1f;
    
    animation= [[Animation alloc] init];
    animation.type= kAnimationType_Repeating;
    animation.state= kAnimationState_Running;
    animation.bounceFrame= framesNum;
    Image *tmpImage;
    for(int i = 0; i < framesNum; i++)
    {
        tmpImage= [spriteSheet spriteImageAtCoords:CGPointMake(i, 0)];
        [animation addFrameWithImage:tmpImage delay:animationDelay];
    }
    
    [sharedFmodSoundManager add:ufo];

    [spriteSheet release];
	return self;
}

- (void) move//fait avancer l'UFO
{
	if (self->xCoord+self->width/2 < 0) //Quand l'ufo arrive au bout de l'ecran retour au début(nouvelle vitesse, nouvelle hauteur)
	{
        self->xCoord= screenBounds.size.height;
        self->yCoord= (arc4random()%(int)((screenBounds.size.width/2)-(self->height/2)))+screenBounds.size.width/2;    //Variation de la hauteur
        self->speed= (arc4random()%3)+2*0.30;
		self->xCoord -= speed;
	}	
    else
    {
        self->xCoord-= self->speed;
        sinModifierIncrease= (sinModifierIncrease && sinModifier<=20) || (!sinModifierIncrease && sinModifier<=-20);
        sinModifier+= sinModifierIncrease?1:-1;
        self->yCoord+= sinModifierIncrease?.2:-.2;    //Variation de la hauteur
    }
}


- (void) update:(float)delta
{
    [animation updateWithDelta:delta];
}


- (void) render//suppression de l'objet si explosion
{
    //Render the sprite of the UFO
    CGPoint ufoLocation= CGPointMake(round(self->xCoord), round(self->yCoord));
	hitBox = CGRectMake(self->xCoord,self->yCoord,width,height);

    [animation renderCenteredAtPoint:ufoLocation];
}


- (void) die//explosion de l'ufo (animation) et suppression de l'objet ufo
{
    [sharedFmodSoundManager stop:kindOfUFO==1?ufo:michou immediate:false];
    [sharedFmodSoundManager release:kindOfUFO==1?ufo:michou immediate:false];
    [sharedFmodSoundManager add:kindOfUFO==1?ufo:michou];

    [super die];

}
@end

