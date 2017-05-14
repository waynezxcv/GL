


attribute vec3 position;

varying lowp vec4 positionColor;


void main() {
    
    gl_Position = vec4(position,1.0);
    
    positionColor = vec4(0.5,0.0,0.0,1.0);
}
