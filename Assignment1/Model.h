//
//  Model.h
//  Assignment1
//
//  Created by Michael Hickman on 9/24/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	float x, y, z;
} point;


typedef struct {
	point	vertex[3];
	point	normal[3];
	float	face_normal[3];
	float	color[3];
} triangle;


typedef struct {
	float		colora[3];
	float		colord[3];
	float		colors[3];
	float		shine;
} material;



@interface Model : NSObject
{
@public
	int			tri_num;
	int			material_num;
	triangle	*tri;
	material	*mat;
	
	float		minx, miny, minz, maxx, maxy, maxz;
}

- (id) initWithFile: (char*) file;
- (void) determine_bound: (int) i;

@end
