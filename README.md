# BUILD

podman build --build-arg OPENJDK_MAJOR_VERSION=17 -t tomcat-10:java17 .

# RUN
podman run -it --network host tomcat-10:java17 run

