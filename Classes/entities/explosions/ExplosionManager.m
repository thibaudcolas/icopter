// 
// BOOM ALL THE THINGS !
//

#import "SynthesizeSingleton.h"
#import "PackedSpriteSheet.h"
#import "ExplosionManager.h"
#import "Explosion.h"

@implementation ExplosionManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(ExplosionManager);

- (id)init {
    self = [super init];
    
    if (self != nil) {

        explosions = [[NSMutableArray alloc] init];
        
        PackedSpriteSheet *masterSpriteSheet = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"explosion-atlas.png" controlFile:@"explosion-coordinates" imageFilter:GL_LINEAR];
        
        rocketLauncherDestroyed = [[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"explosion-big-ground"] retain] frameSize:CGSizeMake(82, 87) spacing:0 margin:0 delay:0.05f state:kAnimationState_Stopped type:kAnimationType_Once columns:6 rows:4];
        helicoAirDestroyed = [[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"explosion-big-air"] retain] frameSize:CGSizeMake(60, 63) spacing:0 margin:0 delay:0.05f state:kAnimationState_Stopped type:kAnimationType_Once columns:7 rows:4];
        missileDetonates = [[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"explosion-small-ground"] retain] frameSize:CGSizeMake(43, 50) spacing:0 margin:0 delay:0.15f state:kAnimationState_Stopped type:kAnimationType_Once columns:10 rows:1];
        
        [masterSpriteSheet release];
        
        NSLog(@"INFO - ExplosionManager: Created successfully");
    }
    return self;
}

// Ajoute une explosion à gérer.
- (void)add:(int)type position:(CGPoint)pos {
    
    if ([explosions count] < 10) {
        switch (type) {
            case bAnimation_rocketLauncherDestroyed : 
                [explosions addObject:[[Explosion alloc] init:rocketLauncherDestroyed position:pos]];
                break;
            case bAnimation_helicoAirDestroyed :
                [explosions addObject:[[Explosion alloc] init:helicoAirDestroyed position:pos]];
                break;
            case bAnimation_missileDetonates :
                [explosions addObject:[[Explosion alloc] init:missileDetonates position:pos]];
                break;
            default:
                [explosions addObject:[[Explosion alloc] init:missileDetonates position:pos]];
                break;
        }
    }
}

- (void)update:(float)delta {
    Explosion* tmp;

    for (int i = 0; i < [explosions count]; i++) {
        tmp = [explosions objectAtIndex:i];
        [tmp update:delta];
        if ([tmp isOver]) {
            [explosions removeObjectAtIndex:i];
            [tmp autorelease];
        }
    }
}


- (void)render {
    for (Explosion* e in explosions) {
        [e render];
    }
}


// Libère la mémoire utilisée.
- (void)dealloc {
    [rocketLauncherDestroyed release];
    [helicoAirDestroyed release];
    [missileDetonates release];
    [explosions release];
    NSLog(@"INFO - ExplosionManager: Removed successfully");
    [super dealloc];
}

@end
