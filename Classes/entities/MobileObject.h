#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"
#import "ExplosionManager.h"



@class Image;

@interface MobileObject : NSObject
{
    @public
	CGRect screenBounds;
	float xCoord;//position en x de l'engin
    float yCoord;//position en y de l'engin
	int width;//largeur de l'engin (correspond a la largeur de son image)
    int height;//hauteur de l'engin (correspond a la hauteur de son image)
	int direction;//1 pour gauche->droite ou -1 pour droite->gauche
    
	CGRect hitBox;
	float speed;
	Image *skin; //Image de base
	SpriteSheet *spriteSheet; //Frame d'animation de l'entite
	Animation *animation; //Animation
    
    ExplosionManager *sharedExplosionManager;
}

- (void)move;
- (void)die;
- (void)render;
@property (nonatomic, getter= getXCoord) float xCoord;
@property (nonatomic, getter= getYCoord) float yCoord;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) int direction;

@end
