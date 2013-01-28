//
//  @public      	CGPoint position;  	Animation *animation; fmodSOundManager.m
//  iCopter
//
//  Created by disadb on 1/28/13.
//  Copyright (c) 2013 Patches. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "FmodSoundManager.h"



@implementation FmodSoundManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(FmodSoundManager);

#define checkFMODError(e) _checkFMODError(__FILE__, __LINE__, e)
void _checkFMODError(const char *sourceFile, int line, FMOD_RESULT errorCode);
// Convenience function for constraining parameter values
float constrainFloat(float value, float lowerLimit, float upperLimit);


- (id) init
{
	self= [super init];
    
    if (self != nil)
    {
        NSLog(@"SOUND INIT");
        sounds = [[NSMutableArray alloc] initWithObjects:nil];
        
        // Initialize the FMOD event system
        FMOD_EventSystem_Create(&eventSystem);
        checkFMODError(FMOD_EventSystem_Init(eventSystem, MAX_FMOD_AUDIO_CHANNELS, FMOD_INIT_NORMAL, NULL, FMOD_EVENT_INIT_NORMAL));
        // Load the FEV file
        NSString *fevPath = [[NSBundle mainBundle] pathForResource:@"iCopter" ofType:@"fev"];
        checkFMODError(FMOD_EventSystem_Load(eventSystem, [fevPath UTF8String], FMOD_EVENT_INIT_NORMAL, &project));
        
        //charge les groupes d'evenements sonores et les evenements eux-memes
        //general
        checkFMODError(FMOD_EventProject_GetGroup(project, "general", 1, &generalGrp));
        checkFMODError(FMOD_EventGroup_GetEvent(generalGrp, "game_music", FMOD_EVENT_DEFAULT, &generalEv));
        checkFMODError(FMOD_EventGroup_GetEvent(generalGrp, "pause_music", FMOD_EVENT_DEFAULT, &pauseEv));
        //checkFMODError(FMOD_EventGroup_GetEvent(generalGrp, "go_sound", FMOD_EVENT_DEFAULT, &pauseEv));
        checkFMODError(FMOD_EventGroup_GetEvent(generalGrp, "game_over", FMOD_EVENT_DEFAULT, &gameOverEv));
        checkFMODError(FMOD_EventProject_GetGroup(project, "helicopter", 1, &hGrp));
        checkFMODError(FMOD_EventGroup_GetEvent(hGrp, "helicopter", FMOD_EVENT_DEFAULT, &hEv));
        checkFMODError(FMOD_EventGroup_GetEvent(hGrp, "helicopter_altitude_alert", FMOD_EVENT_DEFAULT, &hAlertEv));
        checkFMODError(FMOD_EventGroup_GetEvent(hGrp, "helicopter_explosion", FMOD_EVENT_DEFAULT, &hExplosEv));
        checkFMODError(FMOD_EventGroup_GetEvent(hGrp, "helicopter_shoot", FMOD_EVENT_DEFAULT, &hShootEv));
        checkFMODError(FMOD_EventGroup_GetEvent(hGrp, "helicopter_missile_detonates", FMOD_EVENT_DEFAULT, &hMissileDetonEv));
        checkFMODError(FMOD_EventProject_GetGroup(project, "rocketLauncher", 1, &rlGrp));
        checkFMODError(FMOD_EventGroup_GetEvent(rlGrp, "rocketLauncher", FMOD_EVENT_DEFAULT, &rlEv));
        checkFMODError(FMOD_EventGroup_GetEvent(rlGrp, "rocketLauncher_explosion", FMOD_EVENT_DEFAULT, &rlExplosEv));
        checkFMODError(FMOD_EventGroup_GetEvent(rlGrp, "rocketLauncher_shoot", FMOD_EVENT_DEFAULT, &rlShootEv));
        checkFMODError(FMOD_EventProject_GetGroup(project, "ufo", 1, &uGrp));
        checkFMODError(FMOD_EventGroup_GetEvent(uGrp, "ufo", FMOD_EVENT_DEFAULT, &uEv));
        checkFMODError(FMOD_EventGroup_GetEvent(uGrp, "michou", FMOD_EVENT_DEFAULT, &michouEv));
        
        NSLog(@"INFO - Sound: Created successfully");
    }
    
    return self;
}

- (void) add:(int)sound
{
    [self add:sound immediate:true];
}

- (void) add:(int)sound immediate:(Boolean)immediate
{
    checkFMODError(FMOD_Event_Start([self getEvent:sound]));
    if (!immediate)[self pause:sound];
}

- (void) newInstance:(int)sound
{
    [self newInstance:sound immediate:true];
}

- (void) newInstance:(int)sound immediate:(Boolean)immediate
{
    FMOD_EVENT *event;
    FMOD_EVENTGROUP *group;
    const char* eventName;
    switch (sound)
    {
        case gameMusic:
            group= generalGrp;
            eventName= "game_music";
            break;
        case pauseMusic:
            group= generalGrp;
            eventName= "pause_music";
            break;
        case gameOverSound:
            group= generalGrp;
            eventName= "game_over";
            break;
        case goSound:
            group= generalGrp;
            eventName= "go_sound";
            break;
        case helicopterSound:
            group= hGrp;
            eventName= "helicopter";
            break;
        case helicopterShoot:
            group= hGrp;
            eventName= "helicopter_shoot";
            break;
        case helicopterExplosion:
            group= hGrp;
            eventName= "helicopter_explosion";
            break;
        case helicopterAltitudeAlert:
            group= hGrp;
            eventName= "helicopter_altitude_alert";
            break;
        case helicopterMissileDetonates:
            group= hGrp;
            eventName= "helicopter_missile_detonates";
            break;
        case rocketLauncherSound:
            group= rlGrp;
            eventName= "rocketLauncher";
            break;
        case rocketLauncherExplosion:
            group= rlGrp;
            eventName= "rocketLauncher_explosion";
            break;
        case rocketLauncherShoot:
            group= rlGrp;
            eventName= "rocketLauncher_shoot";
            break;
        case ufo:
            group= uGrp;
            eventName= "ufo";
            break;
        case michou:
            eventName= "michou";
            group= uGrp;
            break;
        default:
            group= NULL;
            eventName= NULL;
            break;
    }
    if (group && eventName)
    {
        checkFMODError(FMOD_EventGroup_GetEvent(group, eventName, FMOD_EVENT_DEFAULT, &event));
        checkFMODError(FMOD_Event_Start(event));
        if (!immediate)[self pause:sound];
    }
}



