<div id="top">

<!-- HEADER STYLE: CLASSIC -->
<div align="center">

# TECODA

**A Comprehensive MATLAB Library for Tensor Computation for Data Analysis**

</div>
<br>

## software packages for the textbook:

Yipeng Liu, Jiani Liu, Zhen Long, Ce Zhu, Tensor Computation for Data Analysis, New York, USA: Springer, 2022. 

## Overview


**TECODA** is a comprehensive MATLAB library designed for researchers and practitioners working with multi-dimensional data. It provides:

- **Core tensor operations** (tensor products, unfolding, etc.)
- **Multiple tensor decomposition methods** (CP, Tucker, Tensor-Ring, T-SVD, BTD, and more)
- **Optimization algorithms** (ADMM, ALS, gradient descent, proximal operators)
- **Real-world applications** including tensor completion, dictionary learning, regression, RPCA, and subspace clustering
- **Benchmark datasets** for evaluation and testing



---

## Quick Start

### Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/yipengliu/tecoda.git
    cd tecoda
    ```

2. **Add to MATLAB path:**

    ```matlab
    addpath(genpath('path/to/tecoda'))
    ```

### Basic Usage Example

```matlab
% Example 1: CP Decomposition
X = randn(10, 20, 30);  % Create a 3D tensor
R = 5;  % Set rank
T = CP_ALS(X, R);  % Compute CP decomposition with rank 5

% Example 2: Tensor Completion
% Load image and create incomplete tensor
img = imread('image.bmp');
T = im2double(img);
ObsRatio = 30;  % 30% of entries observed
Omega = randperm(prod(size(T)));
Omega = Omega(1:round((ObsRatio/100)*prod(size(T))));
O = zeros(size(T));
O(Omega) = 1;
y = T .* O;  % Observed entries

% Use FBCP for completion
[model] = BCPF_IC(y, 'obs', O, 'maxRank', 90, 'maxiters', 100);
X_recovered = double(model.X);  % Recovered tensor

% Example 3: Tucker Decomposition (HOSVD)
T_hosvd = HOSVD(X, [5, 5, 5]);  % Tucker rank [5, 5, 5]
```

---

## Project Structure

```sh
└── tecoda/
    ├── application/              # High-level applications
    │   ├── tensor completion/    # Data recovery algorithms (FBCP, HaLRTC, etc.)
    │   ├── tensor dictionary learning/  # Sparse coding and dictionary learning
    │   ├── tensor regression/    # Regression tasks (age estimation, etc.)
    │   ├── tensor robust PCA/    # Decomposition into low-rank + sparse
    │   └── tensor subspace clustering/  # Clustering algorithms
    │
    ├── core/                     # Fundamental tensor operations
    │   ├── tensor product/       # Various tensor product operations
    │   ├── unfolding/            # Tensor unfolding/matricization methods
    │   └── tp.m                  # Main tensor product interface
    │
    ├── td/                       # Tensor decomposition methods
    │   ├── CPtensor/             # CP (CANDECOMP/PARAFAC) decomposition
    │   ├── TKtensor/             # Tucker decomposition
    │   ├── TRtensor/             # Tensor-Ring decomposition
    │   ├── TTtensor/             # Tensor-Train decomposition
    │   ├── TSVDtensor/           # T-SVD (Tensor Singular Value Decomposition)
    │   ├── BTDtensor/            # Balanced Tucker Decomposition
    │   └── tensor/               # Base tensor class and utilities
    │
    ├── optimization/             # Optimization algorithms
    │   ├── solver/               # Various solvers (ADMM, ALS, gradient descent, etc.)
    │   └── prox/                 # Proximal operators for regularization
    │
    └── database/                 # Benchmark datasets
        ├── color image/          # Image datasets for tensor completion
        ├── gray image/           # MNIST and other datasets
        ├── age_estimation/       # Face images for age estimation
        ├── multi-view datasets/  # Multi-view clustering datasets
        ├── traffic flow/         # Traffic prediction data
        └── recommend system/     # Recommendation system data
