//
//  Controller.m
//  Assignment1
//
//  Created by Michael Hickman on 9/24/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import "Controller.h"

@implementation MyCustomView

- (IBAction)resetCam:(id)sender
{
	[OpenGLView resetcam];
}


- (IBAction)updateColor:(id)sender
{
	[OpenGLView updateColor: [red integerValue]
						   : [green integerValue]
						   : [blue integerValue]];
}


- (void) updateNearFar:(id)sender
{
	[OpenGLView updateNearFar: [near floatValue] :[far floatValue]];
}


- (void) setNearFar:(float)n :(float)f
{
	[near setIntegerValue: n];
	[far setIntegerValue: f];
}


- (void) updateLabels: (float)px :(float)py :(float)pz :(float)dx :(float) dy :(float)dz;
{
	[posx setFloatValue:px];
	[posy setFloatValue:py];
	[posz setFloatValue:pz];
	[dirx setFloatValue:dx];
	[diry setFloatValue:dy];
	[dirz setFloatValue:dz];
}

@end
