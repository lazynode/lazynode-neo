FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

COPY neo.diff /tmp/neo.diff

RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo-node.git /tmp/neo-node
RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo.git /tmp/neo
RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo-modules.git /tmp/neo-modules
RUN cd /tmp/neo && git apply /tmp/neo.diff
RUN cd /tmp/neo-node/neo-cli && dotnet remove package Neo && dotnet add reference /tmp/neo/src/Neo/Neo.csproj && dotnet publish --sc --os linux -c Release -o /neo
RUN cd /tmp/neo-modules/src/LevelDBStore && dotnet build -c Release -o /neo/Plugins/LevelDBStore

FROM debian:stable-slim

COPY --from=build /neo /neo

RUN apt-get update && apt-get install -y libleveldb-dev

WORKDIR /workspace
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
CMD /neo/neo-cli
