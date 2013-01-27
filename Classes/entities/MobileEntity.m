#import "MobileEntity.h"

@implementation MobileEntity

@synthesize position;

- (id) init:(Animation*)anim position:(CGPoint)pos size:(CGSize)entitySize {
    self = [super init];
    sharedExplosionManager = [ExplosionManager sharedExplosionManager];
    
    size = entitySize;
    
    animation = anim;
    animation.state = kAnimationState_Running;
    animation.currentFrame = 0;
    animation.type = kAnimationType_Repeating;
    position = pos;
    
    return self;
}

- (void) update:(float)delta {
    if ([self isOut]) {
        position = spawnPoint;
    }
    position.x += direction * speed * delta;
    [animation updateWithDelta:delta];
}

- (void) render {
    [animation renderCenteredAtPoint:position];
}

- (Boolean) isOut {
    return position.x + (size.width / 2) < -20;
}

- (void) dealloc {
    [super dealloc];
}


@end
