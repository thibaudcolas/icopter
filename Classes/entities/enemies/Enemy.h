//
//  Enemy.h
//  CH12_SLQTSOR
//
//  Created by Patch on 19/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileObject.h"

@interface Enemy : MobileObject
{
	int numberMax;		//Nombre max d'ennemis a l'ecran
	int timeApparition; //Frequence d'apparition d'ennemis		  
}


@end
