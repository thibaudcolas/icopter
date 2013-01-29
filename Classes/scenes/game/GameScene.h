#import "AbstractScene.h"
#import "ImageRenderManager.h"
#import "GameController.h"
#import "SpriteSheet.h"
#import "PackedSpriteSheet.h"
#import "Animation.h"
#import "EAGLView.h"
#import "Image.h"

#import "FmodSoundManager.h"

#import "Background.h"
#import "ExplosionManager.h"
#import "GameHUD.h"
#import "Helicopter.h"
#import "RocketLauncher.h"
#import "Ufo.h"
#import "Score.h"

@class Image;
@class RocketLauncher;
@class Background;
@class ExplosionManager;
@class ImageRenderManager;
@class FmodSoundManager;
@class GameController;
@class SpriteSheet;
@class PackedSpriteSheet;
@class Animation;
@class BitmapFont;
@class TiledMap;
@class ParticleEmitter;
@class Ufo;
@class GoText;
@class Helicopter;

Helicopter *helicopter;
NSMutableArray *rocketLaunchers;

@interface GameScene : AbstractScene
{
	////////////////////// Singleton references
	GameController *sharedGameController;// Reference to the game controller
	ImageRenderManager *sharedImageRenderManager;// Reference to the image render manager
    
	NSMutableDictionary *previousTouchTimestamps;
    
    float timeEllapsed;
    //NSTimeInterval secondsElapsed;
    
    //================= Background ===============//
    const float groundAltitude;
    Background* background;
    
    Score* score;    
    GameHUD* hud;
    
    int nbLives;
    
    FmodSoundManager* sharedFmodSoundManager;
    
    ExplosionManager* sharedExplosionManager;

    //============================================//

    //============= ROCKET LAUNCHER ==============//
    float createRocketLauncherTimer;
    int maxNumRocketLauncher;//nombre max de rocketLaunchers a l'ecran
    int createRocketLauncherTimeout;//temps au bout duquel un rocketLauncher est cree (tant que numRocketLauncher<maxNumRocketLauncher)
	CGSize rocketLauncherRectangleSize;// Height and Width of the rocketLauncher touch rectangle
    //============================================// 
    
    int killedRocketLaunchers;
    
	//================ Classe UFO ================//
    NSMutableArray *ufos;
    float createUfoTimer;
    int maxNumUfo;//nombre max d'ufo a l'ecran
    int createUfoTimeout;//temps au bout duquel un ufo est cree (tant que numUfo<maxNumUfo)
	CGSize ufoRectangleSize;
    //============================================//
    
	float joypadDistance;
	float joypadDirection;
	int joypadTouchHash;		  
	// This allows us to track the same touch during touchesMoved events
	BOOL isJoypadTouchMoving;	
	//============================================//  

}

@end
