# net-monitor
The sample `net-monitor` software, used as samples in the [Notary v2 Scenarios](https://github.com/notaryproject/requirements/blob/main/scenarios.md)

## Building

```dockerfile
docker build -t myregistry.myregistrydomain.io/net-monitor:v1 .
```

## See the artifacts which exist under the image

```shell
$ oras discover wabbitnetworks.azurecr.io/github/net-monitor:main -o tree
wabbitnetworks.azurecr.io/github/net-monitor:main
├── org.example.sarif.v0
│   └── sha256:81336c557289d74ddd5243d7e4026ea4afa4c5c5bd7d15706412d0e0ffb9d390
│       └── application/vnd.cncf.notary.v2.signature
│           └── sha256:58310d6360550ca4d1ec209e6dfbcd0f1fa9e2d4f5592bf4fa2371b0924ba51b
├── org.example.sbom.v0
│   └── sha256:5fb8e1f32f19a867990c9ee6a995de822de70ddcfbf0196042a9bf77067fff35
│       └── application/vnd.cncf.notary.v2.signature
│           └── sha256:75d0c46e68a62c29f7a0355d7bd61083a949e4f17d1befe78e274e3262dc3685
└── application/vnd.cncf.notary.v2.signature
    └── sha256:f44fd0f2984b8030bdc32622bd7191898f8d45065dd5ae7d4ddc0249f151d310

# Pull the trivy-results.sarif file local
oras pull -o . wabbitnetworks.azurecr.io/github/net-monitor@sha256:81336c557289d74ddd5243d7e4026ea4afa4c5c5bd7d15706412d0e0ffb9d390
# Pull the SBOM manifest.json file local
oras pull -o . wabbitnetworks.azurecr.io/github/net-monitor@sha256:5fb8e1f32f19a867990c9ee6a995de822de70ddcfbf0196042a9bf77067fff35
```

## Validate the signatures of the image and artifacts

```shell
# Trust the public key these images were signed with
curl -Lo wabbit-networks-public.crt https://github.com/wabbit-networks/net-monitor/raw/main/wabbit-networks-io.crt 
notation cert add --name "Wabbit networks public cert" wabbit-networks-public.crt
# Validate the signatures
## The image itself
notation verify wabbitnetworks.azurecr.io/github/net-monitor:main
## The Vulnerability Scan
notation verify wabbitnetworks.azurecr.io/github/net-monitor@sha256:81336c557289d74ddd5243d7e4026ea4afa4c5c5bd7d15706412d0e0ffb9d390
## The SBOM
wabbitnetworks.azurecr.io/github/net-monitor@sha256:5fb8e1f32f19a867990c9ee6a995de822de70ddcfbf0196042a9bf77067fff35
```
