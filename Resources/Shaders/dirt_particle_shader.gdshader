shader_type particles;
render_mode disable_velocity;

uniform vec2 start_position;
uniform vec2 target_position;

#define RANDOM_SOURCE vec2((float(NUMBER % 31u)) / 31.,(float(NUMBER % 19u)) / 19.)

const float SPEED = 2.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 velocity_variation(vec2 vec) {
    //     return vec2(random(xy) - 0.5, random(vec2(xy.y, xy.x)) - 0.5);
    return vec2(
        random(vec.xy),
        random(vec2(vec.y, vec.x))
    );
}


void start() {
    vec2 random_source = RANDOM_SOURCE;
    // dark would be #471e4c
    float r = float(0xf7);
    float g = float(0xb5);
    float b = float(0x8c);
    COLOR = vec4(r / 255., g / 255., b / 255., 1);
    //     COLOR = vec4(1, 0, 0, 1);
    vec2 vel_var = velocity_variation(random_source) * SPEED;
    VELOCITY.xy = vec2(vel_var.x, -vel_var.y);
    TRANSFORM[3].xy = start_position;
}

void process() {
    //     vec2 random_source = RANDOM_SOURCE;
    vec2 transform = CUSTOM.xy;


    //     TRANSFORM[3].xy = target_position + velocity_variation(vec2(float(NUMBER), 0));
    if (VELOCITY.y <= 0. && TRANSFORM[3].y > target_position.y) {
        VELOCITY.y -= SPEED * DELTA;
    }
        else if (VELOCITY.y < 0. || TRANSFORM[3].y < target_position.y) {
            VELOCITY.x = (target_position.x - TRANSFORM[3].x) * DELTA * SPEED;
            VELOCITY.y += SPEED * DELTA;
        }
            else {
                ACTIVE = false;
            }
    //         VELOCITY.xy += velocity_variation(random_source) * DELTA * SPEED;

    transform += VELOCITY.xy;
    CUSTOM.xy = transform;
    transform.x = round(transform.x - .5) + .5;
    transform.y = round(transform.y - .5) + .5;
    TRANSFORM[3].xy = transform;
}