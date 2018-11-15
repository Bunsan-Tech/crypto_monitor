# CryptoMonitor.Umbrella
# Branch
Crypto Bank 

Features
- Monitoring exchange rate for Bit Coin and Etherum in real time via phoenix channels
- Buy crypto currencies, new users are granted with $10,000 USD
- Sell cryrpto currencies.


# Get dependencies
````
$ mix deps.get
````

# Compile dependencies
````
$ mix deps.compile
````

# Setup users DB

### Users information and balance are stored in a relational DB (Postgresql)

````
$ cd apps/crypto_monitor
$ mix ecto.create -r CryptoMonitor.Repo
$ mix ecto.migrate -r CryptoMonitor.Repo
````

# Setup metrics DB

### Exchange history is stored in a nosql DB (Mnesia)

````
$ cd apps/crypto_monitor
$ mix ecto.create -r CryptoMnesiaMonitor.Repo
$ mix ecto.migrate -r CryptoMnesiaMonitor.Repo
````

# Start Application

````
$ mix phx.server
````
