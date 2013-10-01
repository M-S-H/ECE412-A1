//
//  MainView.m
//  Assignment1
//
//  Created by Michael Hickman on 9/24/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import "MainView.h"
#import "Model.h"


vec gOrigin = {0.0, 0.0, 0.0};


@implementation MainView


+ (NSOpenGLPixelFormat*) basicPixelFormat
{
	NSOpenGLPixelFormatAttribute attributes [] = {
        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute)16,
        (NSOpenGLPixelFormatAttribute)nil
    };
    
	return [[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];
}



- (void) drawObject
{
	glBegin(GL_TRIANGLES);
	for (int i=0; i<m->tri_num; i++)
	{
		for (int j=0; j<3; j++)
		{
			glColor3f(color[0], color[1], color[2]);
			glNormal3f(m->tri[i].normal[j].x, m->tri[i].normal[j].y, m->tri[i].normal[j].z);
			glVertex3f(m->tri[i].vertex[j].x, m->tri[i].vertex[j].y, m->tri[i].vertex[j].z);
		}
	}
	glEnd();
}



- (void) updateProjection
{
	GLdouble ratio, radians, wd2;
	GLdouble left, right, top, bottom;
	
	[[self openGLContext] makeCurrentContext];
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	radians = 0.0174532925 * cam.aperture / 2;
	wd2 = near * tan(radians);
	ratio = cam.viewWidth / (float) cam.viewHeight;
	
	if (ratio >= 1.0)
	{
		left = -ratio * wd2;
		right = ratio * wd2;
		top = wd2;
		bottom = -wd2;
	}
	else
	{
		left = -wd2;
		right = wd2;
		top = wd2 / ratio;
		bottom = -wd2 / ratio;
	}
	
	glFrustum(left, right, bottom, top, near, far);
}



- (void) drawRect:(NSRect)bounds
{
	[self resizeGL];
	[self updateModelView];
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glPolygonMode(GL_FRONT_AND_BACK, polyMode);
	glFrontFace(cullMode);
	
	[self drawObject];
	
	if ([self inLiveResize])
		glFlush ();
	else
		[[self openGLContext] flushBuffer];
}



- (void) updateModelView
{
	[[self openGLContext] makeCurrentContext];
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(cam.pos.x,
			  cam.pos.y,
			  cam.pos.z,
			  cam.pos.x + cam.dir.x,
			  cam.pos.y + cam.dir.y,
			  cam.pos.z + cam.dir.z,
			  cam.up.x,
			  cam.up.y,
			  cam.up.z);
	
	[con updateLabels:cam.pos.x :cam.pos.y :cam.pos.z :cam.dir.x :cam.dir.y :cam.dir.z];
}



- (void) resizeGL
{
	NSRect rectView = [self bounds];
	
	if ((cam.viewHeight != rectView.size.height) || (cam.viewWidth != rectView.size.width))
	{
		cam.viewHeight = rectView.size.height;
		cam.viewWidth = rectView.size.width;
		
		glViewport(0, 0, cam.viewWidth, cam.viewHeight);
		[self updateProjection];
	}
}



- (void) prepareOpenGL
{
	long swapInt = 1;
	
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval]; //set to vbl sync
	
	glEnable(GL_DEPTH_TEST);
	cullMode = GL_CW;
	
	glShadeModel(GL_SMOOTH);
	glEnable(GL_CULL_FACE);
	glFrontFace(cullMode);
	glPolygonOffset(1.0f, 1.0f);
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	[self resetcam];
	
	[con setNearFar:near :far];
}



- (void) resetcam
{
	cam.aperture = 40;
	cam.rot = gOrigin;
	
	cam.pos.x = (m->maxx + m->minx)/2;
	cam.pos.y = (m->maxy + m->miny)/2;
	cam.pos.z = (m->maxz + m->minz)/2 + (m->maxz - m->minz)*4;
	
	cam.dir.x = 0;
	cam.dir.y = 0;
	cam.dir.z = -cos(cam.rot.y);
	
	cam.up.x = 0;
	cam.up.y = 1;
	cam.up.z = 0;
	
	[self setNeedsDisplay: YES];
}



- (void)keyDown:(NSEvent *)theEvent
{
    NSString *characters = [theEvent characters];
    if ([characters length]) {
        unichar character = [characters characterAtIndex:0];
		switch (character) {
			
			case 'w':
				cam.pos.x += cam.dir.x * increment;
				cam.pos.y += cam.dir.y * increment;
				cam.pos.z += cam.dir.z * increment;
				[self setNeedsDisplay: YES];
				break;
			case 's':
				cam.pos.x -= cam.dir.x * increment;
				cam.pos.y -= cam.dir.y * increment;
				cam.pos.z -= cam.dir.z * increment;
				[self setNeedsDisplay: YES];
				break;
			case 'j':
				cam.rot.y -= 0.01;
				cam.dir.x = sin(cam.rot.y);
				cam.dir.z = -cos(cam.rot.y);
				[self setNeedsDisplay: YES];
				break;
			case 'l':
				cam.rot.y += 0.01;
				cam.dir.x = sin(cam.rot.y);
				cam.dir.z = -cos(cam.rot.y);
				[self setNeedsDisplay: YES];
				break;
			case 'd':
				cam.pos.z += sin(cam.rot.y) * increment;
				cam.pos.x -= -cos(cam.rot.y) * increment;
				[self setNeedsDisplay: YES];
				break;
			case 'a':
				cam.pos.z -= sin(cam.rot.y) * increment;
				cam.pos.x += -cos(cam.rot.y) * increment;
				[self setNeedsDisplay: YES];
				break;
		}
	}
}



