#!/bin/bash 

${IT_HOME}/scripts/user/enqueue_compss \
  --exec_time=$2 \
  --num_nodes=$1 \
  --queue_system=lsf \
  --tasks_per_node=16 \
  --master_working_dir=. \
  --worker_working_dir=scratch \
  --lang=python \
  --node_memory=high \
  --pythonpath=/home/bsc31/bsc31991/workspace_pycompss/ \
  --library_path=/gpfs/apps/MN3/INTEL/mkl/lib/intel64 \
  --comm=integratedtoolkit.nio.master.NIOAdaptor \
  --tracing=true \
  --graph=true \
  /home/bsc31/bsc31991/workspace_pycompss/matmul.PyCOMPSs.py $3 $4

# 2x2 blocks of size 8x8 = 16x16 matrix
# ./Launch.matmul.Marenostrum.sh 2 30 2 8
