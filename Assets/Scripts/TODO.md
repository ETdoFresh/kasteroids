## Tasks
- [ ] Set Name
- [ ] Join game
- [ ] Leave game [not disconnect]
- [ ] Get Player Id/Number [instead of state?]
- [ ] Add Server State [Ready, Running, Loading, etc, etc]
- [ ] Handle Disconnects
- [ ] Disconnect
- [X] Put name into State
- [X] Show Name above Ship
- [X] Set Default Name
- [X] Get Name
- [X] Send Inputs
- [X] Get Updates

## Ideal Sample Communication

### User Database
- Start webserver
- Have a database of users
- Each user has a GUID
- Can generate special tokens for games (per device?)
- Can 2FA with Authy or SMS or Email
- Maybe skip for now, have just special guest token

### Matchmaker Listens
- Matchmaker starts
- Matchmaker ensures at least 1 game session is open
- Matchmaker listens for clients to connect
- Load balance
- List Servers

### Client Requests Match from Matchmaker
- Sends userid and desired settings to Matchmaker
- Matchmaker sends server info to client
- Is this a JSON file that sent to matchmaker and back?

### Client Connects to Game
- Set Name [Default name: Guest###]
- Join game
- Get Player Id/Number
- Send Inputs
- Get Updates
- Handle Disconnects
- Disconnect

### In Game Admin Commands
- AddAsteroid
- AddBot
- SetShipColor
- SetAsteroidColor
- SetMaxSpeed
- SetForce
- ListAsteroids
- ListShips
- ListBullets
- SetBulletSpeed
- SetBulletScale