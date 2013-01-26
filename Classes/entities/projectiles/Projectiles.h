//
//  Projectiles.h
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "MobileObject.h"

@interface Projectiles : MobileObject
{
	//Possede déjà un skin par héritage 
	//Ajout du second pour explosion
	
	Image *skinExplosion; //Image de base
	SpriteSheet *spriteSheetExplosion; //Frame d'animation de l'entite
	Animation *animationExplosion; //Animation
}
-(void)move;
-(void)die;
@end
