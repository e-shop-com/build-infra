# Docker container for Ubuntu 18.04

FROM  ubuntu:18.04
MAINTAINER build-team@couchbase.com

USER root

# Install SSH server
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    apt-get clean && \
    mkdir /var/run/sshd

# Create couchbase user with password-less sudo privs, and give
# ownership of /opt/couchbase
RUN useradd couchbase -G sudo -m -s /bin/bash && \
    mkdir -p /opt/couchbase && chown -R couchbase:couchbase /opt/couchbase && \
    echo 'couchbase:couchbase' | chpasswd && \
    sed -ri 's/ALL\) ALL/ALL) NOPASSWD:ALL/' /etc/sudoers

# Install Couchbase Lite Android toolchain requirements
RUN apt-get update && \
    apt-get install -y git-core tar curl unzip gcc-multilib g++-multilib lib32z1 lib32stdc++6 openjdk-8-jdk gnupg2 zip && \
    apt-get clean

# Update locale
RUN apt-get update && \
    apt-get install -y locales && \
    apt-get clean && \
    locale-gen en_US.UTF-8

# Set LANG
ENV LANG=en_US.UTF-8

# Expose SSH daemon and run our builder startup script
EXPOSE 22
ADD .ssh /home/couchbase/.ssh
COPY build/couchbuilder_start.sh /usr/sbin/
ENTRYPOINT [ "/usr/sbin/couchbuilder_start.sh" ]
CMD [ "default" ]

# Android SDK
USER couchbase

# Download and untar Android SDK tools
# https://developer.android.com/studio/index.html#downloads (under sdk-tool-linux)
ENV SDK_TOOLS_LINUX_VERSION=4333796
RUN mkdir -p /home/couchbase/jenkins/tools && \
    cd /home/couchbase/jenkins/tools && \
    wget --no-check-certificate https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_LINUX_VERSION}.zip -O android-sdk.zip && \
    unzip android-sdk.zip -d android-sdk  && \
    rm android-sdk.zip && \
    chown -R couchbase:couchbase android-sdk && \
    chmod 755 android-sdk

# Set environment variable
ENV ANDROID_HOME /home/couchbase/jenkins/tools/android-sdk
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:${ANDROID_HOME}/tools/bin:$PATH

# Android SDK License
RUN yes 'y' | sdkmanager --licenses >/dev/null

# Update and install using sdkmanager
ENV SDK_CMD $ANDROID_HOME/tools/bin/sdkmanager
RUN $SDK_CMD "tools" "platform-tools" && \
    $SDK_CMD "build-tools;28.0.3" && \
    $SDK_CMD "build-tools;29.0.0" && \
    $SDK_CMD "build-tools;29.0.2" && \
    $SDK_CMD "platforms;android-29" && \
    $SDK_CMD "extras;android;m2repository" "extras;google;m2repository" && \
    $SDK_CMD "cmake;3.10.2.4988404"

# Revert so CMD will run as root.
USER root
