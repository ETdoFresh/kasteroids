namespace FSharp

module Domain =
    type Vector2 = { x: float; y: float}
    type Position = Vector2
    type Rotation = float
    type Scale = Vector2
    type LinearVelocity = Vector2
    type AngularVelocity = float
    type Input = {
        horizontal: float
        vertical: float
        fire: bool }
    type Ship = {
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity
        input: Input }
    type Asteroid = {
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity }
    type Bullet = {
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity }
    type Object =
        | Ship of Ship
        | Asteroid of Asteroid
        | Bullet of Bullet
    type Objects = Object list
    type State = {
        tick: int
        objects: Objects
    }
    type Collision = {
        self: Object
        other: Object
        point: Vector2
        normal: Vector2
        remaining: Vector2
        travel: Vector2
    }
    type MovingObject = { position: Position; linearVelocity: LinearVelocity }
    type Event =
        | CreateEvent of Object
        | DeleteEvent of Object
        | CollisionEvent of Collision
