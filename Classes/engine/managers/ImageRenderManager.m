#import "ImageRenderManager.h"
#import "Image.h"
#import "GameController.h"

#pragma mark -
#pragma mark Private interface

@interface ImageRenderManager (Private) 
// Method used when an Image is instantiated.  It reserves a location within the render
// managers IVA for this image and passes back a pointer to the TexturedColoredQuad
// structure within the IVA.
- (void)copyImageDetails:(ImageDetails*)aImageDetails;

// Method used toadd a texture name to the list of textures that will be used to render the
// current contents of the render queue.
- (void)addToTextureList:(uint)aTextureName;
@end

#pragma mark -
#pragma mark Public implementation

@implementation ImageRenderManager

// Make this class a singleton lass
SYNTHESIZE_SINGLETON_FOR_CLASS(ImageRenderManager);

- (void)dealloc {
	if (iva)
		free(iva);
	if (ivaIndices)
		free(ivaIndices);
    [super dealloc];
}

- (id)init {
    if(self = [super init]) {
        
        // Initialize the vertices array.
        iva = calloc(kMax_Images, sizeof(TexturedColoredQuad));
        
        // Initialize the indices array.  This array will be used to specify the indexes into
        // the interleaved vertex array.  This array will allow us to just specify the specific
        // interleaved array elements we want glDrawElements to render.  We multiply by 6 as
        // we are using GL_TRIANGLE to render and we therefore define two triangles each with 
        // three vertices to make a quad.
        ivaIndices = calloc(kMax_Images * 6, sizeof(GLushort));
        
        // Initialize the IVA index
        ivaIndex = 0;
        
        // Initialize the texture to render count
        renderTextureCount = 0;
		
		// Initialize the contents of the imageCountForTexture array. We want to make sure that
		// the memory contents for this array are clean before we get started.
		memset(imageCountForTexture, 0, kMax_Images);
     }
    return self;
}

- (void)addImageDetailsToRenderQueue:(ImageDetails*)aImageDetails {
    
	// Copy the imageDetails to the render managers IVA
	[self copyImageDetails:aImageDetails];
	
	// Add the texture used for this image to the list of textures to be rendered
	[self addToTextureList:aImageDetails->textureName];
	
	// As we have added an images details to the render queue we need to increment the iva index
	ivaIndex++;
}

- (void)addTexturedColoredQuadToRenderQueue:(TexturedColoredQuad*)aTCQ texture:(uint)aTexture {
	memcpy((TexturedColoredQuad*)iva + ivaIndex, aTCQ,sizeof(TexturedColoredQuad));
	
	// Add the texture used for this image to the list of textures to be rendered
	[self addToTextureList:aTexture];
	
	// As we have added a TexturedColoredQuad to the render queue we need to increment the iva index
	ivaIndex++;
}

- (void)renderImages {
    
    // Populate the vertex, texcoord and colorpointers with our interleaved vertex data
    glVertexPointer(2, GL_FLOAT, sizeof(TexturedColoredVertex), &iva[0].geometryVertex);
    glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedColoredVertex), &iva[0].textureVertex);
    glColorPointer(4,GL_FLOAT,sizeof(TexturedColoredVertex), &iva[0].vertexColor);

    // Loop through the texture index array rendering the images as necessary
    for(NSInteger textureIndex=0; textureIndex<renderTextureCount; textureIndex++) {
		
        // Bind to the textureName of the current texture.  This is the key of the texture
        // structure
        glBindTexture(GL_TEXTURE_2D, texturesToRender[textureIndex]);
		
        // Init the vertex counter.  This will be used to identify how many elements need to be used
        // within the indices array.
        int vertexCounter=0;
		
        for(NSInteger imageIndex=0; imageIndex<imageCountForTexture[texturesToRender[textureIndex]]; imageIndex++) {
            // Set the indicies array to point to IVA entries for the image being processed
            // We are using GL_TRIANGLES so we construct two triangles from the vertices we
            // have inside the IVA for each image quad. Four vertices per quad so increment the vertex counter
            NSUInteger index = textureIndices[texturesToRender[textureIndex]][imageIndex] * 4;
            ivaIndices[vertexCounter++] = index;     // Bottom left
            ivaIndices[vertexCounter++] = index+2;   // Top Left
            ivaIndices[vertexCounter++] = index+1;   // Bottom right
            ivaIndices[vertexCounter++] = index+1;   // Bottom right
            ivaIndices[vertexCounter++] = index+2;   // Top left
            ivaIndices[vertexCounter++] = index+3;   // Top right
        }
        
        // Now we have loaded the indices array with indexes into the IVA, we draw those triangles
        glDrawElements(GL_TRIANGLES, vertexCounter, GL_UNSIGNED_SHORT, ivaIndices);
        
        // Clear the quad count for the current texture
        imageCountForTexture[texturesToRender[textureIndex]] = 0;
    }
    
    // Reset the number of textures which need to be rendered
    renderTextureCount = 0;
	
	// Reset the ivaIndex so that we start to load the next set of images from the start of the IVA.
	ivaIndex = 0;
}

@end

#pragma mark -
#pragma mark Private implementation

@implementation ImageRenderManager (Private)

- (void)copyImageDetails:(ImageDetails*)aImageDetails {
	
    // Check to make sure that we have not exceeded the maximum size of the render queue.  If the queue size
	// is exceeded then render the images that are currently in the render managers queue.  This resets the
	// queue and allows the image to be added to the render managers then empty queue.
    if(ivaIndex + 1 > kMax_Images) {
        NSLog(@"ERROR - RenderManager: Render queue size exceeded.  Consider increasing the default size. %d", ivaIndex + 1);
		[self renderImages];
    }
	
    // Point the texturedColoredQuadIVA to the current location in the render managers IVA queue
    aImageDetails->texturedColoredQuadIVA = (TexturedColoredQuad*)iva + ivaIndex;
    
    // Copy the images base texturedColoredQuad into the assigned IVA index.  This is necessary to make sure
	// the texture and color informaiton is loaded into the IVA.  The geometry from the image is loaded
	// when the image is transformed within the Image render method.
    memcpy(aImageDetails->texturedColoredQuadIVA, aImageDetails->texturedColoredQuad,sizeof(TexturedColoredQuad));
}


- (void)addToTextureList:(uint)aTextureName {

	// Check to see if the texture for this image has already been added to the queue
    BOOL textureFound = NO;
    for(int index=0; index<renderTextureCount; index++) {
        if(texturesToRender[index] == aTextureName) {
            textureFound = YES;
            break;
        }
    }
    
	if(!textureFound)
        // This is the first time this texture has been placed on the queue, so add this texture to the
        // texturesToRender array
        texturesToRender[renderTextureCount++] = aTextureName;
	
    // Add this new images ivaIndex to the textureIndices array
    textureIndices[aTextureName][imageCountForTexture[aTextureName]] = ivaIndex;
	
	// Up the image count for the texture we have just processed
	imageCountForTexture[aTextureName] += 1; 
}

@end