```

---

## Core Components

### 1. Tensor Operations (`core/`)
Fundamental building blocks for tensor computations:
- **Tensor Products**: inner, outer, mode-n product, Kronecker product, t-product
- **Unfolding Strategies**: mode-n unfolding, k-unfolding, Lshift, balanced unfolding
- **Tensor Contractions**: Efficient element-wise contractions

### 2. Tensor Decomposition Methods (`td/`)

| Method | Class | Use Cases |
|--------|-------|-----------|
| **CP** | `@CPtensor` | Simple, interpretable decomposition for multi-way arrays |
| **Tucker** | `@TKtensor` | Hierarchical structure; HOSVD for initialization |
| **Tensor-Ring** | `@TRtensor` | Flexible ranks; memory-efficient representation |
| **Tensor-Train** | `@TTtensor` | Low-rank representation; efficient for high-dimensional tensors |
| **T-SVD** | `@TSVDtensor` | Multi-linear singular value decomposition |
| **BTD** | `@BTDtensor` | Block-term decomposition for structured tensors |

### 3. Optimization Algorithms (`optimization/`)

**Solvers:**
- ADMM (Alternating Direction Method of Multipliers)
- ALS (Alternating Least Squares)
- Gradient Descent
- Power Iteration

**Proximal Operators:**
- ℓ1 norm, ℓ2,1 norm
- Nuclear norm, tensor nuclear norm
- Total Variation (TV)

---

## Applications

### Tensor Completion
Recover missing entries in multi-dimensional data. Supported methods:
- **FBCP**: Factorized Bayesian CP
- **HaLRTC**: Higher-order Low-Rank Tensor Completion
- **LibADMM**: ADMM-based completion
- **TMac-TT**: Tensor-Train completion
- **Balanced Tucker Decomposition**

*Use case*: Image inpainting, video recovery, recommender systems

### Tensor Dictionary Learning
Learn overcomplete dictionaries for sparse tensor representation:
- **TDLC**: Tensor Dictionary Learning with Constraints
- **TNDL**: Tensor Nuclear Norm Dictionary Learning
- **DTNN**: Dictionary learning with tensor nuclear norm

*Use case*: Sparse coding, feature extraction, classification

### Tensor Regression
Predict using tensor-structured features:
- **Age Estimation**: Predict age from facial image tensors

*Use case*: Multi-dimensional regression, biomedical applications

### Robust PCA
Decompose tensors into low-rank and sparse components:
- **TRPCA-TNN**: Tensor Robust PCA using tensor nuclear norm

*Use case*: Anomaly detection, surveillance video analysis

### Subspace Clustering
Cluster data using tensor subspace methods

*Use case*: Multi-view data clustering, pattern recognition

---

## Tensor Decompositions

TECODA includes implementations of major tensor decomposition formats:

1. **CP Format**: Simplest decomposition, rank-R sum of outer products
   ```matlab
   T = CP_ALS(X, R, options);
   ```

2. **Tucker Format**: Multi-linear decomposition with core tensor
   ```matlab
   T = HOSVD(X, ranks);  % Or HOOI for optimization
   ```

3. **Tensor-Ring Format**: Ring-structured tensor network
   ```matlab
   T = TR_SVD(X, ranks);
   ```

4. **Tensor-Train Format**: Chain-structured tensor network
   ```matlab
   T = TT_SVD(X, ranks);
   ```

5. **T-SVD Format**: Tensor singular value decomposition
   ```matlab
   T = t_SVD(X, ranks);
   ```

---

## Usage Examples

### Example 1: Image Tensor Completion

```matlab
% Load image
img = imread('airplane.bmp');
T = im2double(img);

% Create observation mask (30% of entries observed)
mask = rand(size(T)) < 0.3;
y = T .* uint8(mask);

% Run completion algorithm
[model] = BCPF_IC(y, 'obs', mask, 'maxRank', 90, 'maxiters', 100);
T_recovered = double(model.X);

% Compute error
error = norm(T(:) - T_recovered(:)) / norm(T(:));
```

### Example 2: Tucker Decomposition

```matlab
% Create sample tensor
X = randn(20, 30, 40);

% HOSVD decomposition with Tucker ranks [10, 15, 20]
T_tucker = HOSVD(X, [10, 15, 20]);

% Optimize with HOOI (Higher Order Orthogonal Iteration)
% T_tucker = HOOI(X, [10, 15, 20], options);
```

### Example 3: Tensor Dictionary Learning

```matlab
% Tensor dictionary learning for sparse representation
% (See application/tensor dictionary learning/ for detailed examples)
```
