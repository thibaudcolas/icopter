//
// Background : Background multi-couches à effet parallax.
//

#import "Background.h"

@implementation Background

@synthesize speed;

// Initialise le background.
- (id)init:(float)initSpeed {
    self = [super init];
    
    if (self != nil) {
        speed = initSpeed;
        rearLayers = [[NSMutableArray alloc] init];
        frontLayers = [[NSMutableArray alloc] init];
        
        NSLog(@"INFO - Background: Created successfully");
    }
    return self;
}

// Ajoute une couche à notre background.
- (void)add:(int)initOrdinate image:(NSString*)imagePath inFront:(Boolean)putInFront {
    // Plus un élément est loin de la route (i.e ajouté tôt), plus il est lent.
    int layersCount = [rearLayers count] + [frontLayers count];
    float calculatedSpeed = (layersCount * layersCount + 1) * 10 * speed;
    BGLayer *tmp = [[BGLayer alloc] init:calculatedSpeed ord:initOrdinate image:imagePath];
    if (putInFront) {
        [frontLayers addObject:tmp];
    }
    else {
        [rearLayers addObject:tmp];
    }
    [tmp release];
    
    NSLog(@"INFO - Background: Added image %@", imagePath);
}

// Met à jour la position des couches du background.
- (void)update:(float)delta {
    for (int i = 0; i < [frontLayers count]; i++) {
        [[frontLayers objectAtIndex:i] update:delta];
    }
    for (int i = 0; i < [rearLayers count]; i++) {
        [[rearLayers objectAtIndex:i] update:delta];
    }
}

// Affiche notre background.
- (void)renderFront {
    for (int i = 0; i < [frontLayers count]; i++) {
        [[frontLayers objectAtIndex:i] render];
    }
}

// Affiche notre background.
- (void)renderRear {
    for (int i = 0; i < [rearLayers count]; i++) {
        [[rearLayers objectAtIndex:i] render];
    }
}

// Libère la mémoire utilisée.
- (void)dealloc {
    [frontLayers release];
    [rearLayers release];
    [super dealloc];
}

@end
