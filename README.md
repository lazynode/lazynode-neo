# lazynode-neo

lazynode patch of neo

## build

```sh
docker build . -t lazynode/lazyneo:latest
```

## use

### store the blockchain data to current work directory

```sh
docker run -it --rm --name lazyneo -v "$(pwd)":/workspace lazynode/lazyneo:latest
```

### provide a custom config.json

```sh
docker run -it --rm --name lazyneo -v "$(pwd)":/workspace -v "$(pwd)/config.json":/neo/config.json lazynode/lazyneo:latest
```

### provide a custom plugin/module and config.json

* build your own module to somewhere

```sh
dotnet build -c Release -o $YOUR_MODULE_DIR
```

* mount your module to the docker

```sh
docker run -it --rm --name nextdex3.5.0 -v "$(pwd)":/workspace -v "$(pwd)/config.json":/neo/config.json -v $YOUR_MODULE_DIR:/neo/Plugins/$YOUR_MODULE_DIR lazynode/lazyneo:v3.5.0
```

### fast sync (without data verify)

* download chain.0.acc.zip to current work directory, find package data [here](https://sync.ngd.network/)

* sync data to current directory

```sh
docker run -it --rm --name lazyneo -v "$(pwd)":/workspace lazynode/lazyneo:latest
```

* sync faster without verify

```sh
docker run -it --rm --name lazyneo -v "$(pwd)":/workspace lazynode/lazyneo:latest /neo/neo-cli --noverify
```

## stop

* Ctrl-C
* Ctrl-D
