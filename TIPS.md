# Godot Tips

## Setting Icons

Download rcedit and point Godot > Editor > Editot Settings > Export > Windows > Rcedit path

To convert png to ico that is "acceptable" for windows
```bash
magick convert icon.png -define icon:auto-resize=256,128,64,48,32,16 icon.ico
```

# Docker Tips

To build a Docker image
```bash
docker build PATH_TO_DOCKER_FILE -t TAG{:VERSION}
docker build . -t etdofresh/kasteroids
docker build . -t etdofresh/kasteroids:v2
docker build . -t etdofresh/kasteroids:latest
```

Run docker in background on on machine port 1234 from program port 5678
```bash
docker run -dp 1234:5678 etdofresh/kasteroids
```

Run docker in foreground
```bash
docker run -itp 1234:5678 etdofresh/kasteroids
```

Save docker image for nas
```bash
docker save -o kasteroids.tar etdofresh/kasteroids
```

# SSL/X509/RSA Tips

To convert pem to crt

```bash
openssl x509 -outform der -in cert.pem -out cert.crt
openssl x509 -outform der -in chain.pem -out chain.crt
```

To convert rsa to key

```bash
openssl rsa -in privkey.pem -out privkey.key
```

Verify der files (should return no errors)

```bash
openssl x509 -in cert.crt -inform der -text -noout
openssl x509 -in chain.crt -inform der -text -noout
```

