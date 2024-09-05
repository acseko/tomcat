curl "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/maven-metadata.xml" -O

TOMCAT_VERSION=$(xmlstarlet sel -t -m '//version[starts-with(., "10.1.")]' -v . -n maven-metadata.xml |sort -Vr |head -1)
rm maven-metadata.xml

for JAVA_MAJOR_VERSION in 11 17 21
  do
    podman build -t tomcat-10:java${JAVA_MAJOR_VERSION} --build-arg TOMCAT_VERSION=${TOMCAT_VERSION} --build-arg OPENJDK_MAJOR_VERSION=${JAVA_MAJOR_VERSION} . 
done

