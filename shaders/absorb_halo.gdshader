shader_type spatial;

// Set via script
uniform vec3 color : source_color;
uniform float sourceEmission = 1.0;
uniform bool showRings = true;

// For generic alpha calculation
uniform float normalLimit = 0.1;
uniform float fadeOff = 0.5;
uniform float power = 0.1;

// For ring offset
uniform int ringCount = 4;
uniform float ringSpeed = 0.8;
uniform float ringAlphaMult = 0.8;

float getAlpha(float normalDot) {
	// Scale the normals so that 0.0 -> limit becomes 0.0 -> 1.0
	float limit = 1.0 / normalLimit;
	float activeNormal = min(mix(0.0, limit, normalDot), 1.0);

	// Get inverse (0.0 at poles, 1.0 at edges)
	float invNormal = 1.0 - activeNormal;

	// Radial pan (in/out from center)
	float fadedAlpha = max(invNormal - fadeOff, 0.0);
	// Fade normal value
	return pow(fadedAlpha, power);
}

float getRingAlpha(float normalDot) {
	float totalAlpha = 0.0;
	float offset = 1.0 / float(ringCount);
	float timeOffset = TIME * ringSpeed;

	// For each ring, add offset and get alpha
	for (int i = 0; i < ringCount; i++) {
		float ringOffset = offset * float(i);
		float ringInput = fract(normalDot + ringOffset + timeOffset);
		totalAlpha += getAlpha(ringInput) * ringAlphaMult * (1.0 - normalDot);
	}

	return totalAlpha;
}

void fragment() {
	// Get dot product of vertex normal and forward vector
	// (1.0 at poles, 0.0 at edges)
	vec3 forward = vec3(0.0, 0.0, 1.0);
	float normalDot = abs(dot(NORMAL, forward));

	// Get rim alpha
	float rimAlpha = getAlpha(normalDot);

	// Get ring alpha
	float ringAlpha = getRingAlpha(normalDot) * float(showRings);

	float alpha = min(1.0, rimAlpha + ringAlpha);

	ALPHA = alpha;
	EMISSION = color * sourceEmission;
}
