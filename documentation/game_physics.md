# Game Physics

I decided not to use RigidBodies after a week or two of trying to get it working with a network engine. The problem I have is: I need to "simulate" the world, but I don't have any access to a Step() function as of Godot 3.2.2... I need to try different options... So, we're going to use KinematicBodies.

## Custom Kinematic Body 2D: The New Rigid Body 2D

To use Kinematic Bodies, we still need a collision shape.... and the rest... well, that's up to us! So, I'm going to try to emulate the rigid body behavior that we had previous. This is what we'll need.

### Data

- **Linear Velocity** : *Vector2* - How much does an object move per second
- **Angular Velocity** : *float* - How much does an object rotate per second
- **Max Linear Velocity** : *float* - Objects will never move faster than this speed
- **Max Angular Velocity** : *float* - Objects will never rotate faster than this speed

And, yeah. That' about it! Physics! Well, at least the data part of it.

### Process(delta_time)/Simulate(delta_time)

Now that we have the data, the formulas to update position and rotation are quite simple per frame.

> `global_position = linear_velocity * delta_time`
> `global_rotation = angular_velocity * delta_time`

If we want to enforce the max velocities, we can simply check if the velocities are too high, and if so, clamp it at max [before applying the velocities].

> `if linear_velocity.length() > max_linear_velocity:
> 	linear_velocity = linear_velocity.normalize() * max_linear_velocity`
>
> `if abs(angular_velocity) < max_angular_velocity:`
> 	angular_velocity = sign(angular_velocity) * max_angular_velocity

And done!

### Simulate(delta_time) Addendum: Acceleration

In our game, there is only one type of object that accelerates, and that's Ship. So we have to add acceleration to the ship, and that's simple adding another "layer" if you will:

> `linear_acceleration = some_input * acceleration_rate
> linear_velocity += linear_acceleration`

### Collision

We have pretty much a sandbox. There's nothing right now that really happens when things collide. Well, game-wise that is. Physically, we expect them to bounce or crash into objects with physical reactions. RigidBodies excel at this. However, we are on our own here, and we'll just have to do our best. Here's what I got...

First off, I think each object will have different weights/masses. Hence, I think I'll go ahead and assign weights to each physical object.

Then when the collision actually occurs, we have multiple variables to consider: massA, massB, velA, velB, point, collision.normal.

At this point, we want to apply an impulse toward the normal... but how much towards each normal?

massA x NewVelA = massA x velA + impulseMag x normal

or 

new velocity = initial velocity + (imp/mass)*normal

...

basically, this is gold....

[http://www.cs.uu.nl/docs/vakken/mgp/2014-2015/Lecture%207%20-%20Collision%20Resolution.pdf](http://www.cs.uu.nl/docs/vakken/mgp/2014-2015/Lecture 7 - Collision Resolution.pdf)

### Energy

E = 1/2 * mass * velocity^2

When a collision happens, the total energy should be considered and transferred appropriately.