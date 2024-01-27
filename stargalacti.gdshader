shader_type spatial;
render_mode cull_disabled;

// Uniforms for directional light
uniform vec3 light_direction = vec3(0.0, -1.0, 0.0);
uniform vec4 light_color;
uniform float time_of_day = 0.5; // Ranges from 0.0 (night) to 1.0 (day)

// Noise texture for cloud generation
uniform sampler2D noise_texture;

void vertex() {
    // Vertex shader logic, if necessary
}

vec3 getCloudColor(vec3 position, vec3 lightDir) {
    // Simple example of how cloud color might be calculated
    float density = texture(noise_texture, position.xy).r;
    vec3 cloudColor = mix(vec3(0.2, 0.2, 0.3), vec3(1.0, 1.0, 1.0), density);
    float lightFactor = max(dot(normalize(lightDir), normalize(position)), 0.0);
    return cloudColor * lightFactor * light_color.rgb;
}

void fragment() {
    vec3 position = VERTEX; // Assuming clouds are being rendered onto some geometry
    vec3 lightDir = normalize(light_direction);

    // Calculate cloud color based on noise and light
    vec3 cloudColor = getCloudColor(position, lightDir);

    // Implement day/night cycle by interpolating cloud color
    vec3 finalColor = mix(cloudColor * 0.5, cloudColor, time_of_day);
    
    ALBEDO = finalColor;
}