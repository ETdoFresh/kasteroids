extends Node

var collisions = []

func register_collision(collider1, collision : KinematicCollision2D):
    var collider2 = collision.collider
    for collision in collisions:
        if collision.collider1 == collider1 && collision.collider2 == collider2:
            return # Collision already registered
        if collision.collider1 == collider2 && collision.collider2 == collider1:
            return # Collision already registerd by other collider
    
    var collision_data = {}
    collision_data["collider1"] = collider1
    collision_data["collider2"] = collider2
    collision_data["position"] = collision.position
    collision_data["normal"] = collision.normal
    
    # Store copy of data at time of collision
    collision_data["collider1_data"] = { "global_position": collider1.global_position }
    if "physics" in collider1:
        collision_data["collider1_data"]["mass"] = collider1.physics.mass
        collision_data["collider1_data"]["linear_velocity"] = collider1.physics.linear_velocity
        collision_data["collider1_data"]["angular_velocity"] = collider1.physics.angular_velocity
    else:
        collision_data["collider1_data"]["mass"] = collider1.mass
        collision_data["collider1_data"]["linear_velocity"] = collider1.linear_velocity
        collision_data["collider1_data"]["angular_velocity"] = collider1.angular_velocity
    
    collision_data["collider2_data"] = { "global_position": collider2.global_position }
    if "physics" in collider2:
        collision_data["collider2_data"]["mass"] = collider2.physics.mass
        collision_data["collider2_data"]["linear_velocity"] = collider2.physics.linear_velocity
        collision_data["collider2_data"]["angular_velocity"] = collider2.physics.angular_velocity
    else:
        collision_data["collider2_data"]["mass"] = collider2.mass
        collision_data["collider2_data"]["linear_velocity"] = collider2.linear_velocity
        collision_data["collider2_data"]["angular_velocity"] = collider2.angular_velocity
    
    collisions.append(collision_data)

func resolve():
    for i in range(collisions.size() - 1, -1, -1):
        var collision = collisions[i]
        if "physics" in collision.collider1:
            collision.collider1.physics.resolve({
                "collider": collision.collider2_data, 
                "position": collision.position,
                "normal": collision.normal })
        if "physics" in collision.collider2:
            collision.collider2.physics.resolve({
                "collider": collision.collider1_data, 
                "position": collision.position,
                "normal": -collision.normal })
        collisions.remove(i)
