shader_type spatial;

// Set via script
uniform vec3 color : source_color;
uniform float sourceEmission = 1.0;

// Top band of normal values to
uniform float normalLimit = 0.1;
uniform float fadeOff = 0.5;
uniform float power = 0.1;

void fragment() {
	// Get dot product of vertex normal and forward vector
	// (1.0 at poles, 0.0 at edges)
	vec3 forward = vec3(0.0, 0.0, 1.0);
	float normalDot = abs(dot(NORMAL, forward));

	// Scale the normals so that 0.0 -> limit becomes 0.0 -> 1.0
	float limit = 1.0 / normalLimit;
	float activeNormal = min(mix(0.0, limit, normalDot), 1.0);

	// Get inverse (0.0 at poles, 1.0 at edges)
	float invNormal = 1.0 - activeNormal;

	// Radial pan (in/out from center)
	float fadedAlpha = max(invNormal - fadeOff, 0.0);
	// Fade normal value
	float alpha = pow(fadedAlpha, power);

	ALPHA = alpha;
	EMISSION = color * sourceEmission;
}
