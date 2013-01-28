//
//  FmodSoundManager.h
//  iCopter
//
//  Created by disadb on 1/28/13.
//  Copyright (c) 2013 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fmod_event.h"
#import "fmod_errors.h"


#define MAX_FMOD_AUDIO_CHANNELS 10
// Convenience macro/function for logging FMOD errors

enum
{
    gameMusic=0,
    pauseMusic=1,
    goSound=2,
    gameOverSound=3,
    helicopterSound=4,
    helicopterShoot=5,
    helicopterAltitudeAlert=6,
    helicopterExplosion=7,
    helicopterMissileDetonates=8,
    rocketLauncherSound=9,
    rocketLauncherShoot=10,
    rocketLauncherExplosion=11,
    ufo=12,
    michou=13
};

@interface FmodSoundManager : NSObject
{
    NSMutableArray *sounds;
    
    //SoundManager *sharedSoundManager;
	FMOD_EVENTSYSTEM *eventSystem;
    FMOD_EVENTPARAMETER *nbUfoParam,*nbRocketLauncherParam,*timeParam;// parameter of the event_music_game
    
    FMOD_EVENTPROJECT *project;
    FMOD_EVENTGROUP *generalGrp;
    FMOD_EVENTGROUP *hGrp;
    FMOD_EVENTGROUP *rlGrp;
    FMOD_EVENTGROUP *uGrp;
    FMOD_EVENT *generalEv;
    FMOD_EVENT *pauseEv;
    FMOD_EVENT *gameOverEv;
    FMOD_EVENT *goEv;
    FMOD_EVENT *hEv;
    FMOD_EVENT *hShootEv;
    FMOD_EVENT *hExplosEv;
    FMOD_EVENT *hAlertEv;
    FMOD_EVENT *hMissileDetonEv;
    FMOD_EVENT *rlEv;
    FMOD_EVENT *rlExplosEv;
    FMOD_EVENT *rlShootEv;
    FMOD_EVENT *uEv;
    FMOD_EVENT *michouEv;
}

// Returns an instance of the FmodSoundManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (FmodSoundManager *) sharedFmodSoundManager;

- (id) init;
- (void) update;
- (void) add:(int)sound;
- (void) add:(int)sound immediate:(Boolean)immediate;
- (void) newInstance:(int)sound;
- (void) newInstance:(int)sound immediate:(Boolean)immediate;
- (FMOD_EVENT *) getEvent:(int)sound;
- (void) pause:(int)sound;
- (void) play:(int)sound;
- (void) stop:(int)sound immediate:(Boolean)immediate;
- (Boolean) isPaused:(int)sound;
- (void) initMusicParams;
- (void) updateMusicParams:(float)timeEllapsed rocketLaunchersCount:(int)rocketLaunchersCount ufoCount:(int)ufoCount;
- (void) release:(int)sound immediate:(Boolean)immediate;
- (void) dealloc;

@end
