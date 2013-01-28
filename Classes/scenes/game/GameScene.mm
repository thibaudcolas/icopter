#import "GameScene.h"

// Convenience macro/function for logging FMOD errors
#define checkFMODError(e) _checkFMODError(__FILE__, __LINE__, e)
void _checkFMODError(const char *sourceFile, int line, FMOD_RESULT errorCode);

// Convenience function for constraining parameter values
float constrainFloat(float value, float lowerLimit, float upperLimit);

@implementation GameScene

- (void)dealloc
{
	[super dealloc];
}

- (id) init
{
	self= [super init];
	
	if (self != nil)
    {
		// Grab an instance of the render manager
		sharedGameController= [GameController sharedGameController];
		sharedImageRenderManager= [ImageRenderManager sharedImageRenderManager];
        
        //=================== SOUND ==================//
        sharedSoundManager= [SoundManager sharedSoundManager];
        fmodEventsForTouches = [[NSMutableDictionary alloc] init];
		
		// Initialize the FMOD event system
		checkFMODError(FMOD_EventSystem_Create(&eventSystem));
		checkFMODError(FMOD_EventSystem_Init(eventSystem, MAX_FMOD_AUDIO_CHANNELS, FMOD_INIT_NORMAL, NULL, FMOD_EVENT_INIT_NORMAL));
		// Load the FEV file
		NSString *fevPath = [[NSBundle mainBundle] pathForResource:@"iCopter" ofType:@"fev"];
		checkFMODError(FMOD_EventSystem_Load(eventSystem, [fevPath UTF8String], FMOD_EVENT_INIT_NORMAL, &project));
        
        game= NULL;
        FMOD_EventCategory_GetCategory(game, "master", &game);
		checkFMODError(FMOD_EventProject_GetGroup(project, "general", 1, &generalGroup));
    
        generalEvent= NULL;
        // create an instance of the FMOD event
		checkFMODError(FMOD_EventGroup_GetEvent(generalGroup, "game_music", FMOD_EVENT_DEFAULT, &generalEvent));
		
        float minTime, maxTime, minRocketLauncher, maxRocketLauncher,minUfo,maxUfo;
        // get the value of parameter of the event
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "time", &timeParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "rocketLauncher_count", &nbRocketLauncherParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "ufo_count", &nbUfoParam));
        // get the required range of the parameter and constrain the value
		checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
		checkFMODError(FMOD_EventParameter_GetRange(nbRocketLauncherParam, &minRocketLauncher, &maxRocketLauncher));
		checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
        float constrainedValueTime = constrainFloat(0, minTime, maxTime);
        float constrainedValueRocketLauncher = constrainFloat(0, minRocketLauncher, maxRocketLauncher);
        float constrainedValueUfo = constrainFloat(0, minUfo, maxUfo);
        // set the new value
        checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainedValueTime));
        checkFMODError(FMOD_EventParameter_SetValue(nbRocketLauncherParam, constrainedValueRocketLauncher));
        checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainedValueUfo));
        
        // trigger the event
		checkFMODError(FMOD_Event_Start(generalEvent));
        checkFMODError(FMOD_EventGroup_GetEvent(generalGroup, "pause_music", FMOD_EVENT_DEFAULT, &pauseEvent));
        checkFMODError(FMOD_Event_Start(pauseEvent));FMOD_Event_SetPaused(pauseEvent, 1);
        //============================================//
 		
        timeEllapsed= 0;
        
        //================ BACKGROUND ================//
        background = [[Background alloc] init:1];
        
        // Get the master sprite sheet we are going to get all of our other graphical items from.  Having a single texture with all
        // the graphics will help reduce the number of textures bound per frame and therefor performance
        PackedSpriteSheet *masterSpriteSheet = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"background-atlas.png" controlFile:@"background-coordinates" imageFilter:GL_LINEAR];
        
        [background add:120 image:[[Image alloc] initWithImageNamed:@"background-sky.jpg" filter:GL_LINEAR] inFront:false];
        [background add:120 image:[[masterSpriteSheet imageForKey:@"background-towers"] retain] inFront:false];
        [background add:110 image:[[masterSpriteSheet imageForKey:@"background-ruins"] retain] inFront:false];
        [background add:82 image:[[masterSpriteSheet imageForKey:@"background-back"] retain] inFront:false];
        [background add:32 image:[[masterSpriteSheet imageForKey:@"background-road"] retain] inFront:false];
        [background add:0 image:[[Image alloc] initWithImageNamed:@"background-ground.png" filter:GL_LINEAR] inFront:true];
        
        [masterSpriteSheet release];
		
        hud = [[GameHUD alloc] init];
        score = [[Score alloc] init];
        
        sharedExplosionManager = [ExplosionManager sharedExplosionManager];
        //============================================//
	

        //================== ROCKET LAUNCHERS ===================//
        maxNumRocketLauncher= 5;
        createRocketLauncherTimeout= 5;
        createRocketLauncherTimer= 0;
		
        rocketLaunchers= [[NSMutableArray alloc] initWithObjects:nil];
        [rocketLaunchers addObject:[[RocketLauncher alloc] init]];//ajout d'un nouveau rocketLauncher dans le tableau
        
        killedRocketLaunchers = 0;
        //============================================//
		
		//==================== UFO ===================//
        maxNumUfo= 2;
        createUfoTimeout= 5;
        createUfoTimer= 0;
        
        ufos= [[NSMutableArray alloc] initWithObjects:nil];
        [ufos addObject:[[Ufo alloc] init]];//ajout d'un nouvel ufo dans le tableau
        //============================================//
		
		joypadDistance= 0;
        joypadDirection= 0;
		//============================================//
		
		//================= HELICOPTER ===============//
		helicopter= [[Helicopter alloc] init];
		//============================================//        
        
        state= kSceneState_Running;
	}
	return self;
}





