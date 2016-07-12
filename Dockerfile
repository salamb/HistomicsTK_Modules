
# This is a Dockerfile that extends an installation of itk and modules
#in the dsarchive/histomicstk:v0.1.3 


FROM salamb/histomicstk:itk

MAINTAINER Bilal Salam <bilal.salam@kitware.com>

WORKDIR $htk_path

RUN python setup.py install 


#Add to the server module and replace the jsonfile
#TODO append to an image by editing the original json file 
#instead of replacing it
CMD modules= find $(pwd) -maxdepth 1 -type d 

COPY $modules $htk_path/server
COPY slicer_cli_list.json $htk_path/server
WORKDIR $htk_path


# define entrypoint through which all CLIs can be run
WORKDIR $htk_path/server
ENTRYPOINT ["/build/miniconda/bin/python", "cli_list_entrypoint.py"]


