//
//  Controller.m
//  Assignment1
//
//  Created by Michael Hickman on 9/24/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import "Controller.h"

@implementation MyCustomView


- (IBAction)openModel:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];

	[openPanel beginSheetModalForWindow:_window completionHandler:^(NSInteger result) {
		if (result == NSOKButton)
		{
			NSURL *selection = openPanel.URLs[0];
			NSString *path = [selection.path stringByResolvingSymlinksInPath];
			NSLog(path);
			[OpenGLView loadModel:path];
		}
	}];
	
}

- (IBAction)resetCam:(id)sender
{
	[OpenGLView resetcam];
}


- (IBAction)changeColor:(id)sender
{
	[OpenGLView updateColor: [red integerValue]
						   : [green integerValue]
						   : [blue integerValue]];
}


- (IBAction) changeNearFar:(id)sender
{
	[OpenGLView updateNearFar: [near floatValue] :[far floatValue]];
}


- (void) setNearFar:(float)n :(float)f
{
	NSLog(@"set near = %f\nset far = %f\n\n", n, f);
	[near setIntegerValue: n];
	[far setIntegerValue: f];
}


- (IBAction)changeMode:(id)sender
{
	[OpenGLView updateMode: [[sender selectedCell] tag]];
}


- (IBAction)changeCull:(id)sender
{
	[OpenGLView updateCulling: [[sender selectedCell] tag]];
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
