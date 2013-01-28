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

	[super dealloc];
}


- (id)init {
	
	if(self == [super init]) {

		// Set the name of this scene
		self.name = @"menu";
		
		sharedImageRenderManager = [ImageRenderManager sharedImageRenderManager];
		sharedGameController = [GameController sharedGameController];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedTextureManager = [TextureManager sharedTextureManager];

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
        
        credits = [[BitmapFont alloc] initWithFontImageNamed:@"franklin16.png" controlFile:@"franklin16" scale:Scale2fMake(1.0f, 1.0f) filter:GL_LINEAR];
        credits.fontColor = Color4fMake(0.95f, 0.7f, 0.3f, 1.0f);
        
        settings =  [[Image alloc] initWithImageNamed:@"menu-settings.png" filter:GL_LINEAR];
        settingsButtonBounds = CGRectMake(445, 285, 30, 30);
        
        biker= [[Animation alloc] createFromImageNamed:@"biker.png" frameSize:CGSizeMake(46, 40) spacing:0 margin:0 delay:0.1f state:kAnimationState_Running type:kAnimationType_Repeating columns:7 rows:1];
        biker2= [[Animation alloc] createFromImageNamed:@"biker2.png" frameSize:CGSizeMake(45, 40) spacing:0 margin:0 delay:0.1f state:kAnimationState_Running type:kAnimationType_Repeating columns:8 rows:1];
        groundProjection= [[Animation alloc] createFromImageNamed:@"biker-ground-projection.png" frameSize:CGSizeMake(27, 14) spacing:0 margin:0 delay:0.1f state:kAnimationState_Running type:kAnimationType_Repeating columns:8 rows:1];

		// The allBack image is a single black pixel. This texture is stretched to fill the full
		// screen my scaling the image
		fadeImage = [[Image alloc] initWithImageNamed:@"allBlack.png" filter:GL_NEAREST];
		fadeImage.color = Color4fMake(1.0, 1.0, 1.0, 1.0);
		fadeImage.scale = Scale2fMake(480, 320);
            
		// Init the fadespeed and alpha for this scene
		fadeSpeed = 1.0f;
		alpha = 1.0f;
		
	}
 return self;
}

- (void)updateSceneWithDelta:(float)aDelta {
    [menuBackground update:aDelta];
    
    
    if (helicoCoord.x - helicoBody.imageSize.width / 2 > 480) {
        helicoCoord.x = -50;
        helicoCoord.y = arc4random()%(int)((120 - helicoBody.imageSize.height) / 2) + 200;
        
	}	
    else {
        sinModifierIncrease = (sinModifierIncrease && sinModifier <= 20) || (!sinModifierIncrease && sinModifier <= -20);
        sinModifier += sinModifierIncrease ? 1 : -1;
        helicoCoord.y += sinModifierIncrease ? .2 : -.2;
    }
                         
    helicoCoord.x += 1;
    
    [helicoRotor updateWithDelta:aDelta];
    
    if (bikerCoord.x + 46 / 2 < 0) {
        bikerCoord.x= 480+46;
        bikerCoord.y= 50;
    }
    bikerCoord.x -= 1;
    [biker updateWithDelta:aDelta];
    [groundProjection updateWithDelta:aDelta];
    
    if (biker2Coord.x + 45 / 2 < 0)
    {
        biker2Coord.x= 480+45+20;
        biker2Coord.y= 47;
    }
    biker2Coord.x -= .8;
    [biker2 updateWithDelta:aDelta];
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
    [helicoRotor renderCenteredAtPoint:CGPointMake(helicoCoord.x + 15, helicoCoord.y + 7)];
    
    [biker renderCenteredAtPoint:bikerCoord];
    [groundProjection renderCenteredAtPoint:CGPointMake(bikerCoord.x+12,bikerCoord.y-13)];
    [biker2 renderCenteredAtPoint:biker2Coord];
    
    [gameTitle renderCenteredAtPoint:CGPointMake(240, 280)];
    
    [credits renderStringJustifiedInFrame:CGRectMake(230, 120, 20, 50) justification:BitmapFontJustification_MiddleCentered text:@"( toucher pour jouer )"];
    
    [credits renderStringJustifiedInFrame:CGRectMake(230, 90, 20, 50) justification:BitmapFontJustification_MiddleCentered text:@"(C) 2013 Patches"];
    [credits renderStringJustifiedInFrame:CGRectMake(230, 70, 20, 50) justification:BitmapFontJustification_MiddleCentered text:@"Antoni ANDRE Eric AUBRY-LACHAINAYE Hatim CHAHDI"];
    [credits renderStringJustifiedInFrame:CGRectMake(230, 50, 20, 50) justification:BitmapFontJustification_MiddleCentered text:@"Thibaud COLAS Romain JOURDES Baptiste VIEILLARD"];
	
    [settings renderAtPoint:settingsButtonBounds.origin];

	[sharedImageRenderManager renderImages];

}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	
	// Get the point where the player has touched the screen
	CGPoint originalTouchLocation = [touch locationInView:aView];
	
	CGPoint touchLocation = originalTouchLocation;
    touchLocation.x = originalTouchLocation.y;
    touchLocation.y = originalTouchLocation.x;

    // If the gear is pressed then show the settings for the game
    if (CGRectContainsPoint(settingsButtonBounds, touchLocation)) {
        [sharedGameController transitionToSceneWithKey:@"settings"];
    }
    else {
        [sharedGameController transitionToSceneWithKey:@"game"];
    }
}

@end
