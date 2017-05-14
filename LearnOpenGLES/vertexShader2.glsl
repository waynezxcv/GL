

attribute vec3 inputVertexPosition;
attribute vec2 inputTextrueCoord;



varying highp vec3 passVertexPosition;
varying highp vec2 passTextrueCoord;


void main() {
    
    passVertexPosition = inputVertexPosition;
    passTextrueCoord = inputTextrueCoord;
    
    gl_Position = vec4(inputVertexPosition,1.0);
}
