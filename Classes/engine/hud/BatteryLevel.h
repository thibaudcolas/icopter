//
//  BatteryLevel.h
//  iCopter
//
//  Created by Thibaud Colas on 29/01/13.
//  Copyright (c) 2013 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface BatteryLevel : NSObject {
    CGPoint position;
    Animation *animation;
    int nbBatteriesLeft;
    float blinkingDuration;
}

- (id) init:(Animation*)anim;

- (void) update:(float)delta left:(int)batteriesLeft;

- (void) render;

@end
