#import "GameScene.h"

// Convenience macro/function for logging FMOD errors
#define checkFMODError(e) _checkFMODError(__FILE__, __LINE__, e)
void _checkFMODError(const char *sourceFile, int line, FMOD_RESULT errorCode);

// Convenience function for constraining parameter values
float constrainFloat(float value, float lowerLimit, float upperLimit);
FMOD_EVENTPROJECT *project;
FMOD_EVENTGROUP *generalGroup;

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
		
        float minTime, maxTime, minTank, maxTank,minUfo,maxUfo;
        // get the value of parameter of the event
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "time", &timeParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "tank_count", &nbTankParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "ufo_count", &nbUfoParam));
        // get the required range of the parameter and constrain the value
		checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
		checkFMODError(FMOD_EventParameter_GetRange(nbTankParam, &minTank, &maxTank));
		checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
        float constrainedValueTime = constrainFloat(0, minTime, maxTime);
        float constrainedValueTank = constrainFloat(0, minTank, maxTank);
        float constrainedValueUfo = constrainFloat(0, minUfo, maxUfo);
        // set the new value
        checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainedValueTime));
        checkFMODError(FMOD_EventParameter_SetValue(nbTankParam, constrainedValueTank));
        checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainedValueUfo));
        
        // trigger the event
		checkFMODError(FMOD_Event_Start(generalEvent));
        checkFMODError(FMOD_EventGroup_GetEvent(generalGroup, "pause_music", FMOD_EVENT_DEFAULT, &pauseEvent));
        checkFMODError(FMOD_Event_Start(pauseEvent));FMOD_Event_SetPaused(pauseEvent, 1);//
        
        FMOD_EVENT *helicopterEvent= NULL;
        // create an instance of the FMOD event
		checkFMODError(FMOD_EventGroup_GetEvent(helicopterGroup, "helicopter_sound", FMOD_EVENT_DEFAULT, &helicopterEvent));
		// trigger the event
		checkFMODError(FMOD_Event_Start(helicopterEvent));
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
        [background add:0 image:[[masterSpriteSheet imageForKey:@"background-ground"] retain] inFront:true];
        
        [masterSpriteSheet release];
		
        hud = [[GameHUD alloc] init];
        score = [[Score alloc] init];
        
        sharedOVNIManager = [OVNIManager sharedOVNIManager];
        
        sharedExplosionManager = [ExplosionManager sharedExplosionManager];
        //============================================//
	

        //================== TANKS ===================//
        maxNumTank= 5;
        createTankTimeout= 5;
        createTankTimer= 0;
		
        tanks= [[NSMutableArray alloc] initWithObjects:nil];
        [tanks addObject:[[Tank alloc] init]];//ajout d'un nouveau tank dans le tableau
        //============================================//
		
		//==================== UFO ===================//
        maxNumUfo= 2;
        createUfoTimeout= 5;
        createUfoTimer= 0;
        
        ufos= [[NSMutableArray alloc] initWithObjects:nil];
        //[ufos addObject:[[Ufo alloc] init]];//ajout d'un nouvel ufo dans le tableau
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
        FMOD_Event_SetPaused(tankEvent, 1);
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
        FMOD_Event_SetPaused(tankEvent, 0);
        FMOD_Event_SetPaused(ufoEvent, 0);
        FMOD_Event_SetPaused(gameOverEvent, 0);
        FMOD_Event_SetPaused(pauseEvent, 1);
        timeEllapsed+= aDelta;
        
        //================== FMOD SOUND MUSIC ===================//
        float minTime, maxTime, minTank, maxTank,minUfo,maxUfo;
        // get the value of parameter of the event
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "time", &timeParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "tank_count", &nbTankParam));
        checkFMODError(FMOD_Event_GetParameter(generalEvent, "ufo_count", &nbUfoParam));
        // get the required range of the parameter and constrain the value
        checkFMODError(FMOD_EventParameter_GetRange(timeParam, &minTime, &maxTime));
        checkFMODError(FMOD_EventParameter_GetRange(nbTankParam, &minTank, &maxTank));
        checkFMODError(FMOD_EventParameter_GetRange(nbUfoParam, &minUfo, &maxUfo));
        float constrainedValueTime = constrainFloat(timeEllapsed/100, minTime, maxTime);
        float constrainedValueTank = constrainFloat([tanks count], minTank, maxTank);
        float constrainedValueUfo = constrainFloat([ufos count], minUfo, maxUfo);
        // set the new value
        checkFMODError(FMOD_EventParameter_SetValue(timeParam, constrainedValueTime));
        checkFMODError(FMOD_EventParameter_SetValue(nbTankParam, constrainedValueTank));
        checkFMODError(FMOD_EventParameter_SetValue(nbUfoParam, constrainedValueUfo));
        
        //============================================//
        
        //================== TANKS ===================//
        //Toutes les createTankTimeout secondes on cree un nouveau tank si le maxNumTank n'est pas atteint
        if (createTankTimer>= createTankTimeout) if ([tanks count]< maxNumTank)
        {
            [tanks addObject:[[Tank alloc] init]];//ajout d'un nouveau tank dans le tableau
            createTankTimer= 0;
        }
        createTankTimer+= aDelta;

        
        if ([tanks count]) for(int i=0;i<[tanks count];i++)
        //iteration sur un nombre plutot que "for(Tank *tank in tanks)" pour eviter erreur liee a la suppression du tank tué :
        //"NSmutableArray was mutated while being iterated"
        {
            Tank *tank= [tanks objectAtIndex:i];        
            
            bool touched= false;
            for(Missile *missile in helicopter->missiles)
            {
                if (   [missile getXCoord]>= [tank getXCoord]-tank->width/2
                    && [missile getXCoord]<= [tank getXCoord]+tank->width/2
                    //&& [missile getYCoord]>= [tank getYCoord]-tank->height/2 //tjs le cas avec la gravité (le missile arrive par le haut)
                    && [missile getYCoord]<= [tank getYCoord]+tank->height/2)
                {
                    [tanks removeObject: tank];
                    [tank die];
                    [helicopter->missiles removeObject: missile];
                    [missile die];
                    
                    killedTanks++;
                    touched= true;
                    i--;
                    break;
                }
            }
            if (!touched)
            {
                [tank move];
                [tank update:aDelta];
                if (tank->shootTimer>= tank->shootTimeout)
                {
                    [tank aim:(float)helicopter.getXCoord targetY:(float)helicopter.getYCoord aDelta:(float)aDelta];
                    tank->shootTimer= 0;
                }
                tank->shootTimer+= aDelta;
                //================== Obus ===================//
                for(int j=0;j<[tank->obus count];j++)
                //iteration sur un nombre plutot que "for(Obus *obu in tank->obus)" pour eviter erreur liee a la suppression de l'obus :
                //"NSmutableArray was mutated while being iterated"
                {
                    Obus *obu= [tank->obus objectAtIndex:j];
                    if (![obu move])
                    {
                        [tank->obus removeObject: obu];
                        [obu die];
                    }
                    else [obu update:aDelta];
                }
                //==========================================//
            }
        }
        //===========================================//
        
        
        //================= Ufos ==================//
        //Toutes les createUfoTimeout secondes on cree un nouveau tank si le maxNumUfo n'est pas atteint
        if (createUfoTimer>= createUfoTimeout) if ([ufos count]< maxNumUfo)
        {
            [ufos addObject:[[Ufo alloc] init]];//ajout d'un nouvel Ufo dans le tableau
            createUfoTimer= 0;
        }
        createUfoTimer+= 0;//aDelta;
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
        if ([tanks count]) for(int i=0;i<[tanks count];i++)
        {
            Tank *tank= [tanks objectAtIndex:i];
            
            for(int j=0;j<[tank->obus count];j++)
                //iteration sur un nombre plutot que "for(Obus *obu in tank->obus)" pour eviter erreur liee a la suppression de
                //l'obus : "NSmutableArray was mutated while being iterated"
            {
                if( ([helicopter getYCoord] <= 100) ||
                   ([tank getXCoord]+tank->width/4 >= [helicopter getXCoord]-helicopter->width/4	&&
                    [tank getYCoord]+tank->height/4 >= [helicopter getYCoord]-helicopter->height/4	&&
                    [tank getYCoord]-tank->height/4 <= [helicopter getYCoord]+helicopter->height/4))
                {
                    [tank die];
                    NSLog(@"CRASH HELICOPTER FLOOR OR BY TANK!");
                    [helicopter die];
                    collision= false;
                       
                }			   
                else
                {
                    Obus *obu= [tank->obus objectAtIndex:j];
                    if (   [obu getXCoord] >= [helicopter getXCoord]-helicopter->width/2
                        && [obu getXCoord] <= [helicopter getXCoord]+helicopter->width/2
                        && [obu getYCoord] >= [helicopter getYCoord]-helicopter->height/2)
                    {
                        [tank->obus removeObject: obu];
                        [obu die];
                        NSLog(@"CRASH OBUS!");
                        [helicopter die];
                        collision= true;
                        i--;
                        break;
                    }
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
        
        [sharedOVNIManager update:aDelta];
        
        [sharedExplosionManager update:aDelta];
        
        [background update:aDelta];
        
        [score update:aDelta kills:killedTanks];
        [hud update:aDelta score:[score getValue]];
        //============================================//
	}
}


- (void)renderScene
{
	glClear(GL_COLOR_BUFFER_BIT);
	
    [background renderRear];    
    
    //============================================//    
    
    //================== TANKS ===================//
    for(Tank *tank in tanks)
    {
        [tank render];
        for (id obu in tank->obus) [obu render];
    }
    //============================================//
    
	//=================== UFO ====================//
    for(id ufo in ufos) [ufo render];
    //============================================//
    
    //================ HELICOPTER ================//
	[helicopter render];
    for(id missile in helicopter->missiles) [missile render];
    //============================================//

    [sharedOVNIManager render];
    
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

- (void)clickedShootButton
{
    [helicopter shoot];
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


