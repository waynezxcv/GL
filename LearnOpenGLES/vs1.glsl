
attribute vec3 position;

varying lowp vec4 positionColor;
uniform vec4 ourColor;

void main() {
    gl_Position = vec4(position,1.0);
    
    positionColor = ourColor;
}
