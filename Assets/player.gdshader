shader_type canvas_item;

uniform vec3 color;

void fragment() {
    vec2 center = vec2(0.5);
    float radius = 0.5;
    float dist = distance(UV, center);
	float fadeWidth = 0.03;

  	if (dist < radius - fadeWidth) {
        COLOR = vec4(color, 1.0);
    } else if (dist < radius) {
        float alpha = 1.0 - (dist - (radius - fadeWidth)) / fadeWidth;
        COLOR = vec4(color,alpha);
    } else {
        discard;
    }
}