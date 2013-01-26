// 
// BOOM ALL THE THINGS !
//

enum {
    bAnimation_tankDestroyed = 0,
    bAnimation_tankDamaged = 1,
    bAnimation_helicoDamaged = 2,
    bAnimation_helicoAirDestroyed = 3,
    bAnimation_helicoGroundDestroyed = 4,
    bAnimation_bombDetonates = 5,
    bAnimation_missileDetonates = 6,
    bAnimation_obstacleCollides = 7,
    bAnimation_obstacleDestroyed = 8
};

#import <Foundation/Foundation.h>
#import "SpriteSheet.h"
#import "Animation.h"

@interface ExplosionManager : NSObject {

    NSMutableArray *explosions;
    
    Animation *tankDestroyed;
    Animation *helicoAirDestroyed;
}

// Returns as instance of the ExplosionManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (ExplosionManager *)sharedExplosionManager;

- (id)init;

- (void)add:(int)type position:(CGPoint)pos;

- (void)update:(float)delta;

- (void)render;

- (void)dealloc;


@end
