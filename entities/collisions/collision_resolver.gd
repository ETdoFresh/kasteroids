extends Node

func bounce(self_collider, collision):
    var self_physics = self_collider.physics if "physics" in self_collider else self_collider
    var other_collider = collision.collider
    var other_physics = other_collider.physics if "physics" in other_collider else other_collider
    var ma = self_physics.mass
    var mb = other_physics.mass
    var va = self_physics.linear_velocity
    var vb = other_physics.linear_velocity
    var n = collision.normal
    var cr = self_physics.bounce_coeff # Coefficient of Restitution
    var wa = self_physics.angular_velocity
    var wb = other_physics.angular_velocity
    var ra = collision.position - self_collider.global_position
    var rb = collision.position - other_collider.global_position
    var rv = va + cross_fv(wa, ra) - vb - cross_fv(wb, rb) # Relative Velocity
    rv = va - vb
    var cv = rv.dot(n) # Contact Velocity
    var ia = ma * ra.length_squared() # Rotational Inertia
    var ib = mb * rb.length_squared() # Rotational Inertia
    var iia = 1.0 / ia
    var iib = 1.0 / ib
    var ra_x_n = cross(ra, n)
    var rb_x_n = cross(rb, n)
    var iia_ra_x_n = iia * ra_x_n
    var iib_rb_x_n = iib * rb_x_n
    var angular_denominator = cross_fv(iia_ra_x_n, ra) + cross_fv(iib_rb_x_n, rb)
    angular_denominator = angular_denominator.dot(n)
    var j = -(1.0 + cr) * cv # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb) + angular_denominator
    self_physics.linear_velocity = va + (j / ma) * n
    self_physics.angular_velocity = wa + iia * cross(ra, j * n)

func bounce_no_angular_velocity(self_collider, collision):
    self_collider = self_collider.physics if "physics" in self_collider else self_collider
    var other_collider = collision.collider
    other_collider = other_collider.physics if "physics" in other_collider else other_collider
    var ma = self_collider.mass
    var mb = other_collider.mass
    var va = self_collider.linear_velocity
    var vb = other_collider.linear_velocity
    var n = collision.normal
    var cr = self_collider.bounce_coeff # Coefficient of Restitution
    var j = -(1.0 + cr) * (va - vb).dot(n) # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb)
    self_collider.linear_velocity = va + (j / ma) * n

func cross_vf(v : Vector2, f : float):
    return Vector2(f * v.y, -f * v.x)

func cross_fv(f : float, v : Vector2):
    return Vector2(-f * v.y, f * v.x)

func cross(a : Vector2, b : Vector2):
    return a.x * b.y - a.y * b.x;
