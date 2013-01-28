//
// BGLayer : Couche / image défilante faisant partie du background.
//

#import "BGLayer.h"

@implementation BGLayer

@synthesize position;
@synthesize speed;

// Initialise un élément du background.
- (id)init:(float)initSpeed ord:(int)initOrdinate image:(Image*)img  {
    self = [super init];
    
    if (self != nil) {
        
        position = CGPointMake(0, (float)initOrdinate);
        speed = initSpeed;
        
        image = img;
    }
    return self;
}

// Met à jour la position de l'image.
- (void)update:(float)delta {
    position.x -= speed*delta;
    
    // Retour à zéro si l'image a entièrement disparu.
    if (position.x <= -[image imageSize].width) {
        position.x = 0;
    }
}

// Affiche notre couche.
- (void)render {
    
    // On doit afficher plusieurs fois la même image si elle est plus petite que l'écran. 
    float currentAbs = position.x;
    while(currentAbs < 480 + [image imageSize].width) {
        [image renderAtPoint:CGPointMake(currentAbs, position.y)];
        currentAbs += [image imageSize].width;
    }
    
}

// Libère la mémoire utilisée.
- (void)dealloc {
    [image release];
    [super dealloc];
}

@end
