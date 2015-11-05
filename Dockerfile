FROM phusion/holy-build-box-64
# Install TeX, CUDA 7.0, AMD APP SDK 2.9-1


ADD http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/rpmdeb/cuda-repo-rhel6-7-0-local-7.0-28.x86_64.rpm .
ADD http://jenkins.choderalab.org/userContent/AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 .
ADD http://download.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm .
ADD http://ctan.mackichan.com/systems/texlive/tlnet/install-tl-unx.tar.gz .
ADD texlive.profile .

RUN rpm -i --quiet epel-release-5-4.noarch.rpm && \
    rm -rf /epel-release-5-4.noarch.rpm \
    yum install -y --quiet dkms libvdpau git wget &&  \
    tar -xzf install-tl-unx.tar.gz && \
    cd install-tl-* &&  ./install-tl -profile texlive.profile && cd - && \
    rm -rf install-tl-unx.tar.gz install-tl-* && \
    rpm --quiet -i cuda-repo-rhel6-7-0-local-7.0-28.x86_64.rpm && \
    yum install -y --quiet cuda-core-7-0-7.0-28.x86_64 cuda-cufft-dev-7-0-7.0-28.x86_64 cuda-cudart-dev-7-0-7.0-28.x86_64 && \
    rpm --quiet --nodeps -Uvh /var/cuda-repo-7-0-local/xorg-x11-drv-nvidia-libs-346.46-1.el6.x86_64.rpm && \
    rpm --quiet --nodeps -Uvh /var/cuda-repo-7-0-local/xorg-x11-drv-nvidia-devel-346.46-1.el6.x86_64.rpm && \
    ln -s /usr/include/nvidia/GL/  /usr/local/cuda-7.0/include/ && \
    yum clean -y --quiet expire-cache && \
    yum clean -y --quiet all && \
    rm -rf /cuda-repo-rhel6-7-0-local-7.0-28.x86_64.rpm /var/cuda-repo-7-0-local/ /var/cache/yum/cuda-7-0-local/ && \
    tar xjf AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 && \
    ./AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh -- -s -a yes && \
    rm -rf  /AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh /AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 && \
    rm -rf /opt/AMDAPPSDK-2.9-1/samples/

ENV PATH=/usr/local/texlive/2015/bin/x86_64-linux:$PATH
ENV OPENCL_HOME=/opt/AMDAPPSDK-2.9-1 OPENCL_LIBPATH=/opt/AMDAPPSDK-2.9-1/lib/x86_64