// 
// BOOM !
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"


@interface Explosion : NSObject
{
@public
    
	CGPoint position;

	Animation *animation;
}

- (id) init:(Animation*)animation position:(CGPoint)pos;

- (void) update:(float)delta;

- (Boolean) isOver;

- (void) render;

- (void) dealloc;

@end
