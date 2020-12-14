#https://hub.docker.com/r/jupyter/datascience-notebook/tags/
FROM jupyter/datascience-notebook:lab-2.1.1

RUN conda install --yes -c conda-forge dipy fury && conda clean --all -f -y && fix-permissions $CONDA_DIR

#let's create our own user to run 
#RUN groupadd -r brlife && adduser brlife
#USER brlife

#for color in the terminal?
COPY .bashrc /home/jovyan/.bashrc
