FROM java:8

ENV SYNTAXNETDIR=/opt/tensorflow PATH=$PATH:/root/bin

RUN mkdir -p $SYNTAXNETDIR \
    && cd $SYNTAXNETDIR \
    && apt-get update \
    && apt-get install git zlib1g-dev file swig python2.7 python-dev python-pip python-mock -y \
    && pip install --upgrade pip \
    && pip install -U protobuf==3.0.0b2 \
    && pip install asciitree \
    && pip install numpy \
    && wget https://github.com/bazelbuild/bazel/releases/download/0.4.3/bazel-0.4.3-installer-linux-x86_64.sh \
    && chmod +x bazel-0.4.3-installer-linux-x86_64.sh \
    && ./bazel-0.4.3-installer-linux-x86_64.sh --user \
    && git clone --recursive https://github.com/tensorflow/models.git \
    && cd $SYNTAXNETDIR/models/syntaxnet/tensorflow \
    && echo -e "\n\n\n\n\n\n\n\n\n" | ./configure \
    && apt-get autoremove -y \
    && apt-get clean

RUN cd $SYNTAXNETDIR/models/syntaxnet \
    && bazel test --genrule_strategy=standalone syntaxnet/... util/utf8/...


ADD http://download.tensorflow.org/models/parsey_universal/English.zip syntaxnet/models/
RUN unzip $SYNTAXNETDIR/models/syntaxnet/syntaxnet/models/English.zip -d $SYNTAXNETDIR/models/syntaxnet/syntaxnet/models/
ENV MODEL_DIR=$SYNTAXNETDIR/models/syntaxnet/syntaxnet/models/syntaxnet/English/

WORKDIR $SYNTAXNETDIR/models/syntaxnet
