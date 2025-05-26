# Use the official Arch Linux base image
FROM archlinux:latest

# Set environment variables for locale and Android SDK paths
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Install necessary packages for Android SDK and Java
RUN pacman -Syu --noconfirm && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -S --noconfirm \
    jdk17-openjdk \
    unzip \
    curl \
    git \
    wget \
    && export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::") \
    && export PATH="$PATH:$JAVA_HOME/bin" \
    \
    # Install Android SDK Command Line Tools (latest stable version)
    && curl -o /tmp/commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && unzip /tmp/commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm /tmp/commandlinetools.zip \
    \
    # Accept Android SDK licenses automatically
    && yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses \
    \
    # Install specific SDK components required for your project
    && ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
       "platform-tools" \
       "build-tools;34.0.0" \
       "platforms;android-34" \
    \
    # Clean up to reduce image size
    && pacman -Sc --noconfirm \
    && rm -rf /var/cache/pacman/pkg/*

WORKDIR /app

CMD ["bash"]
