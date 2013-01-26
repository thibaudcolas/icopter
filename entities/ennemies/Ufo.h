//
//  Ufo.h
//  CH12_SLQTSOR
//
//  Created by Patch on 19/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ennemies.h"

FMOD_EVENT *ufoEvent;

@interface Ufo : Ennemies
{
    int kindOfUFO;//les differents types d'UFOs
    NSString *image;
    CGSize imageDim;
    int framesNum;
    int sinModifier;
    Boolean sinModifierIncrease;
    
	FMOD_EVENTGROUP *ufoGroup;
}

- (void) update:(float)delta;
- (void) die;
@end
