//
//  Missile.h
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h"

@class Helicopter;

@interface Missile : Projectile
{
	float deltat;
	float chute;//9.81
}

- (id) init:(float)xCoord yCoord:(float)yCoord;
- (Boolean) move;
- (void) die;
@end