- (void)updateSceneWithDelta:(float)aDelta
{
    if (state== kSceneState_Paused)
    {
        FMOD_Event_SetPaused(generalEvent, 1);
        FMOD_Event_SetPaused(helicopterEvent, 1);
        FMOD_Event_SetPaused(rocketLauncherEvent, 1);
        FMOD_Event_SetPaused(ufoEvent, 1);
        FMOD_Event_SetPaused(gameOverEvent, 1);
        FMOD_Event_SetPaused(pauseEvent, 0);
        
        //FMOD_EventCategory_SetPaused(game, 1);
    }
    else
    {
        //FMOD_EventCategory_SetPaused(game, 0);
        FMOD_Event_SetPaused(generalEvent, 0);
        FMOD_Event_SetPaused(helicopterEvent, 0);
        FMOD_Event_SetPaused(rocketLauncherEvent, 0);
        FMOD_Event_SetPaused(ufoEvent, 0);
        FMOD_Event_SetPaused(gameOverEvent, 0);
        FMOD_Event_SetPaused(pauseEvent, 1);
        timeEllapsed+= aDelta;
        
        //==================== SOUND =================//
        float minTime, maxTime, minRocketLauncher, maxRocketLauncher,minUfo,maxUfo;
        // get the value of parameter of the event
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "time", &timeParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "rocketLauncher_count", &nbRocketLauncherParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "ufo_count", &nbUfoParam));
        // get the required range of the parameter and constrain the value
        checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
        checkFMODError(FMOD_EventParameter_GetRange(nbRocketLauncherParam, &minRocketLauncher, &maxRocketLauncher));
        checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
        float constrainedValueTime = constrainFloat(timeEllapsed/100, minTime, maxTime);
        float constrainedValueRocketLauncher = constrainFloat([rocketLaunchers count], minRocketLauncher, maxRocketLauncher);
        float constrainedValueUfo = constrainFloat([ufos count], minUfo, maxUfo);
        // set the new value
        checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainedValueTime));
        checkFMODError(FMOD_EventParameter_SetValue(nbRocketLauncherParam, constrainedValueRocketLauncher));
        checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainedValueUfo));
    
        //============================================//
        bool touched= false;
        //============= ROCKET LAUNCHERS =============//
        //Toutes les createRocketLauncherTimeout secondes on cree un nouveau rocketLauncher si le maxNumRocketLauncher n'est pas atteint
        if (createRocketLauncherTimer>= createRocketLauncherTimeout) if ([rocketLaunchers count]< maxNumRocketLauncher)
        {
            [rocketLaunchers addObject:[[RocketLauncher alloc] init]];//ajout d'un nouveau rocketLauncher dans le tableau
            createRocketLauncherTimer= 0;
        }
        createRocketLauncherTimer+= aDelta;
        
        
        if ([rocketLaunchers count]) for(int i=0;i<[rocketLaunchers count];i++)
            //iteration sur un nombre plutot que "for(RocketLauncher *rocketLauncher in rocketLaunchers)" pour eviter erreur liee a la suppression du rocketLauncher tué :
            //"NSmutableArray was mutated while being iterated"
        {
            RocketLauncher *rocketLauncher= [rocketLaunchers objectAtIndex:i];        
            
            for(Missile *missile in helicopter->missiles)
            {
                if (   [missile getXCoord]>= [rocketLauncher getXCoord]-rocketLauncher->width/2
                    && [missile getXCoord]<= [rocketLauncher getXCoord]+rocketLauncher->width/2
                    //&& [missile getYCoord]>= [rocketLauncher getYCoord]-rocketLauncher->height/2 //tjs le cas avec la gravité (le missile arrive par le haut)
                    && [missile getYCoord]<= [rocketLauncher getYCoord]+rocketLauncher->height/2)
                {
                    [rocketLaunchers removeObject: rocketLauncher];
                    [rocketLauncher die];
                    [helicopter->missiles removeObject: missile];
                    [missile die];
                    
                    killedRocketLaunchers++;
                    touched= true;
                    i--;
                    break;
                }
            }
            if (!touched && [rocketLaunchers count])
            {
                [rocketLauncher update:aDelta];
                [rocketLauncher move];
                if (rocketLauncher->shootTimer<= 0)
                {
                    if (rocketLauncher->readyToShoot)
                        [rocketLauncher shoot:(float)helicopter.getXCoord targetY:(float)helicopter.getYCoord aDelta:(float)aDelta];
                    else [rocketLauncher aim:(float)helicopter.getXCoord targetY:(float)helicopter.getYCoord aDelta:(float)aDelta];
                }
                rocketLauncher->shootTimer-= aDelta;
                //================== Rocket ===================//
                for(int j=0;j<[rocketLauncher->rockets count];j++)
                    //iteration sur un nombre plutot que "for(Rocket *rocket in rocketLauncher->rockets)" pour eviter erreur liee a la suppression de l'rockets :
                    //"NSmutableArray was mutated while being iterated"
                {
                    Rocket *rocket= [rocketLauncher->rockets objectAtIndex:j];
                    if (![rocket move])
                    {
                        [rocketLauncher->rockets removeObject: rocket];
                        [rocket die];
                    }
                    else [rocket update:aDelta];
                }
                //==========================================//
            }
            else break;
        }
        //===========================================//
        
        
        //================= Ufos ==================//
        //Toutes les createUfoTimeout secondes on cree un nouveau tank si le maxNumUfo n'est pas atteint
        if (createUfoTimer>= createUfoTimeout) if ([ufos count]< maxNumUfo)
        {
            [ufos addObject:[[Ufo alloc] init]];//ajout d'un nouvel Ufo dans le tableau
            createUfoTimer= 0;
        }
        createUfoTimer+= aDelta;
        bool collision;
        
        for(Ufo *ufo in ufos)
        {
            collision= false;
            if (   [ufo getXCoord]-ufo->width/2 >= [helicopter getXCoord]-helicopter->width/2
                && [ufo getXCoord]+ufo->width/2 <= [helicopter getXCoord]+helicopter->width/2
                && [ufo getYCoord]-ufo->height/2 >= [helicopter getYCoord]-helicopter->height/2
                && [ufo getYCoord]+ufo->height/2 <= [helicopter getYCoord]+helicopter->height/2)
            {
                [ufos removeObject: ufo];
                [ufo die];
                NSLog(@"CRASH UFO!");
                [helicopter die];
                collision= true;
                break;
            }
            if (!collision) [ufo move];
            
            [ufo update:aDelta];
        }
        //============================================//
        
        //================= HELICOPTER ===============//
        collision= false;
        if ([rocketLaunchers count]) for(int i=0;i<[rocketLaunchers count];i++)
        {
            RocketLauncher *rocketLauncher= [rocketLaunchers objectAtIndex:i];
            
            for(int j=0;j<[rocketLauncher->rockets count];j++)
                //iteration sur un nombre plutot que "for(Rocket *rocket in rocketLauncher->rockets)" pour eviter erreur liee a la
                //suppression du rockets : "NSmutableArray was mutated while being iterated"
            {
                Rocket *rocket= [rocketLauncher->rockets objectAtIndex:j];
                if (   [rocket getXCoord] >= [helicopter getXCoord]-helicopter->width/2
                    && [rocket getXCoord] <= [helicopter getXCoord]+helicopter->width/2
                    && [rocket getYCoord] >= [helicopter getYCoord]-helicopter->height/2)
                {
                    [rocketLauncher->rockets removeObject: rocket];
                    [rocket die];
                    
                    NSLog(@"CRASH OBUS!");
                    [helicopter die];
                    collision= true;
                    
                    break;
                }
            }
        }
        if (!collision) [helicopter move:joypadDistance joypadDirection:(float)joypadDirection aDelta:(float)aDelta];
        
        
        for(int i=0;i<[helicopter->missiles count];i++)
        //iteration sur un nombre plutot que "for(Missile *missile in helicopter->missiles)" pour eviter erreur liee a la suppression du
        //missile : "NSmutableArray was mutated while being iterated"
        {
            Missile *missile= [helicopter->missiles objectAtIndex:i];
            if (![missile move])
            {
                [helicopter->missiles removeObject: missile];
                [missile die];
            }
        }
        
        [sharedExplosionManager update:aDelta];
        
        [background update:aDelta];
        
        [score update:aDelta kills:killedRocketLaunchers];
        [hud update:aDelta score:[score getValue] kill:touched];
        //============================================//
	}
}


