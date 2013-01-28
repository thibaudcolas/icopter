#import "AbstractScene.h"
#import "Score.h"

@class ImageRenderManager;
@class SoundManager;
@class TextureManager;
@class GameController;
@class Image;

// This class defines the menu scene that is displayed to the player when they first start 
// the game.  It shows a main menu with an animated background.  It is able to display the
// historical highscores of the player along with instructions, credits and the ability to
// not only start a new game but also resume a saved game.
//
@interface GameOverScene : AbstractScene {

	/////////////////// Singleton Managers
	ImageRenderManager *sharedImageRenderManager;
	GameController *sharedGameController;
	SoundManager *sharedSoundManager;
	TextureManager *sharedTextureManager;
	
    /////////////////// Sprite sheets and images
	Image *background;					// Background image for the menu
	Image *fadeImage;					// Full screen black image used to fade in and out
	Image *done;			// Menu and menu button images
    
    
	/////////////////// Button iVars
	uint startWidth, resumeWidth;
	uint xStart, xResume;
	CGRect doneButtonBounds;
    
    
	/////////////////// Sound iVar
	GLfloat musicVolume;				// Music volume used to fade music in and out
	
    /////////////////// Flags
	BOOL isMusicFading;					// YES if the music is already fading during a transition
	BOOL buttonPressed;					// YES if the player has pressed a button
    
}

@end
