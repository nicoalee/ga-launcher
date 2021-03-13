#https://hub.docker.com/r/jupyter/datascience-notebook/tags/
FROM jupyter/datascience-notebook:lab-2.1.1
#FROM jupyter/datascience-notebook:lab-3.0.9  #can't get jupyterlab-git to work with this version

RUN conda install --yes -c conda-forge dipy==1.3.0 fury \
    && jupyter lab build \
    && conda clean --all -f -y \
    && fix-permissions $CONDA_DIR

#let's create our own user to run 
#RUN groupadd -r brlife && adduser brlife
#USER brlife

RUN jupyter labextension update --all

RUN pip install --upgrade jupyterlab-git
RUn jupyter labextension install nbdime-jupyterlab
RUN jupyter labextension install @jupyterlab/git

#RUN jupyter server extension enable --py jupyterlab_git
#RUN jupyter labextension list

#for color in the terminal?
COPY .bashrc /home/jovyan/.bashrc
