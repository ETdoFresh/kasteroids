# World State Serialization

In this document, we'll talk about how the game world is going to be serialized and updated. First let's talk about how each individual object is going to be serialized.

### Ship

- Ship : Dictionary
  - Type : String = "Ship"
  - Position : Vector2
  - Rotation : float
  - Scale : Vector2
  - Name : string
  - Linear Velocity : Vector2
  - Angular Velocity : float

### Asteroid

- Asteroid : Dictionary
  - Type : String = "Asteroid"
  - Position : Vector2
  - Rotation : float
  - Scale : Vector2
  - Linear Velocity : Vector2
  - Angular Velocity : float

### Bullet

- Bullet : Dictionary
  - Type : String = "Bullet"
  - Position : Vector2
  - Rotation : float
  - Scale : Vector2
  - Linear Velocity : Vector2
  - Angular Velocity : float
  - Initial Position : Vector2
  - Ending Position : Vector2

## Worlds

### Local World

This is running on a client machine. There are no connections into or out of this world. There will be a ship and asteroids placed at predetermined location via human creator or AI. A *world.simulate()* function runs every **Settings.tick_rate** seconds. The serialization of this world would look like this.

- World : Dictionary
  - Objects : Array
    - Ship : Dictionary
    - Asteroid1 : Dictionary
    - Asteroid2 : Dictionary
    - Asteroid3 : Dictionary
    - Asteroid4 : Dictionary

One aspect of the world simulation is that it is update not only by the physics simulation, but by user input. Hence the:

```pseudocode
Next_World_State = Physics(Game_Logic(World_State, Player_Input))
```

In other words, the next world state is determined by physics engine and game logic taking into account current state + player input. We'll see more of this later.

### Server  World

This world is running on a server machine. It will initially consist of only the game world. There will be no ships and only asteroids placed when this world is initiated. A *world.simulate()* function runs every **Settings.tick_rate** seconds.

- World : Dictionary
  - Type: String = "Update"
  - Tick : int
  - Objects : Array
    - Asteroid1 : Dictionary
    - Asteroid2 : Dictionary
    - Asteroid3 : Dictionary
    - Asteroid4 : Dictionary

For each Client that connects, a Ship and Network Input will be created. After a client connects, the world will included additional client information.

- World : Dictionary
  - Type: String = "Update"
  - Tick : int
  - Client : Dictionary

    - Last Received Tick : float
    - Time Since Last Received : float
    - Ship Id : int
    - Username: String
  - Objects : Array
    - Asteroid1 : Dictionary
    - Asteroid2 : Dictionary
    - Asteroid3 : Dictionary
    - Asteroid4 : Dictionary
    - Ship : Dictionary

### Packet World

This is a client-side world which will simply represent the incoming data from the server. No post processing. No game logic. No physics. No filtering. Just a visualization of incoming packets. The data is exactly the same as **Server World**. However, for presentation, only the *World/Objects* data are considered. The objects shown in this world are operating at a time that is less than **Server World** time. In other words, **Packet World** is in the past due to serialization and network latency.

### Server Tick Prediction

We want to discuss more worlds that the client can show. However, before we can, the client must understand the timing of the server world. There is network delay to consider. The server might run a bit fast. The client might run a bit slow. These factors all affect the timing of how worlds are to be simulated and synced. So keeping them in sync is a hard task. Here are some factors we will consider on the client side to best predict timing.

- **Received Server Tick**: The tick that was most recently reported by the server [note: this tick is slightly in the past]
- **Received Client Tick**: The tick that was last received by the server [note: this tick is slightly more in the past]
- **Server Offset**: The time since client tick was received by the server and the server sends the update packet [typically a very small amount of time]
- **Return Trip Time (RTT)**: Given *Received Client Tick* and *Server Offset*, we can determine the pure network delay, or the time for packet to go the server and back.
- **Delay**: *RTT* divided by 2. This is the duration for a packet to leave the server and arrive at the client.
- **Predicted Tick**: The tick the client guesses that the server is currently on.
- **Receive Count per Second**: The number of update packets per second received by client
- **Receive Rate**: 1 / *Receive Count per Second*, or seconds between receiving each packet

### Interpolation World (Linear)

This is a client-side world operating even slightly more in the past than **Packet World** due to smoothing between second-to-last packet and the last-packet received (no physics or game logic). Ideally, we want **Interpolation World** to occur at `interpolation_tick = predicted_tick - delay - receive_rate`. Here is an example of one value being interpolated. Please note these are not real world values, and will not look this nice! :)

| Server Tick | Value   | Received Server Tick | Delay (in ticks) | Receive Rate (in ticks) | Predicted Tick | Interpolated Tick | Received Value | Interpolated Value |
| ----------- | ------- | -------------------- | ---------------- | ----------------------- | -------------- | ----------------- | -------------- | ------------------ |
| 1           | 0.1     | *null*               | *null*           | *null*                  | *null*         | *null*            | *null*         | *null*             |
| **1.5**     | **0.2** | **1**                | **0.5**          | **1**                   | **1.5**        | ***null***        | **0.1**        | ***null***         |
| 2           | 0.3     | 1                    | 0.5              | 1                       | 2              | *null*            | 0.1            | *null*             |
| **2.5**     | **0.4** | **2**                | **0.5**          | **1**                   | **2.5**        | **1**             | **0.3**        | **0.1**            |
| 3           | 0.5     | 2                    | 0.5              | 1                       | 3              | 1.5               | 0.3            | 0.2                |
| **3.5**     | **0.6** | **3**                | **0.5**          | **1**                   | **3.5**        | **2**             | **0.5**        | **0.3**            |
| 4           | 0.7     | 3                    | 0.5              | 1                       | 4              | 2.5               | 0.5            | 0.4                |
| **4.5**     | **0.8** | **4**                | **0.5**          | **1**                   | **4.5**        | **3**             | **0.7**        | **0.5**            |
| 5           | 0.9     | 4                    | 0.5              | 1                       | 5              | 3.5               | 0.7            | 0.6                |

