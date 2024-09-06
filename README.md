# BUILD

./build.sh

# RUN
podman run -it --rm --network host tomcat-10:java11 run

podman run -it --rm --network host tomcat-10:java17 run

podman run -it --rm --network host tomcat-10:java21 run
