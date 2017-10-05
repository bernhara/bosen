// Author: Dai Wei (wdai@cs.cmu.edu), Pengtao Xie (pxie@cs.cmu.edu)
// Date: 2014.10.21

#include <ml/util/math_util.hpp>
#include <glog/logging.h>
#include <sstream>
#include <Eigen/Dense>

// use libc defined math functions which contains machine optimized math functions
#include <math.h>

namespace petuum {
  namespace ml {

    namespace {

      const float kCutoff = 1e-15;

    }  // anonymous namespace

    // use libc-math functions are imtimally implemented
    float optimized_exp (const float& f) {
      return ::expf (f);
    }

    float optimized_log (const float& f) {
      return ::logf (f);
    }

    float SafeLog(float x) {
      if (std::abs(x) < kCutoff) {
	x = kCutoff;
      }
      return optimized_log(x);
    }

    float Sigmoid(float x) {
      return 1. / (1. + optimized_exp(-x));
    }

    float LogSum(float log_a, float log_b) {
      return (log_a < log_b) ? log_b + optimized_log(1 + optimized_exp(log_a - log_b)) :
	log_a + optimized_log(1 + optimized_exp(log_b-log_a));
    }

    float LogSumVec(const std::vector<float>& logvec) {
      float sum = 0.;
      sum = logvec[0];
      for (int i = 1; i < logvec.size(); ++i) {
	sum = LogSum(sum, logvec[i]);
      }
      return sum;
    }

    void Softmax(std::vector<float>* vec) {
      CHECK_NOTNULL(vec);
      // TODO(wdai): Figure out why this is necessary. Doubt it is.
      for (int i = 0; i < vec->size(); ++i) {
	if (std::abs((*vec)[i]) < kCutoff) {
	  (*vec)[i] = kCutoff;
	}
      }
      double lsum = LogSumVec(*vec);
      for (int i = 0; i < vec->size(); ++i) {
	(*vec)[i] = optimized_exp((*vec)[i] - lsum);
	//(*vec)[i] = exp((*vec)[i] - lsum);
	(*vec)[i] = (*vec)[i] > 1 ? 1. : (*vec)[i];
      }
    }

    float DenseDenseFeatureDotProduct(const AbstractFeature<float>& f1,
				      const AbstractFeature<float>& f2) {
      CHECK_EQ(f1.GetFeatureDim(), f2.GetFeatureDim());
      auto f1_dense_ptr = static_cast<const DenseFeature<float>*>(&f1);
      auto f2_dense_ptr = static_cast<const DenseFeature<float>*>(&f2);
      const std::vector<float>& v1 = f1_dense_ptr->GetVector();
      const std::vector<float>& v2 = f2_dense_ptr->GetVector();
      Eigen::Map<const Eigen::VectorXf> e1(v1.data(), v1.size());
      Eigen::Map<const Eigen::VectorXf> e2(v2.data(), v2.size());
      return e1.dot(e2);
    }

    float SparseDenseFeatureDotProduct(const AbstractFeature<float>& f1,
				       const AbstractFeature<float>& f2) {
      CHECK_EQ(f1.GetFeatureDim(), f2.GetFeatureDim());
      float sum = 0.;
      for (int i = 0; i < f1.GetNumEntries(); ++i) {
	int32_t f1_fid = f1.GetFeatureId(i);
	sum += f1.GetFeatureVal(i) * f2[f1_fid];
      }
      return sum;
    }

    float DenseSparseFeatureDotProduct(const AbstractFeature<float>& f1,
				       const AbstractFeature<float>& f2) {
      return SparseDenseFeatureDotProduct(f2, f1);
    }

    float SparseSparseFeatureDotProduct(const AbstractFeature<float>& f1,
					const AbstractFeature<float>& f2) {
      CHECK_EQ(f1.GetFeatureDim(), f2.GetFeatureDim());
      int j = 0;
      float sum = 0.;
      int f2_num_entries = f2.GetNumEntries();
      for (int i = 0; i < f1.GetNumEntries() && j < f2_num_entries; ++i) {
	int32_t f1_fid = f1.GetFeatureId(i);
	while (f2.GetFeatureId(j) < f1_fid && j < f2_num_entries) {
	  ++j;
	}
	if (f1_fid == f2.GetFeatureId(j)) {
	  sum += f1.GetFeatureVal(i) * f2.GetFeatureVal(j);
	}
      }
      return sum;
    }

    void FeatureScaleAndAdd(float alpha, const DenseFeature<float>& f1,
			    DenseFeature<float>* f2) {
      CHECK_EQ(f1.GetFeatureDim(), f2->GetFeatureDim());
      const std::vector<float>& f1_vec = f1.GetVector();
      std::vector<float>& f2_vec = f2->GetVector();
      for (int i = 0; i < f1_vec.size(); ++i) {
	f2_vec[i] += alpha * f1_vec[i];
      }
    }

    // f1 sparse, f2 dense.
    void FeatureScaleAndAdd(float alpha, const AbstractFeature<float>& f1,
			    AbstractFeature<float>* f2) {
      CHECK_EQ(f1.GetFeatureDim(), f2->GetFeatureDim());
      for (int i = 0; i < f1.GetNumEntries(); ++i) {
	int32_t f1_fid = f1.GetFeatureId(i);
	f2->SetFeatureVal(f1_fid, alpha * f1.GetFeatureVal(i) + (*f2)[f1_fid]);
      }
    }



  }  // namespace ml
}  // namespace petuum
