TOMCAT_VERSION="10.1"
RELEASE=$(date +"%Y.%m.%d-%s")

for JAVA_MAJOR_VERSION in 11 17 21
  do
    podman build -t tomcat${TOMCAT_VERSION}-java${JAVA_MAJOR_VERSION}:${RELEASE} --build-arg TOMCAT_MAJOR_VERSION=${TOMCAT_VERSION} --build-arg OPENJDK_MAJOR_VERSION=${JAVA_MAJOR_VERSION} --label openjdk.version=${JAVA_MAJOR_VERSION} --label tomcat.version=${TOMCAT_VERSION} .
done
