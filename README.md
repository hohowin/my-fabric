
# Hyperledger Fabric 4 CAs Setup

`<Reference>` : <https://hyperledger-fabric-ca.readthedocs.io/en/latest/operations_guide.html>

Prerequsites: docker and docker-compose

***

## Topology

![Logical Topology](config/logical_topology_raft.png)

***

## Setup Fabric Network

To start the network, run the start command.
(Note: It may asks you for the sudo password to perform the copy and cleanup jobs)

```bash
./start.sh
```

```console
2019-12-04 09:15:43.664 UTC [msp.identity] Sign -> DEBU 03c Sign: plaintext: 0ACE080A5C08031A0C08BFF29DEF0510...6E496E666F0A096D796368616E6E656C
2019-12-04 09:15:43.664 UTC [msp.identity] Sign -> DEBU 03d Sign: digest: FF6F1ED2B403296BADD42899EC8248CF229BFDAD41AD9A899BF22C28BE095A4A
Blockchain info: {"height":1,"currentBlockHash":"/6tan/EbdYXfSSDV2DYcEUf8IdfEBWbB4vpNkmQP4lc="}
The network is started.
```

***

## Install and instaniate chaincode

```bash
./installcc.sh
```

***

## Clean Up

If everything is good, we can clean up the environment. :tada::tada:

```bash
./cleanup.sh
```

***

## FAQ

The binaries are in *Linux* version. In case you are working with another OS and the executables in *bin* directory do not work, please download the hyperledger fabric sample code and copy the corresponding executables to the *bin* directory.

```console
curl -sSL http://bit.ly/2ysbOFE | bash -s
```