shader_type particles;
render_mode disable_velocity;

uniform vec2 target_position;

const float SPEED = 2.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 velocity_variation(vec2 xy) {
    return vec2(random(xy) - 0.5, random(vec2(xy.y, xy.x)) - 0.5);
}


void start() {
    // dark would be #471e4c
    float r = float(0xf7);
    float g = float(0xb5);
    float b = float(0x8c);
    COLOR = vec4(r / 255., g / 255., b / 255., 1);
//     COLOR = vec4(1, 0, 0, 1);
}

void process() {
    //         TRANSFORM[3].xy = target_position + velocity_variation(vec2(float(NUMBER), 0));
    if (VELOCITY.y <= 0. && TRANSFORM[3].y > target_position.y) {
        VELOCITY.y -= SPEED * DELTA;
    } else if (VELOCITY.y < 0. || TRANSFORM[3].y < target_position.y) {
        VELOCITY.x = (target_position.x - TRANSFORM[3].x) * DELTA * SPEED;
        VELOCITY.y += SPEED * DELTA;
    } else {
        ACTIVE = false;
    }
    VELOCITY.xy += velocity_variation(TRANSFORM[3].xy) * DELTA;

    vec4 transform = TRANSFORM[3];
    transform.xy += VELOCITY.xy;
    transform.x = round(transform.x - .5) + .5;
    transform.y = round(transform.y - .5) + .5;
    TRANSFORM[3] = transform;
}