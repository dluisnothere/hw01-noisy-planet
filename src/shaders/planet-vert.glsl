#version 300 es

// //This is a vertex shader. While it is called a "shader" due to outdated conventions, this file
// //is used to apply matrix transformations to the arrays of vertex data passed to it.
// //Since this code is run on your GPU, each vertex is transformed simultaneously.
// //If it were run on your CPU, each vertex would have to be processed in a FOR loop, one at a time.
// //This simultaneous transformation allows your program to run much faster, especially when rendering
// //geometry with millions of vertices.

// uniform mat4 u_Model;       // The matrix that defines the transformation of the
//                             // object we're rendering. In this assignment,
//                             // this will be the result of traversing your scene graph.

// uniform mat4 u_ModelInvTr;  // The inverse transpose of the model matrix.
//                             // This allows us to transform the object's normals properly
//                             // if the object has been non-uniformly scaled.

// uniform mat4 u_ViewProj;    // The matrix that defines the camera's transformation.
//                             // We've written a static matrix for you to use for HW2,
//                             // but in HW3 you'll have to generate one yourself

// in vec4 vs_Pos;             // The array of vertex positions passed to the shader

// in vec4 vs_Nor;             // The array of vertex normals passed to the shader

// in vec4 vs_Col;             // The array of vertex colors passed to the shader.

// out vec4 fs_Nor;            // The array of normals that has been transformed by u_ModelInvTr. This is implicitly passed to the fragment shader.
// out vec4 fs_LightVec;       // The direction in which our virtual light lies, relative to each vertex. This is implicitly passed to the fragment shader.
// out vec4 fs_Col;            // The color of each vertex. This is implicitly passed to the fragment shader.
// out vec4 fs_Pos;

// const vec4 lightPos = vec4(5, 5, 3, 1); //The position of our virtual light, which is used to compute the shading of
//                                         //the geometry in the fragment shader.

// float random3D(vec3 p) {
//     return sin(length(vec3(fract(dot(p, vec3(61.1, 21.8, 60.2))), 
//                             fract(dot(p, vec3(20.5, 61.3, 60.4))),
//                             fract(dot(p, vec3(61.4, 61.2, 22.5))))) * 45.6);
// }

// float interpolateNoise3D(float x, float y, float z)
// {
//     int intX = int(floor(x));
//     float fractX = fract(x);
//     int intY = int(floor(y));
//     float fractY = fract(y);
//     int intZ = int(floor(z));
//     float fractZ = fract(z);

//     float v1 = random3D(vec3(intX, intY, intZ));
//     float v2 = random3D(vec3(intX + 1, intY, intZ));
//     float v3 = random3D(vec3(intX, intY + 1, intZ));
//     float v4 = random3D(vec3(intX + 1, intY + 1, intZ));

//     float v5 = random3D(vec3(intX, intY, intZ + 1));
//     float v6 = random3D(vec3(intX + 1, intY, intZ + 1));
//     float v7 = random3D(vec3(intX, intY + 1, intZ + 1));
//     float v8 = random3D(vec3(intX + 1, intY + 1, intZ + 1));


//     float i1 = mix(v1, v2, fractX);
//     float i2 = mix(v3, v4, fractX);

//     //mix between i1 and i2
//     float i3 = mix(i1, i2, fractY);

//     float i4 = mix(v5, v6, fractX);
//     float i5 = mix(v7, v8, fractX);

//     //mix between i3 and i4
//     float i6 = mix(i4, i5, fractY);

//     //mix between i3 and i6
//     float i7 = mix(i3, i6, fractZ);

//     return i7;
// }

// float fbmNoise(float x, float y, float z)
// {
//     float total = 0.0;
//     float persistence = 0.3;
//     float frequency = 1.0;
//     float amplitude = 1.5;
//     int octaves = 2;

//     for (int i = 1; i <= octaves; i++) {
//         total += amplitude * interpolateNoise3D(frequency * x, frequency * y, frequency * z);
//         frequency *= 4.0;
//         amplitude *= persistence;
//     }
//     return total;
// }

// vec4 convertRGB(float r, float g, float b)
// {
//     return (vec4(vec3(r,g,b) / 255.0, 1.0));
// }

// void main()
// {
//     fs_Col = vs_Col;                         // Pass the vertex colors to the fragment shader for interpolation

//     mat3 invTranspose = mat3(u_ModelInvTr);
//     fs_Nor = vec4(invTranspose * vec3(vs_Nor), 0);          // Pass the vertex normals to the fragment shader for interpolation.
//                                                             // Transform the geometry's normals by the inverse transpose of the
//                                                             // model matrix. This is necessary to ensure the normals remain
//                                                             // perpendicular to the surface after the surface is transformed by
//                                                             // the model matrix.
//     vec4 temp = vec4(normalize(vec3(vs_Pos.xyz)), 1.0);

//     vec4 modelposition = u_Model * vs_Pos;   // Temporarily store the transformed vertex positions for use below

//     // float fbm = fbmNoise(modelposition.x, modelposition.y, modelposition.z);
    
//     // if (fbm < 0.5) {
//     //     fbm = 0.5;
//     // }
//     // vec4 perturbedVec = fbm * vs_Nor;
//     // vec4 noisedVec = perturbedVec + modelposition;

//     // fs_Pos = noisedVec;
//     fs_Pos = vs_Pos;


//     fs_LightVec = lightPos - modelposition;  // Compute the direction in which the light source lies

//     gl_Position = u_ViewProj * modelposition;// gl_Position is a built-in variable of OpenGL which is
//                                              // used to render the final positions of the geometry's vertices
// }