- (void) mouseDown: (NSEvent*) theEvent
{
	start = [self convertPoint:[theEvent locationInWindow] fromView:nil];
}

- (void) mouseDragged: (NSEvent *) theEvent
{
	NSPoint current = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	
	cam.rot.y += (start.x - current.x) * 0.01;
	cam.dir.x = sin(cam.rot.y);
	cam.dir.z = -cos(cam.rot.y);
	
	[self setNeedsDisplay: YES];
	
	start = current;
}


- (void) mouseUp: (NSEvent *) theEvent
{
	
}



- (void) updateCamera: (float)posx :(float)posy :(float)posz :(float)dirx :(float)diry :(float)dirz;
{
	cam.pos.x = posx;
	cam.pos.y = posy;
	cam.pos.z = posz;
	cam.dir.x = dirx;
	cam.dir.y = diry;
	cam.dir.z = dirz;
	
	[self setNeedsDisplay: YES];
}


- (void) updateColor:(float)red :(float)green :(float)blue
{
	color[0] = red/255;
	color[1] = green/255;
	color[2] = blue/255;
	
	[self setNeedsDisplay: YES];
}



- (void) updateNearFar:(float)n :(float)f;
{
	near = n;
	far = f;

	NSLog(@"near = %f\nfar = %f\n\n", n, f);
	
	[self updateProjection];
	[self setNeedsDisplay: YES];
}



- (void) updateMode: (int)tag
{
	switch (tag)
	{
		case 0:
			polyMode = GL_FILL;
			break;
		case 1:
			polyMode = GL_LINE;
			break;
		case 2:
			polyMode = GL_POINT;
			break;
	}
	
	[self setNeedsDisplay: YES];
}


- (void) updateCulling: (int)tag
{
	switch (tag)
	{
		case 0:
			cullMode = GL_CW;
			break;
		case 1:
			cullMode = GL_CCW;
			break;
	}

	[self setNeedsDisplay: YES];
}



- (void) printCamera
{
	NSLog(@"posx = %f, posy = %f, posz = %f\ndirx = %f, diry = %f, dirz = %f\n", cam.pos.x, cam.pos.y, cam.pos.z, cam.dir.x, cam.dir.y, cam.dir.z);
}



- (BOOL)acceptsFirstResponder
{
	return YES;
}



- (BOOL)becomeFirstResponder
{
	return  YES;
}



- (BOOL)resignFirstResponder
{
	return YES;
}


- (void) loadModel:(NSString *)s
{
	m = [[Model alloc] initWithFile:s];
	
	near = (m->maxz - m->minz)*2;
	far = 4*near;
	
	cam.rot.y = 0;
	
	float max = 1;
	
	if (m->maxx - m->minx > max)
		max = m->maxx - m->minx;
	if (m->maxy - m->miny > max)
		max = m->maxy - m->miny;
	if (m->maxz - m->minz >max)
		max = m->maxz - m->minz;
	
	polyMode = GL_FILL;
	
	increment = max / 50;
	
	if (near < 0.00001)
		near = 0.00001;
	
	if (far < 1.0)
		far = 1.0;
	
	[self resetcam];
	[con setNearFar:near :far];
	[self updateProjection];
	[self setNeedsDisplay: YES];
}



- (id) initWithFrame:(NSRect)frameRect
{
	NSOpenGLPixelFormat *pf = [MainView basicPixelFormat];
	
	m = [[Model alloc] init];
	
	near = (m->maxz - m->minz)*2;
	far = 4*near;
	
	cam.rot.y = 0;
	
	float max = 1;
	
	if (m->maxx - m->minx > max)
		max = m->maxx - m->minx;
	if (m->maxy - m->miny > max)
		max = m->maxy - m->miny;
	if (m->maxz - m->minz >max)
		max = m->maxz - m->minz;

	polyMode = GL_FILL;
	
	increment = max / 50;
	
	if (near < 0.00001)
		near = 0.00001;
	
	if (far < 1.0)
		far = 1.0;
	
	color[0] = 1.0;
	color[1] = 1.0;
	color[2] = 1.0;
	
	self = [super initWithFrame: frameRect pixelFormat: pf];
	return self;
}



- (void) awakeFromNib
{

}


@end
