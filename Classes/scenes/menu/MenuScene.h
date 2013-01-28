#import "AbstractScene.h"

#import "Animation.h"

@class ImageRenderManager;
@class SoundManager;
@class TextureManager;
@class GameController;
@class Image;
@class Animation;
@class BitmapFont;
@class PackedSpriteSheet;
@class Player;

// This class defines the menu scene that is displayed to the player when they first start 
// the game.  It shows a main menu with an animated background.  It is able to display the
// historical highscores of the player along with instructions, credits and the ability to
// not only start a new game but also resume a saved game.
//
@interface MenuScene : AbstractScene {

	/////////////////// Singleton Managers
	ImageRenderManager *sharedImageRenderManager;
	GameController *sharedGameController;
	SoundManager *sharedSoundManager;
	TextureManager *sharedTextureManager;
	
    //Animation* background;
	/////////////////// Sprite sheets and images
	Image *background;					// Background image for the menu
	Image *fadeImage;					// Full screen black image used to fade in and out
	Image *newGame, *settings, *scores,*done;			// Menu and menu button images
	
	/////////////////// iVars used to control the cloud movement
	CGPoint *cloudPositions;
	float cloudSpeed;
	
	/////////////////// Sound iVar
	GLfloat musicVolume;				// Music volume used to fade music in and out
	
	/////////////////// Button iVars
	uint startWidth, resumeWidth;
	uint xStart, xResume;
	CGRect startButtonBounds;
	CGRect scoreButtonBounds;
	CGRect doneButtonBounds;
	CGRect settingsButtonBounds;

	/////////////////// Flags
	BOOL isMusicFading;					// YES if the music is already fading during a transition
	BOOL buttonPressed;					// YES if the player has pressed a button
}

@end
