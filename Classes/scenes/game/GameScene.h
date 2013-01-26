#import "AbstractScene.h"
#import "ImageRenderManager.h"
#import "GameController.h"
#import "SoundManager.h"
#import "SpriteSheet.h"
#import "PackedSpriteSheet.h"
#import "Animation.h"
#import "EAGLView.h"
#import "Image.h"

#import "Background.h"
#import "ExplosionManager.h"
#import "GameHUD.h"
#import "Helicopter.h"
#import "Tank.h"
#import "Ufo.h"
#import "Score.h"

#define MAX_FMOD_AUDIO_CHANNELS 10

@class Image;
@class Tank;
@class Background;
@class ExplosionManager;
@class ImageRenderManager;
@class SoundManager;
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


@interface GameScene : AbstractScene
{
	////////////////////// Singleton references
	GameController *sharedGameController;// Reference to the game controller
	ImageRenderManager *sharedImageRenderManager;// Reference to the image render manager
    
    SoundManager *sharedSoundManager;
	FMOD_EVENTSYSTEM *eventSystem;
    FMOD_EVENTPARAMETER *nbUfoParam,*nbTankParam,*timeParam;// parameter of the event_music_game
    
    FMOD_EVENTCATEGORY *game;
    FMOD_EVENT *generalEvent;
    FMOD_EVENT *pauseEvent;

	NSMutableDictionary *previousTouchTimestamps;
    NSMutableDictionary *fmodEventsForTouches;
    
    float timeEllapsed;
    //NSTimeInterval secondsElapsed;
    
    //================= Background ===============//
    const float groundAltitude;
    Background* background;
    
    Score* score;    
    GameHUD* hud;
    
    ExplosionManager* sharedExplosionManager;
    //============================================//

    //================ Classe TANK ===============//
    int killedTanks;
    NSMutableArray *tanks;
    float createTankTimer;
    int maxNumTank;//nombre max de tanks a l'ecran
    int createTankTimeout;//temps au bout duquel un tank est cree (tant que numTank<maxNumTank)
	CGSize tankRectangleSize;// Height and Width of the tank touch rectangle
    //============================================//    
    
	//================ Classe UFO ================//
    NSMutableArray *ufos;
    float createUfoTimer;
    int maxNumUfo;//nombre max d'ufo a l'ecran
    int createUfoTimeout;//temps au bout duquel un ufo est cree (tant que numUfo<maxNumUfo)
	CGSize ufoRectangleSize;// Height and Width of the tank touch rectangle
    //============================================//
    
    //================= JOYPAD ===================//  
	Image *joypad;				
	
	CGRect joypadBounds;		
	CGPoint joypadCenter;		
	CGSize joypadRectangleSize;	
	float joypadDistance;
	float joypadDirection;
	int joypadTouchHash;		  
	// This allows us to track the same touch during touchesMoved events
	BOOL isJoypadTouchMoving;	
	//============================================//  

	//Helicopter
	Helicopter *helicopter;
}

@end