- (void)renderScene
{
	glClear(GL_COLOR_BUFFER_BIT);
	
    [background renderRear];    
    
    //============================================//    
    
    //================== TANKS ===================//
    for(RocketLauncher *rocketLauncher in rocketLaunchers)
    {
        for (id rocket in rocketLauncher->rockets) [rocket render];
        [rocketLauncher render];
    }
    //============================================//
    
	//=================== UFO ====================//
    for(id ufo in ufos) [ufo render];
    //============================================//
    
    //================ HELICOPTER ================//
    for(id missile in helicopter->missiles) [missile render];
    [helicopter render];
    //============================================//
    
    [sharedExplosionManager render];
    
    [background renderFront];
    
    [hud render:state];
	
    // Render images to screen
	[sharedImageRenderManager renderImages];
}

#pragma mark -
#pragma mark Touch events

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	for (UITouch *touch in touches)
    {
        // Get the point where the player has touched the screen
        CGPoint originalTouchLocation = [touch locationInView:aView];
        
        // As we have the game in landscape mode we need to switch the touches 
        // x and y coordinates
        CGPoint touchLocation = [sharedGameController adjustTouchOrientationForTouch:originalTouchLocation];
		if (CGRectContainsPoint([hud getJoypadBounds], touchLocation) && !isJoypadTouchMoving)
        {
			isJoypadTouchMoving = YES;
			joypadTouchHash = [touch hash];
			continue;
		}
        
        if (CGRectContainsPoint([hud getShootButtonBounds], touchLocation)) {
            [helicopter shoot];
        }
		
        // Next check to see if the pause/play button has been pressed
        if (CGRectContainsPoint([hud getPauseButtonBounds], touchLocation))
        {
            if (state== kSceneState_Running)
            {
                state= kSceneState_Paused;
                [sharedSoundManager stopMusic];
            }
            else
            {
                state= kSceneState_Running;
                [sharedSoundManager resumeMusic];
            }
            
            // If the joypad was being tracked then reset it
            isJoypadTouchMoving = NO;
            joypadTouchHash = 0;
            break;
        }

		// Check if this touch is a double tap
		if (touch.tapCount == 2) {
			NSLog(@"Double Tap at X:%f Y:%f", touchLocation.x, touchLocation.y);
		}
	}
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	// as this method will be called regulary, it is a good place to do the periodic update of the FMOD event system.
	FMOD_EventSystem_Update(eventSystem);

    
    // Loop through all the touches
	for (UITouch *touch in touches)
    {
        if ([touch hash]== joypadTouchHash && isJoypadTouchMoving)
        {
			// Get the point where the player has touched the screen
			CGPoint originalTouchLocation= [touch locationInView:aView];
			
			// As we have the game in landscape mode we need to switch the touches 
			// x and y coordinates
			CGPoint touchLocation= [sharedGameController adjustTouchOrientationForTouch:originalTouchLocation];
			
            CGPoint joypadCenter = [hud getJoypadCenter];
			// Calculate the angle of the touch from the center of the joypad
			float dx= (float)joypadCenter.x - (float)touchLocation.x;
			float dy= (float)joypadCenter.y - (float)touchLocation.y;
			
			// Calculate the distance from the center of the joypad to the players touch.
			// Manhatten Distance
			joypadDistance= fabs(touchLocation.x - joypadCenter.x) + fabs(touchLocation.y - joypadCenter.y);
			
			// Calculate the new position of the helicopter based on the direction of the joypad and how far from the
			// center the joypad has been moved
			joypadDirection= atan2(dy, dx);
		}
    }
}


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	// Loop through the touches checking to see if the joypad touch has finished
	for (UITouch *touch in touches)
    {
        [previousTouchTimestamps removeObjectForKey:[NSNumber numberWithInteger:[touch hash]]];
		[fmodEventsForTouches removeObjectForKey:[NSNumber numberWithInteger:[touch hash]]];

		// If the hash for the joypad has reported that its ended, then set the
		// state as necessary
		if ([touch hash]== joypadTouchHash)
        {
			isJoypadTouchMoving= NO;
			joypadTouchHash= 0;
			joypadDirection= 0;
			joypadDistance= 0;
			return;
		}
	}
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *cancelledTouch in touches)
	{
		[previousTouchTimestamps removeObjectForKey:[NSNumber numberWithInteger:[cancelledTouch hash]]];
		[fmodEventsForTouches removeObjectForKey:[NSNumber numberWithInteger:[cancelledTouch hash]]];
	}
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
	if (value < lowerLimit)
	{
		value = lowerLimit;
	}
	
	if (value > upperLimit)
	{
		value = upperLimit;
	}
	
	return value;
}


