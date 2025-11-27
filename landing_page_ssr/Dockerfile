# Stage 1: Build the Jaspr server (need Flutter for jaspr_web_compilers)
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Activate the jaspr cli
RUN dart pub global activate jaspr_cli

WORKDIR /app

# Copy project files
COPY pubspec.yaml .

# Remove workspace resolution if exists
RUN sed -i '/resolution: workspace/d' pubspec.yaml || true

# Get dependencies
RUN dart pub get

# Copy source files
COPY lib lib
COPY web web

# Build project
RUN dart pub global run jaspr_cli:jaspr build --verbose

# This image is needed for the dart runtime libs
FROM dart:stable AS dart

# Stage 2: Create a smaller runtime image
FROM scratch AS runtime

# Copy all the needed runtime libraries for dart
COPY --from=dart /runtime/ /

# Copy the build outputs
COPY --from=build /app/build/jaspr/ /app/

WORKDIR /app

# Start the server
EXPOSE 8080
CMD ["./app"]
