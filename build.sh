TOMCAT_VERSION="10.1"

for JAVA_MAJOR_VERSION in 11 17 21
  do
    podman build -t tomcat-10:java${JAVA_MAJOR_VERSION} --build-arg TOMCAT_VERSION=${TOMCAT_VERSION} --build-arg OPENJDK_MAJOR_VERSION=${JAVA_MAJOR_VERSION} --label openjdk.version=${JAVA_MAJOR_VERSION} --label tomcat.version=${TOMCAT_VERSION} .
done
