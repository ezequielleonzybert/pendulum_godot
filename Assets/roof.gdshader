shader_type canvas_item;

uniform vec4 fill_color : source_color = vec4(0.6, 0.9, 1.0, 1.0); // Cielo
uniform float line_y_threshold = 0.0; // Esta será la altura de la línea (en coordenadas locales)

void fragment() {
    // Si el fragmento está por arriba de la línea
    if (FRAGCOORD.y < line_y_threshold) {
        COLOR = fill_color;
    } else {
        discard;
    }
}
