#import <Foundation/Foundation.h>
#import "Animation.h"
#import "ExplosionManager.h"

enum {
    mDirection_LeftToRight = 1,
    mDirection_RightToLeft = -1
};

@interface MobileEntity : NSObject {
    
    // Position de l'objet.
    CGPoint position;
    CGPoint spawnPoint;
    // Animation de déplacement principale.
    Animation *animation;
    
    CGSize size;
    
    // Vitesse et sens de déplacement.
    float speed;
    int direction;
    
    ExplosionManager *sharedExplosionManager;
}

@property (nonatomic, getter = getPosition) CGPoint position;

- (id) init:(Animation*)anim position:(CGPoint)pos size:(CGSize)entitySize;

- (void) update:(float)delta;

- (void) render;

- (Boolean) isOut;

- (void) dealloc;

@end
