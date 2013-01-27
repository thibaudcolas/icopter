#import <Foundation/Foundation.h>
#import "MobileEntity.h"


@interface OVNI : MobileEntity {
    
    int sinModifier;
    Boolean sinModifierIncrease;
    
}

- (id) init:(Animation*)anim position:(CGPoint)pos size:(CGSize)entitySize;

- (void) dealloc;

@end
