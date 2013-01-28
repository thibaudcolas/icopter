//
//  Gestion du joypad.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Joypad : NSObject
{

    Image *image;
    CGPoint center;
    CGRect bounds;
    
}

@property (nonatomic, getter = getBounds) CGRect bounds;
@property (nonatomic, getter = getCenter) CGPoint center;

- (id) init:(Image*)img;

- (void) render;

@end
