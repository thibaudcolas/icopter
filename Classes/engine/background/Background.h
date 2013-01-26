//
// Background : Background multi-couches à effet parallax.
//

#import "BGLayer.h"

@interface Background : NSObject {
    
    // Facteur de vitesse de défilement globale de l'ensemble.
    float speed;
    // Ensemble des couches créant l'effet parallax. Arrière-plan et premier plan.
    NSMutableArray *rearLayers;
    NSMutableArray *frontLayers;
}

@property(nonatomic)float speed;

- (id)init:(float)initSpeed;

- (void)add:(int)initHeight image:(NSString*)imagePath inFront:(Boolean)putInFront;

- (void)update:(float)delta;

- (void)renderFront;

- (void)renderRear;

- (void)dealloc;

@end
