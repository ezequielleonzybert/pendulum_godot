shader_type canvas_item;

void fragment() {
    vec2 center = vec2(0.5);
    float radius = 0.5;
    float dist = distance(UV, center);
	float fadeWidth = 0.02;

  	if (dist < radius - fadeWidth) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0);
    } else if (dist < radius) {
        float alpha = 1.0 - (dist - (radius - fadeWidth)) / fadeWidth;
        COLOR = vec4(1.0, 0.0, 0.0, alpha);
    } else {
        discard;
    }
}