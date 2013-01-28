//
//  AbstractState.h
//  SLQTSOR
//
//  Created by Michael Daley on 01/06/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class TextureManager;

// This is an abstract class which contains the basis for any game scene which is going
// to be used.  A game scene is a self contained class which is responsible for updating 
// the logic and rendering the screen for the current scene.  It is simply a way to 
// encapsulate a specific scenes code in a single class.
//
// The Director class controls which scene is the current scene and it is this scene which
// is updated and rendered during the game loop.
//
@interface AbstractScene : NSObject <UIAccelerometerDelegate> {

	CGRect screenBounds;		// Stores the screen bounds for the device
	uint state;					// Holds the state of the scene
	GLfloat alpha;				// Alpha value that can be used across the entire scene
	NSString *nextSceneKey;		// The key of the next scene
    float fadeSpeed;			// The speed at which this scene should fade in
	NSString *name;				// The name of the scene i.e. the key
	
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, assign) uint state;
@property (nonatomic, assign) GLfloat alpha;
@property (nonatomic, retain) NSString *name;

#pragma mark -
#pragma mark Selectors

// Selector to update the scenes logic using |aDelta| which is passe in from the game loop
- (void)updateSceneWithDelta:(float)aDelta;

// Selector that enables a touchesBegan events location to be passed into a scene.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

// Selector which enables accelerometer data to be passed into the scene.
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration;

// Selector that transitions from this scene to the scene with the key specified.  This allows the current
// scene to perform a transition action before the current scene within the game controller is changed.
- (void)transitionToSceneWithKey:(NSString*)aKey;

// Selector that sets off a transition into the scene
- (void)transitionIn;

// Selector which renders the scene
- (void)renderScene;
@end
