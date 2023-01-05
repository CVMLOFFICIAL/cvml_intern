### Docker builder
File: `build_docker_intern.sh`

1. Timezone to Asia/Seoul
2. apt source to kr.archive.ubuntu.com
3. Python package mirror to kakao
4. Allow sudo command
5. Map UID/GID


### Docker builder intern usage

First, you can create image for a workspace for debugging.

Use command below:

```bash
# Args: bash build_docker_intern.sh {your name} {image tag}
# Example
bash build_docker_intern.sh gildong pytorch/pytorch:1.8.1-cuda10.2-cudnn7-runtime
```

This code will create `cvmldocker:5000/intern/gildong-pytorch:1.8.1-cuda10.2-cudnn7-runtime-workspace` using `cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME-workspace` template.


