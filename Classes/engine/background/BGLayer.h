//
// BGLayer : Couche / image défilante faisant partie du background.
//

#import "Image.h"

@interface BGLayer : NSObject {
    
    // Position du fond (x = 0 la plupart du temps, y variable).
    CGPoint position;
    // Vitesse de défilement (0 = fond fixe).
    float speed;
    
    Image* image;
}

@property(nonatomic)CGPoint position;
@property(nonatomic)float speed;

- (id)init:(float)initSpeed ord:(int)initOrdinate image:(NSString*)imagePath;

- (void)update:(float)delta;

- (void)render;

@end
