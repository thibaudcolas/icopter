#import "GameScene.h"

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
        nbLives = 3;
		// Grab an instance of the render manager
		sharedGameController= [GameController sharedGameController];
		sharedImageRenderManager= [ImageRenderManager sharedImageRenderManager];
        
        //=================== SOUND ==================//
        sharedFmodSoundManager= [FmodSoundManager sharedFmodSoundManager];
        
        //declenche les sons
        [sharedFmodSoundManager add:gameMusic];
        [sharedFmodSoundManager add:helicopterSound];
        [sharedFmodSoundManager add:helicopterAltitudeAlert immediate:false];
        [sharedFmodSoundManager add:pauseMusic immediate:false];
        [sharedFmodSoundManager add:gameOverSound immediate:false];
        [sharedFmodSoundManager add:goSound];
        [sharedFmodSoundManager initMusicParams];
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
    if (state== kSceneState_GameOver)
    {
        [sharedFmodSoundManager newInstance:gameOverSound];
        [sharedGameController transitionToSceneWithKey:@"gameover"];
        state= kSceneState_Running;
    }
    else if (state== kSceneState_Paused)
    {
        [sharedFmodSoundManager play:pauseMusic];
        [sharedFmodSoundManager pause:gameMusic];
        [sharedFmodSoundManager pause:helicopterSound];
        [sharedFmodSoundManager pause:rocketLauncherSound];
        [sharedFmodSoundManager pause:ufo];
        [sharedFmodSoundManager pause:michou];
    
    }
    else
    {
        [sharedFmodSoundManager pause:pauseMusic];
        [sharedFmodSoundManager play:gameMusic];
        [sharedFmodSoundManager play:helicopterSound];
        
        timeEllapsed+= aDelta;
        
        [sharedFmodSoundManager updateMusicParams:timeEllapsed rocketLaunchersCount:[rocketLaunchers count] ufoCount:[ufos count]];
        [sharedFmodSoundManager update];
    
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
                if (rocketLauncher->shootTimer <= 0 && rocketLauncher->kindOfRocketLauncher)
                {
                    if (rocketLauncher->readyToShoot)
                        [rocketLauncher shoot:(float)helicopter.getXCoord targetY:(float)helicopter.getYCoord aDelta:(float)aDelta];
                    else [rocketLauncher aim:(float)helicopter.getXCoord targetY:(float)helicopter.getYCoord aDelta:(float)aDelta];
                }
                rocketLauncher->shootTimer-= aDelta;
                //================== Rocket ===================//
                if (rocketLauncher->kindOfRocketLauncher) for(int j=0;j<[rocketLauncher->rockets count];j++)
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
                nbLives--;
                if (nbLives == 0) {
                    [helicopter die];
                    state=kSceneState_GameOver;
                } else {
                    [sharedFmodSoundManager add:helicopterExplosion];
                    [sharedFmodSoundManager release:helicopterExplosion immediate:false];
                    [sharedExplosionManager add:bAnimation_helicoDamaged position:CGPointMake([helicopter getXCoord], [helicopter getYCoord])];
                }
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
                    nbLives--;
                    if (nbLives == 0) {
                        [helicopter die];
                        state=kSceneState_GameOver;
                    } else {
                        [sharedFmodSoundManager add:helicopterExplosion];
                        [sharedFmodSoundManager release:helicopterExplosion immediate:false];
                        [sharedExplosionManager add:bAnimation_helicoDamaged position:CGPointMake([helicopter getXCoord], [helicopter getYCoord])];
                    }
                    collision= true;
                    
                    break;
                }
            }
        }
        if (!collision) {
            if(![helicopter move:joypadDistance joypadDirection:(float)joypadDirection aDelta:(float)aDelta]) {
                [helicopter die];
                state=kSceneState_GameOver;
            }
        }
        
        
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
        [hud update:aDelta score:[score getValue] kill:touched left:nbLives];
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
            }
            else
            {
                state= kSceneState_Running;
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
        
	}
}

@end


