#import "MenuScene.h"
#import "Global.h"
#import "ImageRenderManager.h"
#import "GameController.h"
#import "Image.h"
#import "BitmapFont.h"
#import "SoundManager.h"
#import "TextureManager.h"
#import "PackedSpriteSheet.h"
#import "SpriteSheet.h"
#import "Primitives.h"


@implementation MenuScene

- (void)dealloc {
	[background release];
	[fadeImage release];
	[settings release];
	[newGame release];
	[done release];
	[scores release];

	[super dealloc];
}

// Set up the strings for the menu items
# define startString @"New Game"
# define resumeString @"Resume Game"
# define scoreString @"Score"
# define creditString @"Credits"

- (id)init {
	
	if(self == [super init]) {

		// Set the name of this scene
		self.name = @"menu";
		
		sharedImageRenderManager = [ImageRenderManager sharedImageRenderManager];
		sharedGameController = [GameController sharedGameController];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedTextureManager = [TextureManager sharedTextureManager];
	/*	
		// Register for the instructions view being hidden so that we can undo the button highlight
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighlight) name:@"hidingInstructions" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighlight) name:@"hidingScore" object:nil];

		// Create a packed spritesheet for the menu
		pss = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"menuAtlas.png" controlFile:@"menuCoords" imageFilter:GL_LINEAR];
*/
        menuBackground = [[Background alloc] init:1];
        
        [menuBackground add:160 image:[[Image alloc] initWithImageNamed:@"background-menu-sky.png" filter:GL_LINEAR] inFront:false];
        [menuBackground add:170 image:[[Image alloc] initWithImageNamed:@"background-menu-clouds.png" filter:GL_LINEAR] inFront:false];
        [menuBackground add:0 image:[[Image alloc] initWithImageNamed:@"background-menu-forest.png" filter:GL_LINEAR] inFront:false];
        
        gameTitle = [[Image alloc] initWithImageNamed:@"menu-title.png" filter:GL_LINEAR];
        
        helicoBody = [[Image alloc] initWithImageNamed:@"helicopter.png" filter:GL_LINEAR];
        helicoRotor = [[Animation alloc] createFromImageNamed:@"helicopter-rotor.png" frameSize:CGSizeMake(80, 17) spacing:0 margin:0 delay:0.01f state:kAnimationState_Running type:kAnimationType_Repeating columns:10 rows:1];
        helicoCoord = CGPointMake(-50, 200);
        
        sinModifier = 0;
        sinModifierIncrease = true;
        
        newGame=  [[Image alloc] initWithImageNamed:@"New-Game.png" filter:GL_LINEAR];
        scores=  [[Image alloc] initWithImageNamed:@"scores.png" filter:GL_LINEAR];
        settings=  [[Image alloc] initWithImageNamed:@"settings.png" filter:GL_LINEAR];
        done=  [[Image alloc] initWithImageNamed:@"exit.png" filter:GL_LINEAR];


		// The allBack image is a single black pixel. This texture is stretched to fill the full
		// screen my scaling the image
		fadeImage = [[Image alloc] initWithImageNamed:@"allBlack.png" filter:GL_NEAREST];
		fadeImage.color = Color4fMake(1.0, 1.0, 1.0, 1.0);
		fadeImage.scale = Scale2fMake(480, 320);
            
		// Init the fadespeed and alpha for this scene
		fadeSpeed = 1.0f;
		alpha = 1.0f;
		
		// Define the bounds for the buttons being used on the menu
		startButtonBounds = CGRectMake(75, 235, 140, 47);
		scoreButtonBounds = CGRectMake(75, 178, 140, 47);
		settingsButtonBounds = CGRectMake(75, 120, 140, 47);
		doneButtonBounds = CGRectMake(75, 63, 140, 47);
	/*	
		// Set the default music volume for the menu.  Start at 0 as we are going to fade the sound up
		musicVolume = 1.0f;
		
		// Set the initial state for the menu
		state = kSceneState_Idle;
		
		// No buttons pressed yet
        buttonPressed = NO;
 
*/
	}
 return self;
}

- (void)updateSceneWithDelta:(float)aDelta {
    [menuBackground update:aDelta];
    
    
    if (helicoCoord.x - helicoBody.imageSize.width / 2 > 480) {
        helicoCoord.x = -50;
        helicoCoord.y = arc4random()%(int)((300 - helicoBody.imageSize.height) / 2) + 340 / 2;
        
	}	
    else {
        sinModifierIncrease = (sinModifierIncrease && sinModifier <= 20) || (!sinModifierIncrease && sinModifier <= -20);
        sinModifier += sinModifierIncrease ? 1 : -1;
        helicoCoord.y += sinModifierIncrease ? .2 : -.2;
    }
                         
    helicoCoord.x += 1;
    
    [helicoRotor updateWithDelta:aDelta];
}

