namespace FSharp

module Domain =
    type Vec2 = { x: float; y: float }
    type Position = Vec2
    type Rotation = float
    type Scale = Vec2
    type LinearVelocity = Vec2
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
        | None
    type Objects = Object list
    type State = {
        tick: int
        objects: Objects
    }
    type Collision = {
        self: Object
        other: Object
        point: Vec2
        normal: Vec2
        remaining: Vec2
        travel: Vec2
    }
    type MovingObject = { position: Position; linearVelocity: LinearVelocity }
    type Event =
        | CreateEvent of Object
        | DeleteEvent of Object
        | CollisionEvent of Collision
