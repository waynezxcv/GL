

//输入
attribute vec3 inputPosition;
attribute vec2 textureCoord;
uniform highp float globalTime;
uniform highp float columnCount;

//输出到片段着色器
varying lowp vec4 passPosition;
varying highp vec2 passCoord;
varying highp float passTime;
varying highp float passCount;


void main() {
    gl_Position = vec4(inputPosition,1.0);
    passPosition = vec4(inputPosition,1.0);
    passCoord = textureCoord;
    passTime = globalTime;
    passCount = columnCount;
}
