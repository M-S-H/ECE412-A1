//
//  MainView.h
//  Assignment1
//
//  Created by Michael Hickman on 9/24/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Controller.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "Model.h"


//- Vector structure
typedef struct {
	GLdouble x, y, z;
} vec;


//- Structure for the camera
typedef struct {
	vec			pos;					//camera position
	vec			dir;					//camera direction vector
	vec			up;						//camera up vector
	vec			rot;					//rotate vector
	GLdouble	aperture;
	GLint		viewWidth, viewHeight;
} camera;




@interface MainView : NSOpenGLView
{
	camera	cam;
	GLfloat	shapeSize;
	Model	*m;
	
	IBOutlet id con;
	
	float near;
	float far;
	
	float color[3];
	
	float increment;
	
	GLenum polyMode;
	GLenum cullMode;
}

+ (NSOpenGLPixelFormat*) basicPixelFormat;

- (void) drawObject;
- (void) updateProjection;
- (void) updateModelView;
- (void) resizeGL;
- (void) resetCamera;
- (void) updateCamera: (float)posx :(float)posy :(float)posz :(float)dirx :(float)diry :(float)dirz;
- (void) updateColor: (float)red :(float)green :(float)blue;
- (void) updateNearFar: (float)near :(float)far;
- (void) updateMode: (int)tag;
- (void) updateCulling: (int)tag;
- (void) printCamera;
- (void) loadModel: (NSString *)s;

- (void) drawRect:(NSRect)bounds;
- (void) prepareOpenGL;
- (void) update;

- (void) keyDown:(NSEvent *)theEvent;

- (BOOL) acceptsFirstResponder;
- (BOOL) becomeFirstResponder;
- (BOOL) resignFirstResponder;

- (id) initWithFrame: (NSRect)frameRect;
- (void) awakeFromNib;

@end
