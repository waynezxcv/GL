

//着色器每一帧都会重新计算，无法保存静态变量

varying lowp vec4 passPosition;
varying highp vec2 passCoord;
varying highp float passTime;
varying highp float passCount;


void main() {
    
    highp float x = passCoord.x;
    highp float y = passCoord.y;
    highp float gap = (1.0/passCount);
    
    if (mod(ceil(((x + passTime)/ gap)),2.0) > 0.0) {
        if (mod(ceil((y / gap)),2.0) > 0.0) {
            gl_FragColor = vec4(0.0,0.0,0.0,1.0);
        } else {
            gl_FragColor = vec4(1.0,1.0,1.0,1.0);
        }
    } else {
        if (mod(ceil((y / gap)),2.0) > 0.0) {
            gl_FragColor = vec4(1.0,1.0,1.0,1.0);
        } else {
            gl_FragColor = vec4(0.0,0.0,0.0,1.0);
        }
    }
}
