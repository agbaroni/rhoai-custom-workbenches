FROM registry.access.redhat.com/ubi9/python-39:latest

USER 0

RUN dnf -y module reset nodejs \
 && dnf -y module enable nodejs:22

RUN dnf -y install gcc nodejs

RUN curl -JLOk https://github.com/ta-lib/ta-lib/releases/download/v0.6.3/ta-lib-0.6.3-src.tar.gz \
 && tar -xzf ta-lib-0.6.3-src.tar.gz \
 && cd ta-lib-0.6.3 \
 && ./configure \
 && make -j install \
 && cd .. \
 && rm -rf ta-lib-0.6.3 ta-lib-0.6.3-src.tar.gz

USER 1001

COPY --chown=1001:0 run.sh /opt/app-root/bin/

RUN pip install pip --upgrade \
 && pip install TA-Lib \
                apache-airflow \
                boto3 \
                elyra[all] \
                jupyterlab \
                jupyterlab-lsp \
                lckr_jupyterlab_variableinspector \
                matplotlib \
		openpyxl \
                pandas \
                python-lsp-server \
		seaborn \
                scikit-learn \
                scipy \
		statsmodels \
 && fix-permissions /opt/app-root -P \
 && chmod a+x /opt/app-root/bin/run.sh

EXPOSE 8888

ENTRYPOINT [ "run.sh" ]