- (void)transitionIn {
/*
    // Load GUI sounds
	[sharedSoundManager setListenerPosition:CGPointMake(0, 0)];
	[sharedSoundManager loadSoundWithKey:@"guiTouch" soundFile:@"guiTouch.caf"];
	[sharedSoundManager loadMusicWithKey:@"themeIntro" musicFile:@"themeIntro.mp3"];
	[sharedSoundManager loadMusicWithKey:@"themeLoop" musicFile:@"themeLoop.mp3"];
	[sharedSoundManager removePlaylistNamed:@"menu"];
	[sharedSoundManager addToPlaylistNamed:@"menu" track:@"themeIntro"];
	[sharedSoundManager addToPlaylistNamed:@"menu" track:@"themeLoop"];
	sharedSoundManager.usePlaylist = YES;
	sharedSoundManager.loopLastPlaylistTrack = YES;

    // Switch the idle timer back on as its not a problem if the phone locks while you are
	// at the menu.  This is recommended by apple and helps to save power
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
	state = kSceneState_TransitionIn;
	
	buttonPressed = NO;
 */
}

- (void)renderScene {

    glClear(GL_COLOR_BUFFER_BIT);
	// Render the background
    [menuBackground renderRear];
    
    [helicoBody renderCenteredAtPoint:helicoCoord];
    [helicoRotor renderCenteredAtPoint:CGPointMake(helicoCoord.x+15,helicoCoord.y+7)];
    
    [gameTitle renderCenteredAtPoint:CGPointMake(240,160)];
	
	[newGame renderAtPoint:CGPointMake(75, 235)];
    [scores renderAtPoint:CGPointMake(75, 178)];
    [settings renderAtPoint:CGPointMake(75, 120)];
    [done renderAtPoint:CGPointMake(75, 63)];
    
    
    /*
	// Loop through the clounds and render them
	for (int index=0; index < 7; index++) {
		Image *cloud = [clouds objectAtIndex:index];
		[cloud renderAtPoint:(CGPoint)cloudPositions[index]];
	}
	
	// Render the cast ontop of the background and clouds
	[castle renderAtPoint:CGPointMake(249, 0)];
	
	// Render the 71Squared logo
	[logo renderAtPoint:CGPointMake(25, 0)];

	// Render the gear image for settings
	[settings renderAtPoint:CGPointMake(450, 0)];
	
	// Render the menu and add the options text
	[menu renderAtPoint:CGPointMake(0, 0)];
	
	// Check with the game controller to see if a saved game is available
	if ([sharedGameController resumedGameAvailable])
		[menuButton renderAtPoint:CGPointMake(71, 60)];
	
	if (buttonPressed)
		[buttonHighlight renderAtPoint:highlightPosition];
	
	// If we are transitioning in, out or idle then render the fadeImage
	if (state == kSceneState_TransitionIn || state == kSceneState_TransitionOut || state == kSceneState_Idle) {
		[fadeImage renderAtPoint:CGPointMake(0, 0)];
	}
	*/
	// Having rendered our images we ask the render manager to actually put then on screen.
	[sharedImageRenderManager renderImages];
/*
// If debug is on then display the bounds of the buttons
	drawRect(startButtonBounds);
	drawRect(scoreButtonBounds);
	drawRect(instructionButtonBounds);
	drawRect(resumeButtonBounds);
	drawRect(logoButtonBounds);
	drawRect(settingsButtonBounds);
		*/
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	
	// Get the point where the player has touched the screen
	CGPoint originalTouchLocation = [touch locationInView:aView];
	
	CGPoint touchLocation = originalTouchLocation;
    touchLocation.x = originalTouchLocation.y;
    touchLocation.y = originalTouchLocation.x;

	// We only want to check the touches on the screen when the scene is running.
	//if (state == kSceneState_Running) {
		// Check to see if the user touched the start button
		if (CGRectContainsPoint(startButtonBounds, touchLocation)) {
            NSLog(@"Test Menu New Game dans if");
            // Ask the game controller to transition to the scene called game.
            [sharedGameController transitionToSceneWithKey:@"game"];
			return;
		}
		
		if (CGRectContainsPoint(scoreButtonBounds, touchLocation)) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"showHighScore" object:self];
            NSLog(@"Test Menu Score dans if");
			return;
		}
        // If the gear is pressed then show the settings for the game
        if (CGRectContainsPoint(settingsButtonBounds, touchLocation)) {
            [sharedGameController transitionToSceneWithKey:@"settings"];
            NSLog(@"Test Menu Settings dans if");
            return;
        }
		if (CGRectContainsPoint(doneButtonBounds, touchLocation)) {
            NSLog(@"Test Menu Done dans if");
			exit(0);
            return;
		}
		/*
		// If the resume button is visible then check to see if the player touched 
		// the resume button
		if ([sharedGameController resumedGameAvailable] && CGRectContainsPoint(resumeButtonBounds, touchLocation)) {
			[sharedSoundManager playSoundWithKey:@"guiTouch" gain:0.3f pitch:1.0f location:CGPointMake(0, 0) shouldLoop:NO ];
			alpha = 0;
			[sharedGameController setShouldResumeGame:YES];
			state = kSceneState_TransitionOut;
			highlightPosition = CGPointMake(85, 65);
			buttonPressed = YES;
			return;
		}
		
		// If the logo is pressed then show the credits for the game
		if (CGRectContainsPoint(logoButtonBounds, touchLocation)) {

			[[NSNotificationCenter defaultCenter] postNotificationName:@"showCredits" object:self];
			return;
		}
		*/

	//}
    
    NSLog(@"Aucun menu Touch");
}

- (void)updateHighlight {
	//buttonPressed = NO;
}

@end
