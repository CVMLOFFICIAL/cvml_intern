# Example: bash build_docker_intern.sh gildong pytorch/pytorch:1.8.1-cuda10.2-cudnn7-runtime
# Args: bash build_docker.sh {your name} {image tag}
# Argument link
MYNAME=$1
MYUNAME=user_intern
MYGNAME=cvml_intern
MYUID=4001
MYGID=2501
DOCKER_TAG=$2
BUILD_DATE=`date`
# Integrity check
## host file
if grep -oq -i cvmldocker /etc/hosts
then
echo HOST FILE SETUP: [OK]
else
echo HOST FILE SETUP: [FAIL]
echo "FAIL MESSAGE: Please add 'cvmldocker XXX.XXX.XXX.XXX' in /etc/hosts file."
exit 1
fi

## certificate
if test -e /etc/docker/certs.d/cvmldocker:5000/server.crt
then
echo "CERTIFICATE: [OK]"
else
echo "CERTIFICATE: [FAIL]"
echo "FAIL MESSAGE: Please add 'server.crt' in '/etc/docker/certs.d/cvmldocker:5000' directory."
exit 2
fi
SLASH_COUNT=`grep -o -i / <<< $DOCKER_TAG | wc -l`
IMAGE_NAME=$(cut -d'/' -f$((SLASH_COUNT+1)) <<<"$DOCKER_TAG")
echo IMAGE NAME: cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME

echo [EXEC] mkdir -p docker_build/$DOCKER_TAG
mkdir -p docker_build/$DOCKER_TAG

echo "FROM $DOCKER_TAG
RUN echo '[ ! -z \"$TERM\" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc
RUN echo \"\\033[1;37;43mBUILD DATE: $BUILD_DATE \\nIMAGE: $DOCKER_TAG\\033[0;0m\" > /etc/motd
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com/http:\/\/kr\.archive\.ubuntu\.com/' /etc/apt/sources.list
RUN apt-get update && apt-get install -y sudo
RUN apt-get install -y nano
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
RUN apt-get install -y tzdata
RUN adduser -u $MYUID --disabled-password --gecos \"\" $MYUNAME && echo '$MYUNAME:$MYUNAME' | chpasswd && adduser $MYUNAME sudo && echo '$MYUNAME ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN groupadd -r -g $MYGID cvml_intern
RUN adduser $MYUNAME cvml_intern
USER $MYUID:$MYGID
ENV PATH=\"\${PATH}:/home/$MYUNAME/.local/bin\"
RUN mkdir ~/.pip
RUN printf \"[global]\nindex-url=http://ftp.daumkakao.com/pypi/simple\ntrusted-host=ftp.daumkakao.com pypi.org\nextra-index-url=http://pypi.org/simple\" > ~/.pip/pip.conf
ENV TERM=\"xterm-256color\"
">docker_build/$DOCKER_TAG/Dockerfile

echo "------------------"
echo "Dockerfile preview"
echo "------------------"
cat docker_build/$DOCKER_TAG/Dockerfile
echo "------------------"

echo [EXEC] docker build -t cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME docker_build/$DOCKER_TAG
docker build -t cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME docker_build/$DOCKER_TAG
echo [EXEC] docker push cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME
docker push cvmldocker:5000/intern/$MYNAME-$IMAGE_NAME
