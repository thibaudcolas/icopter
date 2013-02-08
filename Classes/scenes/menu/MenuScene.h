#import "AbstractScene.h"

#import "Animation.h"
#import "Background.h"
#import "BitmapFont.h"
#import "FmodSoundManager.h"

@class ImageRenderManager;
@class TextureManager;
@class GameController;
@class Image;
@class Background;
@class BitmapFont;
@class Animation;
@class BitmapFont;
@class PackedSpriteSheet;

// This class defines the menu scene that is displayed to the player when they first start 
// the game.  It shows a main menu with an animated background.  It is able to display the
// historical highscores of the player along with instructions, credits and the ability to
// not only start a new game but also resume a saved game.
//
@interface MenuScene : AbstractScene {

	/////////////////// Singleton Managers
	ImageRenderManager *sharedImageRenderManager;
	GameController *sharedGameController;
	TextureManager *sharedTextureManager;
    
    FmodSoundManager *sharedFmodSoundManager;
    
    Background* menuBackground;
    Image* gameTitle;
    
    BitmapFont *credits;
    
    Image* helicoBody;
    Animation* helicoRotor;
    CGPoint helicoCoord;
    
    Animation* pig;
    
    int sinModifier;
    Boolean sinModifierIncrease;
    
    Animation* biker;
    CGPoint bikerCoord;
    Animation* biker2;
    CGPoint biker2Coord;
    Animation* groundProjection;
    CGPoint groundProjectionCoord;
	
    //Animation* background;
	/////////////////// Sprite sheets and images
	Image *background;					// Background image for the menu
	Image *fadeImage;					// Full screen black image used to fade in and out
	Image *settingsButton;
	Image *exitButton;
	
	CGRect settingsButtonBounds;
	CGRect exitButtonBounds;

		
}

@end
