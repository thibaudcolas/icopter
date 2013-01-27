//
//  Helicopter.h
//  iCopter
//
//  Created by Patch on 09/11/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileObject.h"
#import "Missile.h"

@class GameScene;
@class Missile;

FMOD_EVENTGROUP *helicopterGroup;//global var
FMOD_EVENT *helicopterEvent;
FMOD_EVENT *gameOverEvent;

@interface Helicopter : MobileObject
{
    @public
    //============== Classe MISSILE ==============//
    NSMutableArray *missiles;
	CGSize missileRectangleSize;// Height and Width of the tank touch rectangle
    //============================================//
}

- (void) move:(float)joypadDistance joypadDirection:(float)joypadDirection aDelta:(float)aDelta;
- (void) shoot;
- (void) die;

@end