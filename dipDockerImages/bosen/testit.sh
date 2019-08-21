#! /bin/bash

echo "0 localhost 9999" > /tmp/sole_localhost_hostfile

# train file is the one embedded in the container

export STATS_TARGET_BOSEN_WEIGHTS='num_labels: 7
feature_dim: 54
0:1.47168 1:0.087118 2:-0.214522 3:-0.110338 4:-0.22945 5:-0.24505 6:-0.180653 7:-0.320765 8:0.0749532 9:0.131962 10:1.93477 11:0.403292 12:1.55042 13:-0.0273262 14:-0.00154611 15:-0.0535753 16:-0.00533143 17:-0.0578094 18:-0.000108346 19:-0.00979772 20:-0.0530444 21:0 22:0.146044 23:0.0357332 24:-0.0444407 25:-0.00744244 26:0.16872 27:0 28:0 29:-0.00298371 30:-0.0301325 31:-0.0139292 32:-0.0251146 33:0.406432 34:0 35:0.801202 36:1.15036 37:0.0518522 38:0 39:-0.070054 40:0 41:0 42:0.707187 43:0.216418 44:0.876852 45:0.285895 46:0.503807 47:-0.0655316 48:0.0676787 49:0 50:0 51:-0.275427 52:-0.400072 53:-0.440681 
0:-0.480542 1:-0.107842 2:0.151671 3:0.124201 4:0.0102313 5:0.0557698 6:-0.0114058 7:0.140375 8:0.0704914 9:0.0285014 10:2.73622 11:0.747563 12:2.12479 13:-0.0513423 14:-0.0212867 15:-0.253793 16:-0.159283 17:0.0163618 18:-0.00592875 19:0.0461531 20:0.0862148 21:0 22:0.00831159 23:0.471959 24:0.545868 25:0.753724 26:0.301371 27:0 28:0 29:-0.10404 30:-0.0367723 31:0.0490405 32:0.162295 33:-0.175432 34:0 35:0.289038 36:0.15736 37:0.536472 38:0 39:-0.0108804 40:0 41:0 42:0.998224 43:0.399625 44:-0.0166463 45:0.91756 46:0.815379 47:0.168788 48:-0.00566186 49:0 50:0 51:-0.200078 52:-0.0770982 53:-0.099615 
0:-1.4273 1:0.333451 2:0.579392 3:0.148136 4:0.00197638 5:-0.00401446 6:0.163205 7:0.324542 8:-0.105052 9:-0.28702 10:-0.974207 11:-0.179202 12:-0.776291 13:0.235251 14:0.101522 15:0.426153 16:0.274879 17:0.13632 18:0.0225527 19:-0.125683 20:-0.00284469 21:0 22:-0.0535736 23:-0.238807 24:-0.14015 25:-0.167612 26:-0.219292 27:0 28:0 29:-0.0478463 30:0.134056 31:-0.00733867 32:-0.0101402 33:-0.027045 34:0 35:-0.171695 36:-0.222639 37:-0.11578 38:0 39:-0.0179044 40:0 41:0 42:-0.325652 43:-0.156456 44:-0.118155 45:-0.26284 46:-0.276982 47:-0.0120597 48:-0.0011672 49:0 50:0 51:-0.0332303 52:-0.0264843 53:-0.00855383 
0:-0.0625159 1:-0.0216167 2:0.0204882 3:0.000152739 4:0.0146645 5:0.136369 6:0.0137371 7:0.0284366 8:-0.0105763 9:0.0296121 10:-1.01606 11:-0.249525 12:-1.084 13:-0.159603 14:-0.0105533 15:-0.0534606 16:-0.0167064 17:-0.0492995 18:-0.00188201 19:-0.0539015 20:-0.00700199 21:0 22:-0.0187573 23:-0.133439 24:-0.0714616 25:-0.132342 26:-0.0548487 27:0 28:0 29:-0.00468768 30:-0.0149523 31:-0.00578919 32:-0.0245636 33:-0.0444093 34:0 35:-0.194619 36:-0.226299 37:-0.121435 38:0 39:-0.016997 40:0 41:0 42:-0.349912 43:-0.147678 44:-0.131008 45:-0.259904 46:-0.20312 47:-0.0149822 48:-0.00627184 49:0 50:0 51:-0.0671613 52:-0.0424622 53:-0.0292813 
0:-0.226302 1:-0.159042 2:-0.302833 3:-0.101747 4:0.0890428 5:-0.195016 6:0.0975114 7:0.110715 8:-0.012006 9:0.0286508 10:-0.755665 11:-0.261543 12:-0.858407 13:-0.181882 14:-0.0122814 15:-0.0648004 16:-0.0206062 17:-0.0544387 18:-0.00199263 19:-0.0712612 20:-0.00831101 21:0 22:-0.0297323 23:-0.140523 24:-0.0989776 25:-0.165741 26:-0.0499714 27:0 28:0 29:-0.00662502 30:-0.0203263 31:-0.00974072 32:-0.0285904 33:-0.0499915 34:0 35:-0.206636 36:-0.258048 37:0.0459566 38:0 39:0.155779 40:0 41:0 42:-0.365597 43:0.0182592 44:-0.141434 45:-0.114838 46:-0.200834 47:-0.0152049 48:-0.00712746 49:0 50:0 51:-0.0652152 52:-0.0394801 53:-0.0291662 
0:-1.03498 1:-0.0448243 2:-0.0589784 3:-0.0577247 4:0.244679 5:-0.00500063 6:0.0150272 7:-0.0231758 8:-0.0175091 9:-0.158466 10:-0.993971 11:-0.185505 12:-0.853734 13:0.237211 14:-0.052143 15:0.028783 16:-0.0650035 17:0.0396807 18:-0.0120735 19:0.232088 20:-0.00458057 21:0 22:-0.0434821 23:0.0817492 24:-0.128974 25:-0.160452 26:-0.0793949 27:0 28:0 29:0.167827 30:-0.0221787 31:-0.0096278 32:-0.0164185 33:-0.0368219 34:0 35:-0.166377 36:-0.211614 37:-0.130478 38:0 39:-0.0210979 40:0 41:0 42:-0.332612 43:-0.146983 44:-0.12232 45:-0.24657 46:-0.225095 47:-0.0151618 48:-0.00293079 49:0 50:0 51:-0.0422904 52:-0.036483 53:-0.0149649 
0:1.75996 1:-0.0872446 2:-0.175218 3:-0.00267935 4:-0.131143 5:0.256944 6:-0.0974212 7:-0.260127 8:-0.000300914 9:0.226761 10:-0.931082 11:-0.27508 12:-0.10278 13:-0.0523079 14:-0.00371192 15:-0.029306 16:-0.00794783 17:-0.0308149 18:-0.000567497 19:-0.0175971 20:-0.0104322 21:0 22:-0.0088105 23:-0.0766717 24:-0.0618642 25:-0.120133 26:-0.0665841 27:0 28:0 29:-0.00164411 30:-0.00969361 31:-0.0026149 32:-0.0574677 33:-0.0727322 34:0 35:-0.350914 36:-0.389115 37:-0.266588 38:0 39:-0.018845 40:0 41:0 42:-0.331638 43:-0.183186 44:-0.347289 45:-0.319305 46:-0.413155 47:-0.0458474 48:-0.0445195 49:0 50:0 51:0.683403 52:0.62208 53:0.622263'


/home/dip/bin/mlrWrapper.sh \
    --train_file="/home/dip/datasets/covtype.scale.train.small" \
    --test_file="/home/dip/datasets/covtype.scale.test.small" \
    --num_app_threads=2 \
    \
    --num_comm_channels_per_client=1 \
    --num_clients=1 \
    --client_id=0 \
    --global_data=true \
    --perform_test=true \
    --hostfile="/tmp/sole_localhost_hostfile" \
    --output_file_prefix="/tmp/direct_mlr_out" \
    --num_test_eval=20 \
    --num_batches_per_epoch=5 \
    --num_epochs=20 \
    --lr_decay_rate=0.99 \
    --num_train_eval=10000 \
    --init_lr=0.01 \
    --num_batches_per_eval=10 \
    --lambda=0 \
    "$@"