//This is a vertex shader. While it is called a "shader" due to outdated conventions, this file
//is used to apply matrix transformations to the arrays of vertex data passed to it.
//Since this code is run on your GPU, each vertex is transformed simultaneously.
//If it were run on your CPU, each vertex would have to be processed in a FOR loop, one at a time.
//This simultaneous transformation allows your program to run much faster, especially when rendering
//geometry with millions of vertices.

uniform mat4 u_Model;       // The matrix that defines the transformation of the
                            // object we're rendering. In this assignment,
                            // this will be the result of traversing your scene graph.

uniform mat4 u_ModelInvTr;  // The inverse transpose of the model matrix.
                            // This allows us to transform the object's normals properly
                            // if the object has been non-uniformly scaled.

uniform mat4 u_ViewProj;    // The matrix that defines the camera's transformation.
                            // We've written a static matrix for you to use for HW2,
                            // but in HW3 you'll have to generate one yourself

uniform highp int u_Time;

in vec4 vs_Pos;             // The array of vertex positions passed to the shader

in vec4 vs_Nor;             // The array of vertex normals passed to the shader

in vec4 vs_Col;             // The array of vertex colors passed to the shader.

out vec4 fs_Nor;            // The array of normals that has been transformed by u_ModelInvTr. This is implicitly passed to the fragment shader.
out vec4 fs_LightVec;       // The direction in which our virtual light lies, relative to each vertex. This is implicitly passed to the fragment shader.
out vec4 fs_Col;            // The color of each vertex. This is implicitly passed to the fragment shader.
out vec4 fs_Pos;

const vec4 lightPos = vec4(5, 5, 3, 1); //The position of our virtual light, which is used to compute the shading of
                                        //the geometry in the fragment shader.

float random3D(vec3 p) {
    return sin(length(vec3(fract(dot(p, vec3(161.1, 121.8, 160.2))), 
                            fract(dot(p, vec3(120.5, 161.3, 160.4))),
                            fract(dot(p, vec3(161.4, 161.2, 122.5))))) * 43579.90906);
}


float interpolateNoise3D(float x, float y, float z)
{
    int intX = int(floor(x));
    float fractX = fract(x);
    int intY = int(floor(y));
    float fractY = fract(y);
    int intZ = int(floor(z));
    float fractZ = fract(z);

    float v1 = random3D(vec3(intX, intY, intZ));
    float v2 = random3D(vec3(intX + 1, intY, intZ));
    float v3 = random3D(vec3(intX, intY + 1, intZ));
    float v4 = random3D(vec3(intX + 1, intY + 1, intZ));

    float v5 = random3D(vec3(intX, intY, intZ + 1));
    float v6 = random3D(vec3(intX + 1, intY, intZ + 1));
    float v7 = random3D(vec3(intX, intY + 1, intZ + 1));
    float v8 = random3D(vec3(intX + 1, intY + 1, intZ + 1));


    float i1 = mix(v1, v2, fractX);
    float i2 = mix(v3, v4, fractX);

    //mix between i1 and i2
    float i3 = mix(i1, i2, fractY);

    float i4 = mix(v5, v6, fractX);
    float i5 = mix(v7, v8, fractX);

    //mix between i3 and i4
    float i6 = mix(i4, i5, fractY);

    //mix between i3 and i6
    float i7 = mix(i3, i6, fractZ);

    return i7;
}

float fbmNoise(float x, float y, float z)
{
    float total = 0.0;
    float persistence = 0.3;
    float frequency = 2.0;
    float amplitude = 3.0;
    int octaves = 5;

    for (int i = 1; i <= octaves; i++) {
        total += amplitude * interpolateNoise3D(frequency * x, frequency * y, frequency * z);
        frequency *= 3.0;
        amplitude *= persistence;
    }
    return total;
}

float getBias(float time, float bias)
{
  return (time / ((((1.0/bias) - 2.0)*(1.0 - time))+1.0));
}

float getGain(float time, float gain)
{
    if(time < 0.5) {
        return getBias(time * 2.0, gain) / 2.0;
    } else {
        return getBias(time * 2.0 - 1.0,1.0 - gain)/2.0 + 0.5;
    }
}

void main()
{
    fs_Col = vs_Col;                         // Pass the vertex colors to the fragment shader for interpolation

    mat3 invTranspose = mat3(u_ModelInvTr);
    fs_Nor = vec4(invTranspose * vec3(vs_Nor), 0);          // Pass the vertex normals to the fragment shader for interpolation.
                                                            // Transform the geometry's normals by the inverse transpose of the
                                                            // model matrix. This is necessary to ensure the normals remain
                                                            // perpendicular to the surface after the surface is transformed by
                                                            // the model matrix.


    vec4 modelposition = u_Model * vs_Pos;   // Temporarily store the transformed vertex positions for use below

    fs_LightVec = lightPos - modelposition;  // Compute the direction in which the light source lies

    gl_Position = u_ViewProj * modelposition;// gl_Position is a built-in variable of OpenGL which is
                                             // used to render the final positions of the geometry's vertices
    //begin tinkering

    // vec3 noiseInput = modelposition.xyz;
    // noiseInput *= 1.0;
    // noiseInput += sin(float(u_Time) * 0.001);

    // vec3 noise = fbmNoise(noiseInput.x, noiseInput.y, noiseInput.z) * noiseInput;
    
    // float noiseScale = noise.r;

    // if (noise.r < 0.5) {
    //     noiseScale = 0.1;
    // }

    // vec3 offsetAmount = vec3(vs_Nor) * noiseScale;
    // vec3 noisyModelPosition = modelposition.xyz + 0.075 * offsetAmount;

    gl_Position = u_ViewProj * modelposition;

    fs_Pos = vs_Pos;

}