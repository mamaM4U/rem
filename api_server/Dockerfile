# Stage 1: Build the Dart Frog server
FROM dart:3.10.1 AS build

WORKDIR /app

# Install dart_frog_cli globally
RUN dart pub global activate dart_frog_cli

# Copy shared package (context is parent directory)
COPY packages/shared /packages/shared
WORKDIR /packages/shared
RUN sed -i '/resolution: workspace/d' pubspec.yaml
RUN dart pub get

# Copy project files & dependencies
WORKDIR /app
COPY api_server/pubspec.yaml .
RUN sed -i '/resolution: workspace/d' pubspec.yaml
COPY api_server/routes routes
COPY api_server/lib lib

# Get dependencies & build Dart Frog
RUN dart pub get
RUN /root/.pub-cache/bin/dart_frog build

RUN mkdir -p bin

# Compile the server to native executable
RUN dart compile exe build/bin/server.dart -o bin/server

# Stage 2: Create a smaller runtime image
FROM scratch AS runtime

# Bring in the Dart AOT runtime dependencies from the Dart SDK image
COPY --from=build /runtime/ /
# Copy CA certificates for HTTPS requests
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /app/bin/server /app/bin/server

# Set working directory
WORKDIR /app

# Start the server
CMD ["/app/bin/server"]
