#import <OpenGLES/ES1/gl.h>

@class Image;

#pragma mark -
#pragma mark Type structures

// Structure that defines the elements which make up a color
typedef struct {
	float red;
	float green;
	float blue;
	float alpha;
} Color4f;

// Structure that defines a vector using x and y
typedef struct {
	GLfloat x;
	GLfloat y;
} Vector2f;

// Structure to hold the x and y scale
typedef struct {
    float x;
    float y;
} Scale2f;

// Structure to hold the tilemap Geometry and texture vertices
typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

// Stores information about an images quad and texture details.  Used when getting
// quad and texture information from an image
typedef struct {
    TexturedVertex vertex1;
    TexturedVertex vertex2;
    TexturedVertex vertex3;
    TexturedVertex vertex4;
} TexturedQuad;

// Stores geometry, texture and colour information for a single vertex
typedef struct {
    CGPoint geometryVertex;
    Color4f vertexColor;
    CGPoint textureVertex;
} TexturedColoredVertex;

// Stores 4 TexturedColoredVertex structures needed to define a quad
typedef struct {
    TexturedColoredVertex vertex1;
    TexturedColoredVertex vertex2;
    TexturedColoredVertex vertex3;
    TexturedColoredVertex vertex4;
} TexturedColoredQuad;

// Stores information about each image which is created.  texturedColoredQuad
// holds the original zero origin quad for the image and the texturedColoredQuadIVA
// holds a pointer to the images entry within the render managers IVA
typedef struct {
    TexturedColoredQuad *texturedColoredQuad;
    TexturedColoredQuad *texturedColoredQuadIVA;
    GLuint textureName;
} ImageDetails;

// Stores a single frame of an animation which is used within the Animation class
typedef struct {
    Image *image;
    float delay;
} AnimationFrame;

// Stores the tile coordinates for each vertex in a bounding rectangle
typedef struct {
	float x1, y1;
	float x2, y2;
	float x3, y3;
	float x4, y4;
} BoundingBoxTileQuad;

// Stores portal objects found in the tilemap
typedef struct {
	NSString *name;
	NSString *type;
	float x;
	float y;
	float dest_x;
	float dest_y;
} PortalObject;

typedef struct {
	int x;
	int y;
} Position;

// Structure used to hold details of a circle
typedef struct {
	float x;
	float y;
	float radius;
} Circle;
