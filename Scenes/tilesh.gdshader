shader_type canvas_item;

uniform float speed : hint_range(-10, 10) = 1.0; // Velocidade de deslocamento
uniform float amplitude : hint_range(0, 1) = 0.1; // Amplitude do deslocamento

void fragment() {
    vec2 offset = vec2(cos(TIME * speed), sin(TIME * speed)) * amplitude;
    vec2 uv = FRAGCOORD.xy / vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    vec4 texcol = texture(TEXTURE, uv + offset);
    COLOR = texcol;
}