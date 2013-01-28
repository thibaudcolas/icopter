//
//  Enemy.m
//  CH12_SLQTSOR
//
//  Created by Patch on 19/10/12.
//  Copyright 2012 Patches. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

- (id) init
{
	self= [super init];
	return self;
}
- (void) die//explosion de l'engin (animation) et suppression de l'instance
{
    [super die];
}
@end
