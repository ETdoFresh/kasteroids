docker build . -t etdofresh/kasteroids
docker push etdofresh/kasteroids
docker save -o kasteroids.tar etdofresh/kasteroids