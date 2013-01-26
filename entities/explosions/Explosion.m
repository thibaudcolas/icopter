// 
// BOOM !
//

#import "Explosion.h"


@implementation Explosion

- (id) init:(Animation*)anim position:(CGPoint)pos {
	self= [super init];
    
    if (self != nil) {
        animation = anim;
        animation.state = kAnimationState_Running;
        animation.currentFrame = 0;
        animation.type = kAnimationType_Once;
        position = pos;
        
        NSLog(@"INFO - Explosion: Created successfully");
    }
    
    return self;
}

- (void) update:(float)delta
{
    // MAJ suivant la vitesse du background (crade).
    position.x -= 250*delta;
    [animation updateWithDelta:delta];
}

- (Boolean) isOver {
    return [animation state] == kAnimationState_Stopped;
}

- (void) render
{
    [animation renderCenteredAtPoint:position];
}

- (void) dealloc
{
    NSLog(@"INFO - Explosion: Removed successfully");
    [super dealloc];
}

@end