- (FMOD_EVENT *) getEvent:(int)sound
{
    FMOD_EVENT *event;
    
    switch (sound)
    {
        case gameMusic:
            event= generalEv;
            break;
        case pauseMusic:
            event= pauseEv;
            break;
        case gameOverSound:
            event= gameOverEv;
            break;
        case goSound:
            event= goEv;
            break;
        case helicopterSound:
            event= hEv;
            break;
        case helicopterShoot:
            event= hShootEv;
            break;
        case helicopterExplosion:
            event= hExplosEv;
            break;
        case helicopterAltitudeAlert:
            event= hAlertEv;
            break;
        case helicopterMissileDetonates:
            event= hMissileDetonEv;
            break;
        case rocketLauncherSound:
            event= rlEv;
            break;
        case rocketLauncherExplosion:
            event= rlExplosEv;
            break;
        case rocketLauncherShoot:
            event= rlShootEv;
            break;
        case ufo:
            event= uEv;
            break;
        case michou:
            event= michouEv;
            break;
        default:
            event= NULL;
            break;
    }
    return event;
}

- (void) update
{
    checkFMODError(FMOD_EventSystem_Update(eventSystem));
}

- (void) pause:(int)sound
{
    checkFMODError(FMOD_Event_SetPaused([self getEvent:sound],1));
}

- (void) play:(int)sound
{
    checkFMODError(FMOD_Event_SetPaused([self getEvent:sound],0));
}

- (void) stop:(int)sound immediate:(Boolean)immediate
{
    checkFMODError(FMOD_Event_Stop([self getEvent:sound],immediate));
}

- (Boolean) isPaused:(int)sound
{
    FMOD_BOOL *paused;
    checkFMODError(FMOD_Event_GetPaused([self getEvent:sound], paused));
    return paused?true:false;
}

- (void) setParameter:(int)sound parameter:param
{
}

- (void) initMusicParams
{
    //parametres pour la musique dynamique
    float minTime, maxTime, minRocketLauncher, maxRocketLauncher,minUfo,maxUfo;
    // get the value of parameter of the event
    checkFMODError(FMOD_Event_GetParameter(generalEv, "time", &timeParam));
    checkFMODError(FMOD_Event_GetParameter(generalEv, "rocketLauncher_count", &nbRocketLauncherParam));
    checkFMODError(FMOD_Event_GetParameter(generalEv, "ufo_count", &nbUfoParam));
    // get the required range of the parameter and constrain the value
    checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
    checkFMODError(FMOD_EventParameter_GetRange(nbRocketLauncherParam, &minRocketLauncher, &maxRocketLauncher));
    checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
    
    // set the new value
    checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainFloat(0, minTime, maxTime)));
    checkFMODError(FMOD_EventParameter_SetValue(nbRocketLauncherParam, constrainFloat(0, minRocketLauncher, maxRocketLauncher)));
    checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainFloat(0, minUfo, maxUfo)));
}
- (void) updateMusicParams:(float)timeEllapsed rocketLaunchersCount:(int)rocketLaunchersCount ufoCount:(int)ufoCount
{
    float minTime, maxTime, minRocketLauncher, maxRocketLauncher,minUfo,maxUfo;
    // get the value of parameter of the event
    checkFMODError(FMOD_Event_GetParameter(generalEv, "time", &timeParam));
    checkFMODError(FMOD_Event_GetParameter(generalEv, "rocketLauncher_count", &nbRocketLauncherParam));
    checkFMODError(FMOD_Event_GetParameter(generalEv, "ufo_count", &nbUfoParam));
    // get the required range of the parameter and constrain the value
    checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
    checkFMODError(FMOD_EventParameter_GetRange(nbRocketLauncherParam, &minRocketLauncher, &maxRocketLauncher));
    checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
    // set the new value
    checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainFloat(timeEllapsed/100, minTime, maxTime)));
    checkFMODError(FMOD_EventParameter_SetValue(nbRocketLauncherParam, constrainFloat(rocketLaunchersCount, minRocketLauncher,
                                                                                      maxRocketLauncher)));
    checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainFloat(ufoCount, minUfo, maxUfo)));
}

- (void) release:(int)sound immediate:(Boolean)immediate
{
    checkFMODError(FMOD_Event_Release([self getEvent:sound],true,!immediate));
}

- (void) dealloc
{
    [super dealloc];
}

@end

void _checkFMODError(const char *sourceFile, int line, FMOD_RESULT errorCode)
{
	if (errorCode != FMOD_OK)
	{
		NSString *filename = [[NSString stringWithUTF8String:sourceFile] lastPathComponent];
		NSLog(@"%@:%d FMOD Error %d:%s", filename, line, errorCode, FMOD_ErrorString(errorCode));
	}
}

float constrainFloat(float value, float lowerLimit, float upperLimit)
{
	if (value < lowerLimit) value = lowerLimit;
	if (value > upperLimit) value = upperLimit;
	
	return value;
}
