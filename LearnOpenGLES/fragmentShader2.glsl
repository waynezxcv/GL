


varying highp vec3 passVertexPosition;
varying highp vec2 passTextrueCoord;

uniform sampler2D colorMap1;//取样器
uniform sampler2D colorMap2;//取样器


void main() {
    gl_FragColor = mix(texture2D(colorMap1, passTextrueCoord), texture2D(colorMap2, passTextrueCoord),0.2);    
}
