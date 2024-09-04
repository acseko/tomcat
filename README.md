# BUILD

podman build --build-arg OPENJDK_MAJOR_VERSION=17 -t tomcat-10:java17 .

podman build --build-arg OPENJDK_MAJOR_VERSION=11 -t tomcat-10:java11 .

# RUN
podman run -it --rm --network host tomcat-10:java17 run

podman run -it --rm --network host tomcat-10:java11 run

