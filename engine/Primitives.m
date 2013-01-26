#import "Primitives.h"

@implementation Primitives

void drawRect(CGRect aRect) {
	
	// Setup the array used to store the vertices for our rectangle
	GLfloat vertices[8];
	
	// Using the CGRect that has been passed in, calculate the vertices we
	// need to render the rectangle
	vertices[0] = aRect.origin.x;
	vertices[1] = aRect.origin.y;
	vertices[2] = aRect.origin.x + aRect.size.width;
	vertices[3] = aRect.origin.y;
	vertices[4] = aRect.origin.x + aRect.size.width;
	vertices[5] = aRect.origin.y + aRect.size.height;
	vertices[6] = aRect.origin.x;
	vertices[7] = aRect.origin.y + aRect.size.height;
	
	// Disable the color array and switch off texturing
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	// Set up the vertex pointer to the array of vertices we have created and
	// then use GL_LINE_LOOP to render them
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	// Switch the color array back on and enable textures.  This is the default state
	// for our game engine
	glEnableClientState(GL_COLOR_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
}

void drawCircle(Circle aCircle, uint aSegments) {

	// Set up the array that will store our vertices.  Each segment will need
	// two vertices {x, y} so we multiply the segments passedin by 2
	GLfloat vertices[aSegments*2];
	
	// Set up the counter that will track the number of vertices we will have
	int vertexCount = 0;
	
	// Loop through each segment creating the vertices for that segment and add
	// the vertices to the vertices array
	for(int segment = 0; segment < aSegments; segment++) 
	{ 
		// Calculate the angle based on the number of segments
		float theta = 2.0f * M_PI * (float)segment / (float)aSegments;

		// Calculate the x and y position of the current segment
		float x = aCircle.radius * cosf(theta);
		float y = aCircle.radius * sinf(theta);
		
		// Add the new vertices to the vertices array taking into account the circles
		// current x and y position
		vertices[vertexCount++] = x + aCircle.x;
		vertices[vertexCount++] = y + aCircle.y;
	}
	
	// Disable the color array and switch off texturing
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	// Set up the vertex pointer to the array of vertices we have created and
	// then use GL_LINE_LOOP to render them
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	// Switch the color array back on and enable textures.  This is the default state
	// for our game engine
	glEnableClientState(GL_COLOR_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

@end
