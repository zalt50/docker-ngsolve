FROM ubuntu:latest

WORKDIR /home/app

RUN echo "trigger rebuild again for 2103!!"

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    software-properties-common && \
    add-apt-repository -y universe && \
    add-apt-repository -y ppa:ngsolve/nightly && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ngsolve \
    npm \
    nodejs \
    vim \
    emacs \
    cmake \
    git \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    notebook==5.* \
    jupyterlab \
    numpy \
    scipy \
    matplotlib \
    ipywidgets \
    psutil \
    pytest

RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN pip3 install --user webgui_jupyter_widgets
RUN jupyter nbextension install --user --py webgui_jupyter_widgets
RUN jupyter nbextension enable --user --py webgui_jupyter_widgets

USER root
#RUN jupyter labextension install --clean /usr/lib/python3/dist-packages/ngsolve/labextension
RUN chown -R ${NB_UID} ${HOME}

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]
USER ${NB_USER}

WORKDIR /home/${NB_USER}
RUN python3 -c "import ngsolve"


CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root" ]