**Bold** - Received Packet

### Client Input

Based on what we seen in the beginning, we can infer the server has similar formula for calculating next world state.

```pseudocode
Next_World_State = Physics(Game_Logic(World_State, Player1_Input, Player2_Input, ...))
```

But, in terms of timing, how does this work? With no modifications, here are the server values for generating a world:

| Server Tick | Client 1 Tick | Client 2 Tick | Client 1 Input | Client 2 Input | Next World State   |
| ----------- | ------------- | ------------- | -------------- | -------------- | ------------------ |
| 1           | null          | null          | NONE           | NONE           | 2 (Missing Inputs) |
| 2           | 1             | null          | OLD/INVALID    | NONE           | 3 (Missing Inputs) |
| 3           | 2             | 1             | OLD/INVALID    | OLD/INVALID    | 4 (Missing Inputs) |
| 4           | 3             | 2             | OLD/INVALID    | OLD/INVALID    | 5 (Missing Inputs) |
Each Next World State will generate the next tick, but client 1 and client 2 inputs at given ticks are not there to be processed.

A solution that we will work towards is making the client operate in the future to account for any delays. However, this means we will have to predict the future state of the game, and we all know, predictions can be wrong. But, HOW wrong is the future? In Client 1's case, in order for his packets to arrive on time, he has to be 1 tick in the future. In Client 2's case, he has to be 2 ticks in the future which may be more inaccurate than Client 1 at times. But the goal is for the following...

| Server Tick | Client 1 Tick | Client 2 Tick | Client 1 Input | Client 2 Input | Next World State |
| ----------- | ------------- | ------------- | -------------- | -------------- | ---------------- |
| 1           | 1             | 1             | VALID          | VALID          | 2 (No Problems)  |
| 2           | 2             | 2             | VALID          | VALID          | 3 (No Problems)  |

### Extrapolation World (Linear)

Another client-side world where we have to predict the future. (still no physics or game logic) Well interpolations older brother extrapolation (or is that the other way around?) is here to help. At times, Linear Extrapolation will be far from accurate. But this is a good starting point for predicting the future. Much like interpolation, we'll have to figure out how far in the future we need consider, which will basically be the reverse of interpolation tick. `extrapolation_tick = prediction_tick + delay + send_rate`. Note: We are adding time, and we are using send_rate instead of receive_rate (in case they differ, which they usually do).

We also need some kind of estimate on change in value. If using physics objects, linear_velocity and angular_velocity are good estimates. Hence one prediction can be `position = received_position + (extrapolation_time - received_time) * linear_velocity`.

This has no collision checking or smoothness between receiving packets. Hence the image will jump around if the estimates are wrong, which they often will be. But we now have a good estimate of how much in the future the client needs to operate for smooth gameplay on the server, and ~~pretty good~~ so/so guess of where objects should be given the most recent packet.

### Prediction World

At this point, we know what data we are receiving from the server. We know how to smooth that out via **Interpolation World**. We know how to kind-of predict the future time (*cough* *cough*, I mean client current time) via **Extrapolation World**. So, are we done? Nope. In fact, trying to play the game in **Extrapolation World** is just awful. We need a GOOD prediction that feels right. Hence, no more mr. dumb client... We are running all Physics and Game Logic straight on the client.

Are we throwing out everything we've done thus far? Well, kind-of? **Interpolation World** has its use cases (more for like observation instead of interaction while not using heavy resources to predict the world). **Extrapolation World** can be used to help with prediction misses/server reconciliation, but not really useful in actual gameplay. So... yeah, this will start off as a brand new world.

Much like Server World, we start off with Asteroids and Ships. The server will tell us which ship we are controlling and the initial transform and velocities of our objects. Simulation starts. Hence both server and client are running the same physics simulation code and game logic code. If the entire world was deterministic, we would know exactly what the world at the next step would look like. Besides some internal non-determinism in physics engine, rounding problems, etc... the biggest non-deterministic behavior is the other players! So there is truly no way to predict exactly what is going to happen in the next steps given your input and the game code. So here's our process  then.

Simulate the world in the future. When receiving packets about the past, check them against our history. If they match! Great! Keep on keeping-on! Otherwise, report a "prediction miss"! Before the simulation can continue, we have to figure out how to correct our mistakes... in comes server reconciliation.

### Server Reconciliation (Physics World, Extrapolation World)

Move towards Extrapolation World, slowly, not to rattle the player.

### Server Reconciliation (Physics World, Physics Resimulation World)

Move towards Physics Resimulation World, slowly, not to rattle the player.