//
//  Projectile.h
//  projet
//
//  Created by Patch on 26/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "MobileObject.h"

@interface Projectile : MobileObject
{

}
-(void)move;
-(void)die;
@end
