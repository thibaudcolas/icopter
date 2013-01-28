#import <UIKit/UIKit.h>
#import "AbstractScene.h"

@class SoundManager;
@class GameController;
@class ImageRenderManager;
@class SoundManager;
@class TextureManager;
@class GameController;
@class Image;
@class BitmapFont;
@class PackedSpriteSheet;
@class Player;

@interface SettingsScene : AbstractScene {

	//////////////////// Singleton references
	ImageRenderManager *sharedImageRenderManager;
	GameController *sharedGameController;
	SoundManager *sharedSoundManager;
	TextureManager *sharedTextureManager;
	
    IBOutlet UISlider *musicVolume;						// Controls the music volume
	IBOutlet UIButton *menuButton;						// Button that returns the player to the main menu

	BOOL isVisible;										// is the settings view currently visible
}


@end
