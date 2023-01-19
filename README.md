#### 1. Step 1: Build Docker

```commandline
cd face_match/DockerBuildBase/
DOCKER_BUILDKIT=1 docker build --no-cache -t base_face:v1 -f ./Dockerfile .
```

#### 2. Remove Docker:

```commandline
docker stop base_face | xargs docker rm
docker rmi base_face:v1
```
