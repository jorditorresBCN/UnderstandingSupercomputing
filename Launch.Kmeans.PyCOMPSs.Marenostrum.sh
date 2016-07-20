#/bin/bash 

${IT_HOME}/scripts/user/enqueue_compss \
  --exec_time=$2 \
  --num_nodes=$1 \
  --queue_system=lsf \
  --tasks_per_node=16 \
  --master_working_dir=. \
  --worker_working_dir=scratch \
  --lang=python \
  --pythonpath=/home/bsc31/bsc31991/workspace_pycompss/ \
  --library_path=/gpfs/apps/MN3/INTEL/mkl/lib/intel64 \
  --comm="integratedtoolkit.nio.master.NIOAdaptor" \
  --tracing=true \ # paraver traces
  --graph=true \   # workflow graph 
  /home/bsc31/bsc31991/workspace_pycompss/kmeans.py $3 $4 $5 $6
# change "/home/bsc31/bsc31991/workspace_pycompss/" to a proper path according your account at Marenostrum

# Example with 20480 points, 3 dimensions, 10 centers and 256 fragments
# ./Launch.Kmeans.PyCOMPSs.Marenostrum.sh 2 15 20480 3 10 256
